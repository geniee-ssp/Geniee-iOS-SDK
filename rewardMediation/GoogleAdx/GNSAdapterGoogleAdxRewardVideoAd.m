//
//  GNSAdapterVungleFullscreenInterstitialAd.m
//  GNAdSDK
//

@import GoogleMobileAds;
#import "GNSAdapterGoogleAdxRewardVideoAd.h"
#import <GNAdSDK/GNSAdNetworkConnectorProtocol.h>
#import <GNAdSDK/GNSAdNetworkExtraParams.h>

static NSString *const kGNSAdapterGoogleAdxInterstitialAdKeyErrorDomain = @"jp.co.geniee.GNSAdapterGoogleAdxRewardVideoAd";
static BOOL loggingEnabled = YES;

@interface GNSAdapterGoogleAdxRewardVideoAd () <UIApplicationDelegate, GADFullScreenContentDelegate>

@property(nonatomic, strong) GNSAdReward *reward;

@property(nonatomic, weak) id<GNSAdNetworkConnector> connector;

@property (nonatomic, retain) NSTimer *timer;

@property(nonatomic, assign) BOOL requestingAd;

@property(nonatomic, strong) GADRewardedAd *gamRewardedAd;


@end

@implementation GNSExtrasGoogleAdx
@end

@implementation GNSAdapterGoogleAdxRewardVideoAd

- (void)ALLog:(NSString *)logMessage {
    if (loggingEnabled) {
        NSLog(@"[INFO]GNSVungleAdapter: %@", logMessage);
    }
}

+ (NSString *)adapterVersion {
    return @"3.1.1";
}

+ (Class<GNSAdNetworkExtras>)networkExtrasClass {
    return [GNSExtrasGoogleAdx class];
}

- (id<GNSAdNetworkExtras>)networkExtrasParameter:(GNSAdNetworkExtraParams *) parameter
{
    GNSExtrasGoogleAdx * extra = [[GNSExtrasGoogleAdx alloc]init];
    extra.adUnitId = parameter.external_link_id;
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
    
    [GADMobileAds.sharedInstance startWithCompletionHandler:nil];
    
    [self.connector adapterDidSetupAd:self];
}

- (void)setTimerWith:(NSInteger)timeout
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self->_timer = [NSTimer scheduledTimerWithTimeInterval:timeout
                                                        target:self
                                                      selector:@selector(sendDidFailToLoadAdWithTimeout)
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

- (void)sendDidFailToLoadAdWithTimeout{
    [self deleteTimer];
    
    NSDictionary *errorInfo = @{ NSLocalizedDescriptionKey : @"Google Ad Manager rewarded video ad loading timeout." };
    NSError *error = [NSError errorWithDomain: kGNSAdapterGoogleAdxInterstitialAdKeyErrorDomain
                                         code: 1
                                     userInfo: errorInfo];
    [self.connector adapter: self didFailToLoadAdwithError: error];
}

- (void)requestAd:(NSInteger)timeout {
    self.requestingAd = YES;
    //Return the result when already loaded
    if ([self isReadyForDisplay]) {
        self.requestingAd = NO;
        [self.connector adapterDidReceiveAd:self];
        return;
    }
    
    // set Timer
    [self setTimerWith:timeout];
    
    self.reward = nil;
    self.gamRewardedAd = nil;
    
    GNSExtrasGoogleAdx *extras = [self.connector networkExtras];
    
    GAMRequest *request = [GAMRequest request];
    [GADRewardedAd
     loadWithAdUnitID:extras.adUnitId
     request:request
     completionHandler:^(GADRewardedAd *ad, NSError *error) {
        if (error) {
            [self deleteTimer];
            [self onErrorWithMessage:[error localizedDescription]];
            
            return;
        }
        self.gamRewardedAd = ad;
        self.gamRewardedAd.fullScreenContentDelegate = self;

        [self deleteTimer];
        [self.connector adapterDidReceiveAd:self];
    }];
}

- (void)presentAdWithRootViewController:(UIViewController *)viewController {
    
    if([self isReadyForDisplay]) {
        [self.gamRewardedAd presentFromRootViewController:viewController
                                 userDidEarnRewardHandler:^{
            
            GNSExtrasGoogleAdx *extras = [self.connector networkExtras];
            
            self.reward = [[GNSAdReward alloc]
                           initWithRewardType: extras.type
                           rewardAmount: extras.amount];
            
            if (self.reward) {
                [self.connector adapter: self didRewardUserWithReward: self.reward];
                self.reward = nil;
            }
            
        }];
    }
}

- (void)stopBeingDelegate {
    self.connector = nil;
}

- (BOOL)isReadyForDisplay
{
    return self.gamRewardedAd != nil && [self.gamRewardedAd canPresentFromRootViewController:nil error:nil];
}

- (void)onErrorWithMessage:(NSString*) message
{
    [self deleteTimer];
    [self ALLog: message];
    NSDictionary *errorInfo = @{ NSLocalizedDescriptionKey : message };
    NSError *error = [NSError errorWithDomain: kGNSAdapterGoogleAdxInterstitialAdKeyErrorDomain
                                         code: 1
                                     userInfo: errorInfo];
    [self.connector adapter: self didFailToLoadAdwithError: error];
}

#pragma GADFullScreenContentDelegate

/// Tells the delegate that the ad failed to present full screen content.
- (void)ad:(nonnull id<GADFullScreenPresentingAd>)ad
    didFailToPresentFullScreenContentWithError:(nonnull NSError *)error {
}

/// Tells the delegate that the ad will present full screen content.
- (void)adWillPresentFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    [self.connector adapterDidStartPlayingRewardVideoAd:self];
}

/// Tells the delegate that the ad dismissed full screen content.
- (void)adDidDismissFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    [self.connector adapterDidCloseAd:self];
    self.gamRewardedAd = nil;
}

@end
