//
//  GNSAdapterCARewardRewardVideoAd.m
//  GNSAdSDK
//

#import "GNSAdapterCARewardRewardVideoAd.h"
#import <MediaSDK/MediaSDK.h>
#import <GNAdSDK/GNSRewardVideoAdNetworkConnectorProtocol.h>
#import <GNAdSDK/GNSAdNetworkExtraParams.h>
#import <GNAdSDK/GNSAdReward.h>

static NSString *const kGNSAdapterCARewardRewardVideoAdKeyErrorDomain = @"jp.co.geniee.GNSAdapterCARewardRewardVideoAd";
static BOOL loggingEnabled = YES;

@interface GNSAdapterCARewardRewardVideoAd () <UIApplicationDelegate>

@property(nonatomic, strong) GNSAdReward *reward;
@property(nonatomic, weak) id<GNSRewardVideoAdNetworkConnector> connector;
@property (nonatomic, retain) NSTimer *timer;

@end

@implementation GNSExtrasCAReward
@end

@implementation GNSAdapterCARewardRewardVideoAd

- (void)ALLog:(NSString *)logMessage {
    if (loggingEnabled) {
        NSLog(@"[INFO]GNSCARewardAdapter: %@", logMessage);
    }
}

+ (NSString *)adapterVersion {
    return @"2.5.0";
}

+ (Class<GNSAdNetworkExtras>)networkExtrasClass {
    return [GNSExtrasCAReward class];
}

- (id<GNSAdNetworkExtras>)networkExtrasParameter:(GNSAdNetworkExtraParams *) parameter
{
    GNSExtrasCAReward * extra = [[GNSExtrasCAReward alloc]init];
    extra.m_id = parameter.external_link_id;
    extra.sdk_token = parameter.external_link_media_id;
    extra.type = parameter.type;
    extra.amount = parameter.amount;
    extra.media_user_id = @"geniee";
    extra.placement = @"placement_1";
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
    [self ALLog:@"setUp"];
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
    NSError *error = [NSError errorWithDomain: kGNSAdapterCARewardRewardVideoAdKeyErrorDomain
                                         code: 1
                                     userInfo: errorInfo];
    [self.connector adapter: self didFailToLoadRewardVideoAdwithError: error];
}



- (void)requestRewardVideoAd:(NSInteger)timeout {
    //Return the result when already loaded
    if ([self isReadyForDisplay]) {
        [self.connector adapterDidReceiveRewardVideoAd:self];
        return;
    }

    // set Timer
    [self setTimerWith:timeout];

    self.reward = nil;
    GNSExtrasCAReward *extras = [self.connector networkExtras];
    [self ALLog:[NSString stringWithFormat:@"MediaId=%@", extras.m_id]];
    [self ALLog:[NSString stringWithFormat:@"SDKKey=%@", extras.sdk_token]];
    [self ALLog:[NSString stringWithFormat:@"media_user_id=%@", extras.media_user_id]];

    self.gvaAdManager = [[MSGVAManager alloc] init];
    self.gvaAdManager.m_id = extras.m_id;
    self.gvaAdManager.media_user_id = extras.media_user_id;
    self.gvaAdManager.placement = extras.placement;
    self.gvaAdManager.sdk_token = extras.sdk_token;
    [self.gvaAdManager setDelegate:self];
    [self.gvaAdManager loadAd];
}

- (void)presentRewardVideoAdWithRootViewController:(UIViewController *)viewController {
    if (self.isReadyForDisplay) {
        [self.gvaAdManager showAdView:viewController];
    }
}

- (void)stopBeingDelegate {
    self.connector = nil;
}

- (BOOL)isReadyForDisplay
{
    return [self.gvaAdManager isReady];
}

#pragma MSGVAVideoAdDelegate

- (void)onGVAAdClick:(MSGVAManager *)msGVAManager {
    [self ALLog:@"onGVAAdClick"];
}

- (void)onGVAClose:(MSGVAManager *)msGVAManager {

    [self ALLog:@"onGVAClose"];

    [self.connector adapterDidCloseRewardVideoAd:self];
}

- (void)onGVAFailedToPlay:(MSGVAManager *)msGVAManager {
    [self ALLog:@"onGVAFailedToPlay"];
}

- (void)onGVAFailedToReceiveAd:(MSGVAManager *)msGVAManager {

    [self ALLog:@"onGVAFailedToReceiveAd"];
    [self deleteTimer];
    NSDictionary *errorInfo = @{ NSLocalizedDescriptionKey : @"Failed to receive ad" };
    NSError *error = [NSError errorWithDomain: kGNSAdapterCARewardRewardVideoAdKeyErrorDomain
                                         code: 1
                                     userInfo: errorInfo];
    [self.connector adapter: self didFailToLoadRewardVideoAdwithError: error];
}

- (void)onGVAPlayEnd:(MSGVAManager *)msGVAManager {

    [self ALLog:@"onGVAPlayEnd"];

    GNSExtrasCAReward *extras = [self.connector networkExtras];
    self.reward = [[GNSAdReward alloc]
                   initWithRewardType: extras.type
                   rewardAmount: extras.amount];
    if (self.reward) {
        [self.connector adapter: self didRewardUserWithReward: self.reward];
        self.reward = nil;
    }
}

- (void)onGVAPlayStart:(MSGVAManager *)msGVAManager {

    [self ALLog:@"onGVAPlayStart"];

    [self.connector adapterDidStartPlayingRewardVideoAd:self];
}

- (void)onGVAReadyToPlayAd:(MSGVAManager *)msGVAManager {

    [self ALLog:@"onGVAReadyToPlayAd"];
    [self deleteTimer];
    [self.connector adapterDidReceiveRewardVideoAd:self];
}

@end
