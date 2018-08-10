//
//  GNSAdapterAppLovinRewardVideoAd.m
//  GNAdSDK
//

#import "GNSAdapterAppLovinRewardVideoAd.h"

#import <AppLovinSDK/ALSdk.h>
#import <AppLovinSDK/ALIncentivizedInterstitialAd.h>
//#import "ALSdk.h"
//#import "ALIncentivizedInterstitialAd.h"
#import <GNAdSDK/GNSRewardVideoAdNetworkConnectorProtocol.h>
#import <GNAdSDK/GNSAdNetworkExtraParams.h>
#import <GNAdSDK/GNSAdReward.h>


static NSString *const kGNSAdapterAppLovinRewardVideoAdKeyErrorDomain = @"jp.co.geniee.GNSAdapterAppLovinRewardVideoAd";
static BOOL loggingEnabled = YES;

@interface GNSAdapterAppLovinRewardVideoAd () <ALAdLoadDelegate, ALAdRewardDelegate,
ALAdDisplayDelegate, ALAdVideoPlaybackDelegate>

@property(nonatomic, strong) GNSAdReward *reward;
@property(nonatomic, weak) id<GNSRewardVideoAdNetworkConnector> connector;
@property (nonatomic, retain) NSTimer *timer;

@end

@implementation GNSExtrasAppLovin
@end

@implementation GNSAdapterAppLovinRewardVideoAd

- (void)ALLog:(NSString *)logMessage {
    if (loggingEnabled) {
        NSLog(@"[INFO]GNSAppLovinAdapter: %@", logMessage);
    }
}

+ (NSString *)adapterVersion {
    return @"2.4.4";
}

+ (Class<GNSAdNetworkExtras>)networkExtrasClass {
    return [GNSExtrasAppLovin class];
}

- (id<GNSAdNetworkExtras>)networkExtrasParameter:(GNSAdNetworkExtraParams *) parameter
{
    GNSExtrasAppLovin * extra = [[GNSExtrasAppLovin alloc]init];
    extra.placement_id = parameter.external_link_id;
    extra.type = parameter.type;
    extra.amount = parameter.amount;
    return extra;
}

- (instancetype)initWithRewardVideoAdNetworkConnector:(id<GNSRewardVideoAdNetworkConnector>)connector {
    self = [super init];
    if (self) {
        self.connector = connector;
    }
    
    return self;
}

- (void)setUp {
    
    [self ALLog:[NSString stringWithFormat:@"setUp AppLovin version = %@", [ALSdk version]]];
    
    [[ALSdk shared] initializeSdk];
    [self.connector adapterDidSetUpRewardVideoAd:self];
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
    NSError *error = [NSError errorWithDomain: kGNSAdapterAppLovinRewardVideoAdKeyErrorDomain
                                         code: 1
                                     userInfo: errorInfo];
    [self.connector adapter: self didFailToLoadRewardVideoAdwithError: error];
}


// AppLovin have no auto load
- (void)requestRewardVideoAd:(NSInteger)timeout {
    //Return the result when already loaded
    if ([self isReadyForDisplay]) {
        [self.connector adapterDidReceiveRewardVideoAd:self];
        return;
    }
    // set Timer
    [self setTimerWith:timeout];
    
    self.reward = nil;
    GNSExtrasAppLovin *extras = [self.connector networkExtras];
    [ALIncentivizedInterstitialAd preloadAndNotify:self];

}

- (void)presentRewardVideoAdWithRootViewController:(UIViewController *)viewController {
    [self setSharedDelegates];
    [ALIncentivizedInterstitialAd showAndNotify: self];
}

- (void)setSharedDelegates {
    [ALIncentivizedInterstitialAd shared].adDisplayDelegate = self;
    [ALIncentivizedInterstitialAd shared].adVideoPlaybackDelegate = self;
}

- (void)unsetSharedDelegates {
    [ALIncentivizedInterstitialAd shared].adDisplayDelegate = nil;
    [ALIncentivizedInterstitialAd shared].adVideoPlaybackDelegate = nil;
}

- (void)stopBeingDelegate {
    [self unsetSharedDelegates];
    self.connector = nil;
}

- (BOOL)isReadyForDisplay
{
    return [ALIncentivizedInterstitialAd isReadyForDisplay];
}

#pragma mark - ALAdLoadDelegate

- (void)adService:(ALAdService *)adService didLoadAd:(ALAd *)ad {
    [self deleteTimer];
    [self.connector adapterDidReceiveRewardVideoAd:self];
}

- (void)adService:(ALAdService *)adService didFailToLoadAdWithError:(int)code {
    [self deleteTimer];
    NSDictionary *errorInfo = @{ NSLocalizedDescriptionKey : @"No ad to show." };
    NSError *error = [NSError errorWithDomain: kGNSAdapterAppLovinRewardVideoAdKeyErrorDomain
                                         //code: (code == kALErrorCodeNoFill) ? kGADErrorMediationNoFill : kGADErrorNetworkError
                                         code: (code == kALErrorCodeNoFill) ? kALErrorCodeNoFill : kALErrorCodeNoFill
                                     userInfo: errorInfo];
    [self.connector adapter: self didFailToLoadRewardVideoAdwithError: error];
}

#pragma mark - ALAdDisplayDelegate
- (void)ad:(ALAd *)ad wasClickedIn:(UIView *)view {

}

- (void)ad:(ALAd *)ad wasDisplayedIn:(UIView *)view {

}

- (void)ad:(ALAd *)ad wasHiddenIn:(UIView *)view {
    [self.connector adapterDidCloseRewardVideoAd:self];
    [self unsetSharedDelegates];
}

#pragma mark - ALAdRewardDelegate
- (void)rewardValidationRequestForAd:(ALAd *)ad didSucceedWithResponse:(NSDictionary *)response {
    GNSExtrasAppLovin *extras = [self.connector networkExtras];
    self.reward = [[GNSAdReward alloc]
                   initWithRewardType: extras.type
                   rewardAmount: extras.amount];
}

- (void)rewardValidationRequestForAd:(ALAd *)ad
          didExceedQuotaWithResponse:(NSDictionary *)response {
    [self ALLog:@"User exceeded quota."];
}

- (void)rewardValidationRequestForAd:(ALAd *)ad wasRejectedWithResponse:(NSDictionary *)response {
    [self ALLog:@"User reward rejected by AppLovin servers."];
}

- (void)rewardValidationRequestForAd:(ALAd *)ad didFailWithError:(NSInteger)responseCode {
    [self ALLog:@"User could not be validated due to network issue or closed ad early."];
}

#pragma mark - ALAdVideoPlaybackDelegate
- (void)videoPlaybackBeganInAd:(ALAd *)ad {
    [self.connector adapterDidStartPlayingRewardVideoAd:self];
}

- (void)videoPlaybackEndedInAd:(ALAd *)ad
             atPlaybackPercent:(NSNumber *)percentPlayed
                  fullyWatched:(BOOL)wasFullyWatched {
    
    if (wasFullyWatched && self.reward) {
        [self.connector adapter: self didRewardUserWithReward: self.reward];
        self.reward = nil;
    }
}


@end
