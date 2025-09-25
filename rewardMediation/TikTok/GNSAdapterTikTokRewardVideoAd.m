//
//  GNSAdapterTikTokRewardVideoAd.m
//  GNAdSDK
//

#import "GNSAdapterTikTokRewardVideoAd.h"

#import <GNAdSDK/GNSAdNetworkConnectorProtocol.h>
#import <GNAdSDK/GNSAdNetworkExtraParams.h>
#import <GNAdSDK/GNSAdReward.h>
#import <BUAdSDK/BURewardedVideoAd.h>
#import <BUAdSDK/BUAdSDKManager.h>
#import <BUAdSDK/BURewardedVideoModel.h>

static NSString *const kGNSAdapterTikTokRewardVideoAdKeyErrorDomain = @"jp.co.geniee.GNSAdapterTikTokRewardVideoAd";
static BOOL loggingEnabled = YES;

@interface GNSAdapterTikTokRewardVideoAd ()<BURewardedVideoAdDelegate>

@property (nonatomic, strong) BURewardedVideoAd *rewardedVideoAd;
@property(nonatomic, strong) GNSAdReward *reward;
@property(nonatomic, weak) id<GNSAdNetworkConnector> connector;
@property (nonatomic, retain) NSTimer *timer;

@end

@implementation GNSExtrasTikTok
@end

@implementation GNSAdapterTikTokRewardVideoAd

- (void)ALLog:(NSString *)logMessage {
    if (loggingEnabled) {
        NSLog(@"[INFO]GNSTikTokAdapter: %@", logMessage);
    }
}

+ (NSString *)adapterVersion {
    return @"3.1.1";
}

+ (Class<GNSAdNetworkExtras>)networkExtrasClass {
    return [GNSExtrasTikTok class];
}

- (id<GNSAdNetworkExtras>)networkExtrasParameter:(GNSAdNetworkExtraParams *) parameter
{
    GNSExtrasTikTok * extra = [[GNSExtrasTikTok alloc]init];
    extra.appKey = parameter.external_link_id;
    extra.slotId = parameter.external_link_media_id;
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
    NSError *error = [NSError errorWithDomain: kGNSAdapterTikTokRewardVideoAdKeyErrorDomain
                                         code: 1
                                     userInfo: errorInfo];
    [self.connector adapter: self didFailToLoadAdwithError: error];
}

- (void)requestAd:(NSInteger)timeout {
    //Return the result when already loaded
    if ([self isReadyForDisplay]) {
        [self.connector adapterDidReceiveAd:self];
        return;
    }
    // set Timer
    [self setTimerWith:timeout];
    
    self.isAdAvailable = NO;
    
    self.reward = nil;
    GNSExtrasTikTok *extras = [self.connector networkExtras];
    [self ALLog:[NSString stringWithFormat:@"UnityAds request game_id=%@ placement_id=%@", extras.appKey, extras.slotId]];
    
    [BUAdSDKManager setAppID:extras.appKey];
    [BUAdSDKManager setIsPaidApp:NO];
    
    BURewardedVideoModel *model = [[BURewardedVideoModel alloc] init];
    model.userId = @"geniee";
    self.rewardedVideoAd = [[BURewardedVideoAd alloc] initWithSlotID:extras.slotId rewardedVideoModel:model];
    self.rewardedVideoAd.delegate = self;
    [self.rewardedVideoAd loadAdData];
}

- (BOOL)isReadyForDisplay
{
    return _isAdAvailable;
}

- (void)presentAdWithRootViewController:(UIViewController *)viewController {
    
    if ([self isReadyForDisplay]) {
        [self.rewardedVideoAd showAdFromRootViewController:viewController];
    }
}

- (void)stopBeingDelegate {
    self.connector = nil;
}

#pragma mark - BURewardedVideoAdDelegate

- (void)rewardedVideoAdDidLoad:(BURewardedVideoAd *)rewardedVideoAd {
    
    [self ALLog:@"rewardedVideoAd data load success"];
}

- (void)rewardedVideoAdVideoDidLoad:(BURewardedVideoAd *)rewardedVideoAd {
    [self deleteTimer];
    
    [self ALLog:@"rewardedVideoAdVideoDidLoad data load success"];
    
    self.isAdAvailable = YES;
    
    [self.connector adapterDidReceiveAd:self];
}

- (void)rewardedVideoAdWillVisible:(BURewardedVideoAd *)rewardedVideoAd {
    [self ALLog:@"rewardedVideoAd video will visible"];
    
    [self.connector adapterDidStartPlayingRewardVideoAd:self];
}

- (void)rewardedVideoAdDidClose:(BURewardedVideoAd *)rewardedVideoAd {
    [self ALLog:@"rewardedVideoAd video did close"];
    
    [self.connector adapterDidCloseAd:self];

    self.isAdAvailable = NO;
}

- (void)rewardedVideoAdDidClick:(BURewardedVideoAd *)rewardedVideoAd {
    [self ALLog:@"rewardedVideoAd video did click"];
}

- (void)rewardedVideoAd:(BURewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error {
    [self deleteTimer];
    [self ALLog:[NSString stringWithFormat:@"didFailWithError: %@", error.localizedDescription]];
    
    self.isAdAvailable = NO;
    
    [self.connector adapter:self didFailToLoadAdwithError:error];
}

- (void)rewardedVideoAdDidPlayFinish:(BURewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error {
    if (error) {
        [self ALLog:[NSString stringWithFormat:@"rewardedVideoAdDidPlayFinish play fail: %@", error.localizedDescription]];
    } else {
        [self ALLog:[NSString stringWithFormat:@"rewardedVideoAdDidPlayFinish play finish"]];
        
        GNSExtrasTikTok *extras = [self.connector networkExtras];
        self.reward = [[GNSAdReward alloc]
                       initWithRewardType: extras.type
                       rewardAmount: extras.amount];
        
        if (self.reward) {
            [self.connector adapter: self didRewardUserWithReward: self.reward];
            self.reward = nil;
        }
    }

    self.isAdAvailable = NO;
}

- (void)rewardedVideoAdServerRewardDidFail:(BURewardedVideoAd *)rewardedVideoAd {
    
    [self ALLog:@"rewardedVideoAd verify failed"];
    [self ALLog:[NSString stringWithFormat:@"Demo RewardName == %@", rewardedVideoAd.rewardedVideoModel.rewardName]];
    [self ALLog:[NSString stringWithFormat:@"Demo RewardAmount == %ld", (long)rewardedVideoAd.rewardedVideoModel.rewardAmount]];
    
}

- (void)rewardedVideoAdServerRewardDidSucceed:(BURewardedVideoAd *)rewardedVideoAd verify:(BOOL)verify{
    
    
    [self ALLog:@"rewardedVideoAd verify succeed"];
    [self ALLog:[NSString stringWithFormat:@"verify result: %@", verify ? @"success" : @"fail"]];
    
    [self ALLog:[NSString stringWithFormat:@"Demo RewardName == %@", rewardedVideoAd.rewardedVideoModel.rewardName]];
    [self ALLog:[NSString stringWithFormat:@"Demo RewardAmount == %ld", (long)rewardedVideoAd.rewardedVideoModel.rewardAmount]];
    
}

@end
