//
//  GNSAdapterVungleRewardVideoAd.m
//  GNAdSDK
//

#import "GNSAdapterVungleRewardVideoAd.h"
#import <VungleAdsSDK/VungleAdsSDK.h>
#import <GNAdSDK/GNSAdNetworkConnectorProtocol.h>
#import <GNAdSDK/GNSAdNetworkExtraParams.h>
#import <GNAdSDK/GNSAdReward.h>

static NSString *const kGNSAdapterVungleRewardVideoAdKeyErrorDomain = @"jp.co.geniee.GNSAdapterVungleRewardVideoAd";
static BOOL loggingEnabled = YES;

@interface GNSAdapterVungleRewardVideoAd () <UIApplicationDelegate, VungleRewardedDelegate>

@property(nonatomic, strong) GNSAdReward *reward;

@property(nonatomic, weak) id<GNSAdNetworkConnector> connector;

@property (nonatomic, retain) NSTimer *timer;

@property (nonatomic, strong) VungleRewarded *vungleRewardedAd;

@property(nonatomic, assign) BOOL requestingAd;

@end

@implementation GNSExtrasVungle
@end

@implementation GNSAdapterVungleRewardVideoAd

- (void)ALLog:(NSString *)logMessage {
    if (loggingEnabled) {
        NSLog(@"[INFO]GNSVungleAdapter: %@", logMessage);
    }
}

+ (NSString *)adapterVersion {
    return @"3.2.1";
}

+ (Class<GNSAdNetworkExtras>)networkExtrasClass {
    return [GNSExtrasVungle class];
}

- (id<GNSAdNetworkExtras>)networkExtrasParameter:(GNSAdNetworkExtraParams *) parameter
{
    GNSExtrasVungle * extra = [[GNSExtrasVungle alloc]init];
    extra.app_id = parameter.external_link_id;
    extra.placementReferenceId = parameter.external_link_media_id;
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
    
    GNSExtrasVungle *extras = [self.connector networkExtras];
    
    if (![VungleAds isInitialized]) {
        [VungleAds initWithAppId:extras.app_id completion:^(NSError * _Nullable error) {
            
            if (error) {
                [self.connector adapter:self didFailToSetupAdWithError:nil];
            }
        }];
        
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
        if ([VungleAds isInitialized]) {
            [self.connector adapterDidSetupAd:self];
            return;
        }
        
        attempts++;
        // Wait for the specified interval before the next check
        dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(pollingInterval * NSEC_PER_SEC)));
    }

    // If it still isn't initialized after max attempts, log and notify error
    [self ALLog:@"Vungle SDK initialization timeout."];
    [self.connector adapter:self didFailToSetupAdWithError:[NSError errorWithDomain:kGNSAdapterVungleRewardVideoAdKeyErrorDomain
                                                                             code:101
                                                                         userInfo:@{NSLocalizedDescriptionKey: @"Vungle SDK initialization timeout."}]];
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
    NSError *error = [NSError errorWithDomain: kGNSAdapterVungleRewardVideoAdKeyErrorDomain
                                         code: 1
                                     userInfo: errorInfo];
    [self.connector adapter: self didFailToLoadAdwithError: error];
}

- (void)requestAd:(NSInteger)timeout {
    
    self.requestingAd = YES;
    
    if ([self isReadyForDisplay]) {
        self.requestingAd = NO;
        [self.connector adapterDidReceiveAd:self];
        return;
    }
    
    GNSExtrasVungle *extras = [self.connector networkExtras];
    
    self.vungleRewardedAd = [[VungleRewarded alloc] initWithPlacementId:extras.placementReferenceId];
    self.vungleRewardedAd.delegate = self;
    [self.vungleRewardedAd load:nil];
}

- (void)presentAdWithRootViewController:(UIViewController *)viewController {
    
    if([self isReadyForDisplay]) {
        [self.vungleRewardedAd presentWith:viewController];
    }
}

- (void)stopBeingDelegate {
    self.connector = nil;
    if (self.vungleRewardedAd != nil) {
        [self.vungleRewardedAd setDelegate:nil];
    }
}

- (BOOL)isReadyForDisplay
{
    return [self.vungleRewardedAd canPlayAd];
}

- (void)onErrorWithMessage:(NSString*) message
{
    [self deleteTimer];
    [self ALLog: message];
    NSDictionary *errorInfo = @{ NSLocalizedDescriptionKey : message };
    NSError *error = [NSError errorWithDomain: kGNSAdapterVungleRewardVideoAdKeyErrorDomain
                                         code: 1
                                     userInfo: errorInfo];
    [self.connector adapter: self didFailToLoadAdwithError: error];
}

#pragma mark - VungleRewarded Delegate Methods
// Ad load events
- (void)rewardedAdDidLoad:(VungleRewarded *)rewarded {
    NSLog(@"rewardedAdDidLoad");
    [self.connector adapterDidReceiveAd:self];
}
- (void)rewardedAdDidFailToLoad:(VungleRewarded *)rewarded
                      withError:(NSError *)withError {
    NSLog(@"rewardedAdDidFailToLoad");
    [self.connector adapter: self didFailToLoadAdwithError: withError];
}
// Ad Lifecycle Events
- (void)rewardedAdWillPresent:(VungleRewarded *)rewarded {
    NSLog(@"rewardedAdWillPresent");
    
}
- (void)rewardedAdDidPresent:(VungleRewarded *)rewarded {
    NSLog(@"rewardedAdDidPresent");
    [self.connector adapterDidStartPlayingRewardVideoAd:self];
}
- (void)rewardedAdDidFailToPresent:(VungleRewarded *)rewarded
                         withError:(NSError *)withError {
    NSLog(@"rewardedAdDidFailToPresent: %@", withError);
}
- (void)rewardedAdDidTrackImpression:(VungleRewarded *)rewarded {
    NSLog(@"rewardedAdDidTrackImpression");
}
- (void)rewardedAdDidClick:(VungleRewarded *)rewarded {
    NSLog(@"rewardedAdDidClick");
}
- (void)rewardedAdWillLeaveApplication:(VungleRewarded *)rewarded {
    NSLog(@"rewardedAdWillLeaveApplication");
}
- (void)rewardedAdDidRewardUser:(VungleRewarded *)rewarded {
    NSLog(@"rewardedAdDidRewardUser");
    
    GNSExtrasVungle *extras = [self.connector networkExtras];
    self.reward = [[GNSAdReward alloc]
                   initWithRewardType: extras.type
                   rewardAmount: extras.amount];
    
    if (self.reward) {
        [self.connector adapter: self didRewardUserWithReward: self.reward];
        self.reward = nil;
    }
}
- (void)rewardedAdWillClose:(VungleRewarded *)rewarded {
    NSLog(@"rewardedAdWillClose");
    
}
- (void)rewardedAdDidClose:(VungleRewarded *)rewarded {
    NSLog(@"rewardedAdDidClose");
    [self.connector adapterDidCloseAd:self];
}

@end
