//
//  GNSAdapterApplovinFullscreenInterstitialAd.m
//  GNAdFullscreenInterstitialAdapter
//

#import "GNSAdapterAppLovinFullscreenInterstitialAd.h"

#import <AppLovinSDK/AppLovinSDK.h>

static NSString *const kGNSAdapterApplovinInterstitialAdKeyErrorDomain = @"jp.co.geniee.GNSAdapterApplovinInterstitialAd";
static BOOL loggingEnbale = YES;

@interface GNSAdapterAppLovinFullscreenInterstitialAd()<MAAdDelegate>
@property(nonatomic, weak)id<GNSAdNetworkConnector> connector;
@property(nonatomic, retain) NSTimer *timer;
@property (nonatomic, strong) MAInterstitialAd *maInterstitialAd;

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
    return @"3.1.1";
}

- (instancetype)initWithAdNetworkConnector:(id<GNSAdNetworkConnector>)connector {
    self = [super init];
    if (self) {
        self.connector = connector;
    }
    return self;
}

- (BOOL)isReadyForDisplay {
    return [self.maInterstitialAd isReady];
}

+ (Class<GNSAdNetworkExtras>)networkExtrasClass {
    return [GNSExtrasFullscreenApplovin class];
}

- (id<GNSAdNetworkExtras>)networkExtrasParameter:(GNSAdNetworkExtraParams *)parameter {
    GNSExtrasFullscreenApplovin *extra = [[GNSExtrasFullscreenApplovin alloc]init];
    extra.sdkKey = parameter.external_link_media_id;
    extra.zone_id = parameter.external_link_id;
    return extra;
}

- (void)presentAdWithRootViewController:(UIViewController *)viewController {
    if ([self isReadyForDisplay]) {
        [self.maInterstitialAd showAd];
    }
}

- (void)requestAd:(NSInteger)timeOut {
    if ([self isReadyForDisplay]) {
        [self.connector adapterDidReceiveAd:self];
        return;
    }
    [self setTimerWith:timeOut];
    GNSExtrasFullscreenApplovin *extras = [self.connector networkExtras];
    
    self.maInterstitialAd = [[MAInterstitialAd alloc] initWithAdUnitIdentifier: extras.zone_id];
    self.maInterstitialAd.delegate = self;

    // Load the first ad
    [self.maInterstitialAd loadAd];
}

- (void)setUp {
    
    [self AllLog:[NSString stringWithFormat:@"setUp AppLovin version = %@", [ALSdk version]]];
    
    GNSExtrasFullscreenApplovin *extras = [self.connector networkExtras];
    
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
        if ([[ALSdk shared] isInitialized]) {
            [self.connector adapterDidSetupAd:self];
            return;
        }
        
        attempts++;
        // Wait for the specified interval before the next check
        dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(pollingInterval * NSEC_PER_SEC)));
    }

    // If it still isn't initialized after max attempts, log and notify error
    [self AllLog:@"Applovin SDK initialization timeout."];
    [self.connector adapter:self didFailToSetupAdWithError:[NSError errorWithDomain:kGNSAdapterApplovinInterstitialAdKeyErrorDomain
                                                                             code:101
                                                                         userInfo:@{NSLocalizedDescriptionKey: @"Applovin SDK initialization timeout."}]];
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

#pragma mark - MAAdDelegate Protocol

- (void)didLoadAd:(MAAd *)ad
{
    [self deleteTimer];
    [self.connector adapterDidReceiveAd:self];
}


- (void)didFailToLoadAdForAdUnitIdentifier:(NSString *)adUnitIdentifier withError:(MAError *)error
{
    [self deleteTimer];
    NSDictionary *errorInfo = @{ NSLocalizedDescriptionKey : error.message };
    NSError *withError = [NSError errorWithDomain: kGNSAdapterApplovinInterstitialAdKeyErrorDomain
                                         code: error.code
                                     userInfo: errorInfo];
    [self.connector adapter: self didFailToLoadAdwithError: withError];
}

- (void)didDisplayAd:(MAAd *)ad {
    [self.connector adapterWillPresentScreenInterstitialAd:self];
}

- (void)didClickAd:(MAAd *)ad {}

- (void)didHideAd:(MAAd *)ad
{
    [self.connector adapterDidCloseAd:self];
}

- (void)didFailToDisplayAd:(MAAd *)ad withError:(MAError *)error
{
    [self.connector adapterDidCloseAd:self];
}


@end
