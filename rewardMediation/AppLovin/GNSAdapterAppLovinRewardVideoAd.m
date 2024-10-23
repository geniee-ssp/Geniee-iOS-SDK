//
//  GNSAdapterAppLovinRewardVideoAd.m
//  GNAdSDK
//

#import "GNSAdapterAppLovinRewardVideoAd.h"

#import <AppLovinSDK/AppLovinSDK.h>
#import <GNAdSDK/GNSAdNetworkConnectorProtocol.h>
#import <GNAdSDK/GNSAdNetworkExtraParams.h>
#import <GNAdSDK/GNSAdReward.h>


static NSString *const kGNSAdapterAppLovinRewardVideoAdKeyErrorDomain = @"jp.co.geniee.GNSAdapterAppLovinRewardVideoAd";
static BOOL loggingEnabled = YES;

@interface GNSAdapterAppLovinRewardVideoAd () <MARewardedAdDelegate>

@property(nonatomic, strong) GNSAdReward *reward;
@property(nonatomic, weak) id<GNSAdNetworkConnector> connector;
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, strong) MARewardedAd *maRewardedAd;

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
    return @"3.2.1";
}

+ (Class<GNSAdNetworkExtras>)networkExtrasClass {
    return [GNSExtrasAppLovin class];
}

- (id<GNSAdNetworkExtras>)networkExtrasParameter:(GNSAdNetworkExtraParams *) parameter
{
    GNSExtrasAppLovin * extra = [[GNSExtrasAppLovin alloc]init];
    extra.sdkKey = parameter.external_link_media_id;
    extra.zoneId = parameter.external_link_id;
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
    
    [self ALLog:[NSString stringWithFormat:@"setUp AppLovin version = %@", [ALSdk version]]];
    
    GNSExtrasAppLovin *extras = [self.connector networkExtras];
    
    ALSdkInitializationConfiguration *initConfig = [ALSdkInitializationConfiguration configurationWithSdkKey: extras.sdkKey builderBlock:^(ALSdkInitializationConfigurationBuilder *builder) {
        
        builder.mediationProvider = ALMediationProviderMAX;
        
        NSString *currentIDFV = UIDevice.currentDevice.identifierForVendor.UUIDString;
        if ( currentIDFV.length > 0 )
        {
            builder.testDeviceAdvertisingIdentifiers = @[currentIDFV];
        }
    }];
    
    if (![[ALSdk shared] isInitialized]) {
        
        [[ALSdk shared] initializeWithConfiguration: initConfig completionHandler:^(ALSdkConfiguration *sdkConfig) {
            NSLog(@"LongUni initializeWithConfiguration");
        }];
        
        [self waitForInitialization];
        NSLog(@"LongUni waitForInitialization passed");
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
        if ([[ALSdk shared] isInitialized]) {
            [self.connector adapterDidSetupAd:self];
            return;
        }
        
        attempts++;
        // Wait for the specified interval before the next check
        dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(pollingInterval * NSEC_PER_SEC)));
    }

    // If it still isn't initialized after max attempts, log and notify error
    [self ALLog:@"Applovin SDK initialization timeout."];
    [self.connector adapter:self didFailToSetupAdWithError:[NSError errorWithDomain:kGNSAdapterAppLovinRewardVideoAdKeyErrorDomain
                                                                             code:101
                                                                         userInfo:@{NSLocalizedDescriptionKey: @"Applovin SDK initialization timeout."}]];
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
    NSError *error = [NSError errorWithDomain: kGNSAdapterAppLovinRewardVideoAdKeyErrorDomain
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
    GNSExtrasAppLovin *extras = [self.connector networkExtras];
    
    [self ALLog:[NSString stringWithFormat:@"Create Incent with Applovin zone_id = @%@",extras.zoneId]];
    
    self.maRewardedAd = [MARewardedAd sharedWithAdUnitIdentifier: extras.zoneId];
    self.maRewardedAd.delegate = self;
    
    [self.maRewardedAd loadAd];
    
}

- (void)presentAdWithRootViewController:(UIViewController *)viewController {
    if ([self isReadyForDisplay]) {
        [self.maRewardedAd showAd];
    }
}


- (void)stopBeingDelegate {
    self.connector = nil;
}

- (BOOL)isReadyForDisplay
{
    return [self.maRewardedAd isReady];
}

#pragma mark - MAAdDelegate Protocol

- (void)didLoadAd:(MAAd *)ad
{
    [self deleteTimer];
    [self.connector adapterDidReceiveAd:self];
}

- (void)didFailToLoadAdForAdUnitIdentifier:(NSString *)adUnitIdentifier withError:(MAError *)error
{
    
    [self deleteTimer];
    NSError *newError = [NSError errorWithDomain: kGNSAdapterAppLovinRewardVideoAdKeyErrorDomain
                                            code: error.code
                                        userInfo:@{NSLocalizedDescriptionKey: error.message}];
    [self.connector adapter: self didFailToLoadAdwithError: newError];
}

- (void)didDisplayAd:(MAAd *)ad {
    [self.connector adapterDidStartPlayingRewardVideoAd:self];
}

- (void)didClickAd:(MAAd *)ad {}

- (void)didHideAd:(MAAd *)ad
{
    [self.connector adapterDidCloseAd:self];
    // Rewarded ad is hidden. Pre-load the next ad
    [self.maRewardedAd loadAd];
}

- (void)didFailToDisplayAd:(MAAd *)ad withError:(MAError *)error
{
    [self deleteTimer];
    NSError *newError = [NSError errorWithDomain: kGNSAdapterAppLovinRewardVideoAdKeyErrorDomain
                                            code: error.code
                                        userInfo: error.message];
    [self.connector adapter: self didFailToLoadAdwithError: newError];
}

#pragma mark - MARewardedAdDelegate Protocol

- (void)didRewardUserForAd:(MAAd *)ad withReward:(MAReward *)reward
{
    GNSExtrasAppLovin *extras = [self.connector networkExtras];
    self.reward = [[GNSAdReward alloc]
                   initWithRewardType: extras.type
                   rewardAmount: extras.amount];
    [self.connector adapter: self didRewardUserWithReward: self.reward];
    self.reward = nil;
}

@end
