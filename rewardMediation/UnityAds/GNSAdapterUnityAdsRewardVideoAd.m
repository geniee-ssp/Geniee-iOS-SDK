//
//  GNSAdapterUnityAdsRewardVideoAd.m
//  GNAdSDK
//

#import "GNSAdapterUnityAdsRewardVideoAd.h"

#import "UnityAds/UnityAds.h"
#import <GNAdSDK/GNSAdNetworkConnectorProtocol.h>
#import <GNAdSDK/GNSAdNetworkExtraParams.h>
#import <GNAdSDK/GNSAdReward.h>

static NSString *const kGNSAdapterUnityAdsRewardVideoAdKeyErrorDomain = @"jp.co.geniee.GNSAdapterUnityAdsRewardVideoAd";
static BOOL loggingEnabled = YES;

@interface GNSAdapterUnityAdsRewardVideoAd () <UnityAdsDelegate>

@property(nonatomic, strong) GNSAdReward *reward;
@property(nonatomic, weak) id<GNSAdNetworkConnector> connector;
@property (nonatomic, retain) NSTimer *timer;

@end

@implementation GNSExtrasUnityAds
@end

@implementation GNSAdapterUnityAdsRewardVideoAd

- (void)ALLog:(NSString *)logMessage {
    if (loggingEnabled) {
        NSLog(@"[INFO]GNSUnityAdsAdapter: %@", logMessage);
    }
}

+ (NSString *)adapterVersion {
    return @"3.1.1";
}

+ (Class<GNSAdNetworkExtras>)networkExtrasClass {
    return [GNSExtrasUnityAds class];
}

- (id<GNSAdNetworkExtras>)networkExtrasParameter:(GNSAdNetworkExtraParams *) parameter
{
    GNSExtrasUnityAds * extra = [[GNSExtrasUnityAds alloc]init];
    extra.game_id = parameter.external_link_id;
    extra.placement_id = parameter.external_link_media_id;
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
    NSError *error = [NSError errorWithDomain: kGNSAdapterUnityAdsRewardVideoAdKeyErrorDomain
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
    
    self.reward = nil;
    GNSExtrasUnityAds *extras = [self.connector networkExtras];
    [self ALLog:[NSString stringWithFormat:@"UnityAds request game_id=%@ placement_id=%@", extras.game_id, extras.placement_id]];
    
    [UnityAds initialize:extras.game_id delegate:self];
}

- (BOOL)isReadyForDisplay
{
    GNSExtrasUnityAds *extras = [self.connector networkExtras];
    return [UnityAds isReady:extras.placement_id];
}

- (void)presentAdWithRootViewController:(UIViewController *)viewController {
    GNSExtrasUnityAds *extras = [self.connector networkExtras];
    if ([UnityAds isReady:extras.placement_id]) {
        [UnityAds show:viewController placementId:extras.placement_id];
    }
}

- (void)stopBeingDelegate {
    self.connector = nil;
}

#pragma mark - UnityAdsDelegate

- (void)unityAdsReady:(NSString *)placementId
{
    [self deleteTimer];
    [self.connector adapterDidReceiveAd:self];
}

- (void)unityAdsDidError:(UnityAdsError)error withMessage:(NSString *)message
{
    [self deleteTimer];
    NSDictionary *errorInfo = @{ NSLocalizedDescriptionKey : message };
    NSError *ns_error = [NSError errorWithDomain: kGNSAdapterUnityAdsRewardVideoAdKeyErrorDomain
                                         code: error
                                     userInfo: errorInfo];
    [self.connector adapter: self didFailToLoadAdwithError: ns_error];
}

- (void)unityAdsDidStart:(NSString *)placementId
{
    [self.connector adapterDidStartPlayingRewardVideoAd:self];
}

- (void)unityAdsDidFinish:(NSString *)placementId withFinishState:(UnityAdsFinishState)state
{
    
    NSString *stateString = @"UNKNOWN";
    switch (state) {
        case kUnityAdsFinishStateError:
            stateString = @"ERROR";
            break;
        case kUnityAdsFinishStateSkipped:
            stateString = @"SKIPPED";
            break;
        case kUnityAdsFinishStateCompleted:
            stateString = @"COMPLETED";
            break;
        default:
            break;
    }
    NSLog(@"UnityAds FINISH: %@ - %@", stateString, placementId);
    
    if (state == kUnityAdsFinishStateCompleted){
        GNSExtrasUnityAds *extras = [self.connector networkExtras];
        self.reward = [[GNSAdReward alloc]
                       initWithRewardType: extras.type
                       rewardAmount: extras.amount];
        
        if (self.reward) {
            [self.connector adapter: self didRewardUserWithReward: self.reward];
            self.reward = nil;
        }
    }
    [self.connector adapterDidCloseAd:self];
}

@end

