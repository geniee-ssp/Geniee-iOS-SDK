//
//  GNSAdapterUnityAdsRewardVideoAd.m
//  GNAdSDK
//

#import "GNSAdapterUnityAdsRewardVideoAd.h"

#import <UnityAds/UnityAds.h>
#import <UnityAds/UnityAdsShowError.h>
#import <GNAdSDK/GNSAdNetworkConnectorProtocol.h>
#import <GNAdSDK/GNSAdNetworkExtraParams.h>
#import <GNAdSDK/GNSAdReward.h>

static NSString *const kGNSAdapterUnityAdsRewardVideoAdKeyErrorDomain = @"jp.co.geniee.GNSAdapterUnityAdsRewardVideoAd";
static BOOL loggingEnabled = YES;

@interface GNSAdapterUnityAdsRewardVideoAd () <UnityAdsInitializationDelegate, UnityAdsLoadDelegate, UnityAdsShowDelegate>

@property(nonatomic, strong) GNSAdReward *reward;
@property(nonatomic, weak) id<GNSAdNetworkConnector> connector;
@property (nonatomic, retain) NSTimer *timer;
//@property (assign, nonatomic) BOOL isSDKInitialized;
@property (assign, nonatomic) BOOL canShowAd;


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
    return @"3.2.1";
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
    
    GNSExtrasUnityAds *extras = [self.connector networkExtras];
    
    if(![UnityAds isInitialized]) {
        [UnityAds initialize:extras.game_id
                    testMode:false
      initializationDelegate:self];
        
        [self waitForInitialization];
    } else {
        [self.connector adapterDidSetupAd:self];
    }
    
}

- (void)waitForInitialization {
    // Create a dispatch semaphore
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    // Polling interval
    NSTimeInterval pollingInterval = 0.5; // 500ms
    NSInteger maxAttempts = 10; // Limit the number of attempts
    NSInteger attempts = 0;
    
    while (attempts < maxAttempts) {
        if ([UnityAds isInitialized]) {
            [self.connector adapterDidSetupAd:self];
            return;
        }
        
        attempts++;
        // Wait for the specified interval before the next check
        dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(pollingInterval * NSEC_PER_SEC)));
    }
    
    // If it still isn't initialized after max attempts, log and notify error
    [self ALLog:@"UnityAds SDK initialization timeout."];
    [self.connector adapter:self didFailToSetupAdWithError:[NSError errorWithDomain:kGNSAdapterUnityAdsRewardVideoAdKeyErrorDomain
                                                                               code:101
                                                                           userInfo:@{NSLocalizedDescriptionKey: @"UnityAds SDK initialization timeout."}]];
}

- (void)setTimerWith:(NSInteger)timeout
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self->_timer = [NSTimer scheduledTimerWithTimeInterval:timeout
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
    
    GNSExtrasUnityAds *extras = [self.connector networkExtras];
    
    self.reward = nil;
    self.canShowAd = false;
    [UnityAds load: extras.placement_id
      loadDelegate: self];
}

- (BOOL)isReadyForDisplay
{
    return self.canShowAd;
}

- (void)presentAdWithRootViewController:(UIViewController *)viewController {
    GNSExtrasUnityAds *extras = [self.connector networkExtras];
    if ([self isReadyForDisplay]) {
        [UnityAds show:viewController placementId:extras.placement_id showDelegate:self];
    }
}

- (void)stopBeingDelegate {
    self.connector = nil;
}

#pragma mark : UnityAdsInitializationDelegate
- (void)initializationComplete {
    NSLog(@" - UnityAdsInitializationDelegate initializationComplete" );
    
    GNSExtrasUnityAds *extras = [self.connector networkExtras];
    
    [UnityAds load:extras.placement_id loadDelegate:self];
}

- (void)initializationFailed:(UnityAdsInitializationError)error withMessage:(NSString *)message {
    [self.connector adapter:self didFailToSetupAdWithError:[NSError errorWithDomain:kGNSAdapterUnityAdsRewardVideoAdKeyErrorDomain
                                                                               code:101
                                                                           userInfo:@{NSLocalizedDescriptionKey: @"UnityAds SDK initialization failed."}]];
}

#pragma mark: UnityAdsLoadDelegate
- (void)unityAdsAdLoaded:(NSString *)placementId {
    
    self.canShowAd = true;
    [self deleteTimer];
    [self.connector adapterDidReceiveAd:self];
}

- (void)unityAdsAdFailedToLoad:(NSString *)placementId
                     withError:(UnityAdsLoadError)error
                   withMessage:(NSString *)message {
    
    self.canShowAd = false;
    
    [self deleteTimer];
    NSDictionary *errorInfo = @{ NSLocalizedDescriptionKey : message };
    NSError *ns_error = [NSError errorWithDomain: kGNSAdapterUnityAdsRewardVideoAdKeyErrorDomain
                                            code: error
                                        userInfo: errorInfo];
    [self.connector adapter: self didFailToLoadAdwithError: ns_error];
}

#pragma mark UnityAdsShowDelegate
- (void)unityAdsShowComplete: (NSString *)placementId withFinishState: (UnityAdsShowCompletionState)state {
    
    GNSExtrasUnityAds *extras = [self.connector networkExtras];
    
    self.canShowAd = false;
    
    if ([placementId isEqualToString:extras.placement_id] && state == kUnityShowCompletionStateCompleted) {
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

- (void)unityAdsShowFailed: (NSString *)placementId withError: (UnityAdsShowError)error withMessage: (NSString *)message {
    self.canShowAd = false;
}

- (void)unityAdsShowStart:(NSString *)placementId {
    [self.connector adapterDidStartPlayingRewardVideoAd:self];
}

- (void)unityAdsShowClick:(NSString *)placementId {
    NSLog(@" - UnityAdsShowDelegate unityAdsShowClick %@", placementId);
}

@end

