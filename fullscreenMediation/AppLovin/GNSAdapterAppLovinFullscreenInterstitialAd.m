//
//  GNSAdapterApplovinFullscreenInterstitialAd.m
//  GNAdFullscreenInterstitialAdapter
//

#import "GNSAdapterAppLovinFullscreenInterstitialAd.h"

#import <AppLovinSDK/ALSdk.h>
#import <AppLovinSDK/ALInterstitialAd.h>

static NSString *const kGNSAdapterApplovinInterstitialAdKeyErrorDomain = @"jp.co.geniee.GNSAdapterApplovinInterstitialAd";
static BOOL loggingEnbale = YES;

@interface GNSAdapterAppLovinFullscreenInterstitialAd()<ALAdLoadDelegate, ALAdDisplayDelegate, ALAdVideoPlaybackDelegate>
@property(nonatomic, weak)id<GNSAdNetworkConnector> connector;
@property(nonatomic, retain) NSTimer *timer;
@property(nonatomic, strong) ALAd *ad;

@end

@implementation GNSExtrasFullscreenApplovin
@end

@implementation GNSAdapterAppLovinFullscreenInterstitialAd

- (void)AllLog:(NSString *)logMessage
{
    if (loggingEnbale) {
        NSLog(@"[INFO]GNSInterstitialAppLovinAdapter: %@", logMessage);
    }
}


#pragma mark - GNSAdNetworkAdapter
+ (NSString *)adapterVersion {
    return @"3.0.0";
}

- (instancetype)initWithAdNetworkConnector:(id<GNSAdNetworkConnector>)connector {
    self = [super init];
    if (self) {
        self.connector = connector;
    }
    return self;
}

- (BOOL)isReadyForDisplay {
    return self.ad != nil;
}

+ (Class<GNSAdNetworkExtras>)networkExtrasClass {
    return [GNSExtrasFullscreenApplovin class];
}

- (id<GNSAdNetworkExtras>)networkExtrasParameter:(GNSAdNetworkExtraParams *)parameter {
    GNSExtrasFullscreenApplovin *extra = [[GNSExtrasFullscreenApplovin alloc]init];
    extra.zone_id = parameter.external_link_id;
    return extra;
}

- (void)presentAdWithRootViewController:(UIViewController *)viewController {
    [ALInterstitialAd shared].adDisplayDelegate = self;
    [ALInterstitialAd shared].adVideoPlaybackDelegate = self;
    [[ALInterstitialAd shared] showOver:[UIApplication sharedApplication].keyWindow andRender:self.ad];
}

- (void)requestAd:(NSInteger)timeOut {
    if ([self isReadyForDisplay]) {
        [self.connector adapterDidReceiveAd:self];
        return;
    }
    [self setTimerWith:timeOut];
    GNSExtrasFullscreenApplovin *extras = [self.connector networkExtras];
    [self AllLog:[NSString stringWithFormat:@"Create interstitial with Applovin zone_id = @%@",extras.zone_id]];
    if ([extras.zone_id length] == 0) {
        [[ALSdk shared].adService loadNextAd:[ALAdSize sizeInterstitial] andNotify:self];
    } else {
        [[ALSdk shared].adService loadNextAdForZoneIdentifier:extras.zone_id andNotify:self];
    }
}

- (void)setUp {
    [self AllLog:@"setup"];
    [self.connector adapterDidSetupAd:self];
}

- (void)stopBeingDelegate {
    [ALInterstitialAd shared].adDisplayDelegate = nil;
    [ALInterstitialAd shared].adVideoPlaybackDelegate = nil;
    self.connector = nil;
}

- (void)setTimerWith:(NSInteger)timeout
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.timer = [NSTimer scheduledTimerWithTimeInterval:timeout target:self selector:@selector(sendDidFailToLoadAdWithTimeout) userInfo:nil repeats:NO];
    });
}

- (void)deleteTimer
{
    if (_timer != nil) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)sendDidFailToLoadAdWithTimeout
{
    [self deleteTimer];
    [self AllLog:@"Interstial Ad loading timeout."];
    NSDictionary *errorInfo = @{NSLocalizedDescriptionKey: @"Interstitial ad loading timeout."};
    NSError *error = [NSError errorWithDomain:kGNSAdapterApplovinInterstitialAdKeyErrorDomain code:1 userInfo:errorInfo];
    [self.connector adapter:self didFailToLoadAdwithError:error];
}

#pragma mark - Ad Load Delegate
- (void)adService:(ALAdService *)adService didLoadAd:(ALAd *)ad
{
    [self deleteTimer];
    self.ad = ad;
    [self.connector adapterDidReceiveAd:self];
}

- (void)adService:(ALAdService *)adService didFailToLoadAdWithError:(int)code
{
    [self deleteTimer];
    self.ad = nil;
    NSDictionary *errorInfo = @{ NSLocalizedDescriptionKey : @"No ad to show." };
    NSError *error = [NSError errorWithDomain: kGNSAdapterApplovinInterstitialAdKeyErrorDomain
                      //code: (code == kALErrorCodeNoFill) ? kGADErrorMediationNoFill : kGADErrorNetworkError
                                         code: (code == kALErrorCodeNoFill) ? kALErrorCodeNoFill : kALErrorCodeNoFill
                                     userInfo: errorInfo];
    [self.connector adapter: self didFailToLoadAdwithError: error];
}

#pragma mark - Ad Display Delegate
- (void)ad:(ALAd *)ad wasDisplayedIn:(UIView *)view
{
    [self AllLog:@"Applovin interstitial displayed"];
    self.ad = nil;
    [self.connector adapterWillPresentScreenInterstitialAd:self];
}

- (void)ad:(ALAd *)ad wasClickedIn:(UIView *)view
{
    [self.connector adapterDidClickAd:self];
}

- (void)ad:(ALAd *)ad wasHiddenIn:(UIView *)view
{
    [self.connector adapterDidCloseAd:self];
}

#pragma mark - Ad Video Playback Delegate
- (void)videoPlaybackBeganInAd:(ALAd *)ad
{
    [self AllLog:@"Applovin video started"];
    [self.connector adapterWillPresentScreenInterstitialAd:self];
}

- (void)videoPlaybackEndedInAd:(nonnull ALAd *)ad atPlaybackPercent:(nonnull NSNumber *)percentPlayed fullyWatched:(BOOL)wasFullyWatched {
    
}


@end
