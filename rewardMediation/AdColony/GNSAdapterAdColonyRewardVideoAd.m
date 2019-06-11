//
//  GNSAdapterAdColonyRewardVideoAd.m
//  GNAdSDK
//

#import "GNSAdapterAdColonyRewardVideoAd.h"
#import <AdColony/AdColony.h>
#import <GNAdSDK/GNSAdNetworkConnectorProtocol.h>
#import <GNAdSDK/GNSAdNetworkExtraParams.h>
#import <GNAdSDK/GNSAdReward.h>

static NSString *const kGNSAdapterAdColonyRewardVideoAdKeyErrorDomain = @"jp.co.geniee.GNSAdapterAdColonyRewardVideoAd";
static BOOL loggingEnabled = YES;


@interface GNSAdapterAdColonyRewardVideoAd () <UIApplicationDelegate>

@property(nonatomic, strong) GNSAdReward *reward;
@property(nonatomic, weak) id<GNSAdNetworkConnector> connector;
@property (nonatomic, retain) NSTimer *timer;
@property(nonatomic, weak) AdColonyInterstitial *_ad;

@end

@implementation GNSExtrasAdColony
@end

@implementation GNSAdapterAdColonyRewardVideoAd

- (void)ALLog:(NSString *)logMessage {
    if (loggingEnabled) {
        NSLog(@"[INFO]GNSAdColonyAdapter: %@", logMessage);
    }
}

+ (NSString *)adapterVersion {
    return @"3.0.0";
}

+ (Class<GNSAdNetworkExtras>)networkExtrasClass {
    return [GNSExtrasAdColony class];
}

- (id<GNSAdNetworkExtras>)networkExtrasParameter:(GNSAdNetworkExtraParams *) parameter
{
    GNSExtrasAdColony * extra = [[GNSExtrasAdColony alloc]init];
    extra.app_id = parameter.external_link_id;
    extra.zone_id = parameter.external_link_media_id;
    extra.type = parameter.type;
    extra.amount = parameter.amount;
    return extra;
}

- (instancetype)initWithAdNetworkConnector:(id<GNSAdNetworkConnector>)connector
{
    self = [super init];
    if (self) {
        self.connector = connector;
    }
    return self;
}

- (void)setUp {
    [self ALLog:[NSString stringWithFormat:@"setUp Adcolony version = %ld", (long)[AdColony version]]];
    [self.connector adapterDidSetupAd:self];
}

- (void)setTimerWith:(NSInteger)timeout
{
    dispatch_async(dispatch_get_main_queue(), ^{
        _timer = [NSTimer scheduledTimerWithTimeInterval:timeout
                                                  target:self
                                                selector:@selector(sendDidFailToLoadRewardVideoWithTimeOut)
                                                userInfo:nil
                                                 repeats:NO];
        
    });
}


- (void)deleteTimer
{
    if (_timer != nil) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)sendDidFailToLoadRewardVideoWithTimeOut{
    [self deleteTimer];
    
    [self ALLog:@"Rewarded video loading Timeout."];
    NSDictionary *errorInfo = @{ NSLocalizedDescriptionKey : @"Rewarded video loading Timeout." };
    NSError *error = [NSError errorWithDomain: kGNSAdapterAdColonyRewardVideoAdKeyErrorDomain
                                         code: 1
                                     userInfo: errorInfo];
    [self.connector adapter: self didFailToLoadAdwithError: error];
}


- (void)requestAd:(NSInteger)timeout  {
    //Return the result when already loaded
    //The isReady will be error when AdColony not configured
    if (_isConfigured && [self isReadyForDisplay]) {
        [self.connector adapterDidReceiveAd:self];
        return;
    }
    
    // set Timer
    [self setTimerWith:timeout];

    _ad_available = NO;

    self.reward = nil;
    GNSExtrasAdColony *extras = [self.connector networkExtras];

    [self ALLog:[NSString stringWithFormat:@"AppId=%@", extras.app_id]];
    [self ALLog:[NSString stringWithFormat:@"ZoneId=%@", extras.zone_id]];
    
    // Need load in main thread
    __weak GNSAdapterAdColonyRewardVideoAd* weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong GNSAdapterAdColonyRewardVideoAd* strongSelf = weakSelf;
        if (!strongSelf) return;

        //Initialize AdColony on initial launch
        [AdColony configureWithAppID:extras.app_id zoneIDs:@[extras.zone_id] options:nil completion:^(NSArray<AdColonyZone *> * zones) {

            //Set the zone's reward handler
            AdColonyZone *zone = [zones firstObject];
            zone.reward = ^(BOOL success, NSString *name, int amount) {

                if (success) {

                    [self ALLog:[NSString stringWithFormat:@"rewarded successfully"]];

                    GNSExtrasAdColony *extras = [self.connector networkExtras];
                    self.reward = [[GNSAdReward alloc]
                                   initWithRewardType: extras.type
                                   rewardAmount: extras.amount];

                    if (self.reward) {
                        [self.connector adapter: self didRewardUserWithReward: self.reward];
                        self.reward = nil;
                    }
                } else {
                    [self ALLog:[NSString stringWithFormat:@"rewarded in failure"]];
                }
            };

            //AdColony has finished configuring, so let's request an interstitial ad
            [self requestInterstitial];
        }];

        _isConfigured = YES;
    });
    
}

- (void)presentAdWithRootViewController:(UIViewController *)viewController {
    //Display our ad to the user
    if (!self._ad.expired) {
        [self._ad showWithPresentingViewController:viewController];
        [self.connector adapterDidStartPlayingRewardVideoAd:self];
    }
}

- (void)stopBeingDelegate {
    self.connector = nil;
}

- (BOOL)isReadyForDisplay
{
    return _ad_available;
}

#pragma mark - AdColony

- (void)requestInterstitial {
    
    GNSExtrasAdColony *extras = [self.connector networkExtras];

    //Request an interstitial ad from AdColony
    [AdColony requestInterstitialInZone:extras.zone_id options:nil

     //Handler for successful ad requests
                                success:^(AdColonyInterstitial* ad) {

                                    //Once the ad has finished, set the loading state and request a new interstitial
                                    ad.close = ^{
                                        self._ad = nil;

                                        [self requestInterstitial];
                                    };

                                    //Interstitials can expire, so we need to handle that event also
                                    ad.expire = ^{
                                        self._ad = nil;

                                        [self requestInterstitial];
                                    };

                                    //Store a reference to the returned interstitial object
                                    self._ad = ad;

                                    [self.connector adapterDidReceiveAd:self];
                                    _ad_available = YES;

                                }

     //Handler for failed ad requests
                                failure:^(AdColonyAdRequestError* error) {

                                    [self.connector adapter: self didFailToLoadAdwithError: error];

                                    [self ALLog:[NSString stringWithFormat: @"GNSAdColonyAdapter Request failed with error: %@ and suggestion: %@", [error localizedDescription], [error localizedRecoverySuggestion]]];
                                }
     ];
}

@end
