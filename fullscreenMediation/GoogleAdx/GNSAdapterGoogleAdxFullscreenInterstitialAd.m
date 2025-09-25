//
//  GNSAdapterVungleFullscreenInterstitialAd.m
//  GNAdSDK
//
@import GoogleMobileAds;
#import "GNSAdapterGoogleAdxFullscreenInterstitialAd.h"
#import <GNAdSDK/GNSAdNetworkConnectorProtocol.h>
#import <GNAdSDK/GNSAdNetworkExtraParams.h>

static NSString *const kGNSAdapterVungleInterstitialAdKeyErrorDomain = @"jp.co.geniee.GNSAdapterVungleInterstitialAd";
static BOOL loggingEnabled = YES;

@interface GNSAdapterGoogleAdxFullscreenInterstitialAd () <UIApplicationDelegate, GADFullScreenContentDelegate>

@property(nonatomic, weak) id<GNSAdNetworkConnector> connector;

@property (nonatomic, retain) NSTimer *timer;

@property(nonatomic, strong) GAMInterstitialAd *gamInterstitial;

@property(nonatomic, assign) BOOL requestingAd;

@end

@implementation GNSExtrasGoogleAdx
@end

@implementation GNSAdapterGoogleAdxFullscreenInterstitialAd

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
    
    [self ALLog:@"Interstial Ad loading timeout."];
    NSDictionary *errorInfo = @{ NSLocalizedDescriptionKey : @"Interstial Ad loading timeout." };
    NSError *error = [NSError errorWithDomain: kGNSAdapterVungleInterstitialAdKeyErrorDomain
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

    self.gamInterstitial = nil;
    GNSExtrasGoogleAdx *extras = [self.connector networkExtras];
    
    GAMRequest *request = [GAMRequest request];
    [GAMInterstitialAd loadWithAdManagerAdUnitID:extras.adUnitId
                                         request:request
                               completionHandler:^(GAMInterstitialAd *ad, NSError *error) {
        
        if (error) {
            [self deleteTimer];
            [self onErrorWithMessage:[error localizedDescription]];
            
            return;
        }
        self.gamInterstitial = ad;
        self.gamInterstitial.fullScreenContentDelegate = self;
        
        [self deleteTimer];
        [self.connector adapterDidReceiveAd:self];
    }];
}

- (void)presentAdWithRootViewController:(UIViewController *)viewController {
    
    if([self isReadyForDisplay]) {
        [self.gamInterstitial presentFromRootViewController:viewController];
    }
}

- (void)stopBeingDelegate {
    self.connector = nil;
}

- (BOOL)isReadyForDisplay
{
    return self.gamInterstitial != nil && [self.gamInterstitial canPresentFromRootViewController:nil error:nil];
}

- (void)onErrorWithMessage:(NSString*) message
{
    [self deleteTimer];
    [self ALLog: message];
    NSDictionary *errorInfo = @{ NSLocalizedDescriptionKey : message };
    NSError *error = [NSError errorWithDomain: kGNSAdapterVungleInterstitialAdKeyErrorDomain
                                         code: 1
                                     userInfo: errorInfo];
    [self.connector adapter: self didFailToLoadAdwithError: error];
}

#pragma mark - GADFullScreenContentDelegate Delegate Methods

/// Tells the delegate that the ad failed to present full screen content.
- (void)ad:(nonnull id<GADFullScreenPresentingAd>)ad didFailToPresentFullScreenContentWithError:(nonnull NSError *)error {
}

/// Tells the delegate that the ad will present full screen content.
- (void)adWillPresentFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    [self.connector adapterWillPresentScreenInterstitialAd:self];
}

/// Tells the delegate that the ad dismissed full screen content.
- (void)adDidDismissFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    [self.connector adapterDidCloseAd:self];
    self.gamInterstitial = nil;
}

@end
