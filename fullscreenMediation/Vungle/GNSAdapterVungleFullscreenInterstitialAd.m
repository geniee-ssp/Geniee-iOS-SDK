//
//  GNSAdapterVungleFullscreenInterstitialAd.m
//  GNAdSDK
//

#import "GNSAdapterVungleFullscreenInterstitialAd.h"
#import <VungleAdsSDK/VungleAdsSDK.h>
#import <GNAdSDK/GNSAdNetworkConnectorProtocol.h>
#import <GNAdSDK/GNSAdNetworkExtraParams.h>

static NSString *const kGNSAdapterVungleInterstitialAdKeyErrorDomain = @"jp.co.geniee.GNSAdapterVungleInterstitialAd";
static BOOL loggingEnabled = YES;

@interface GNSAdapterVungleFullscreenInterstitialAd () <UIApplicationDelegate, VungleInterstitialDelegate>

@property(nonatomic, weak) id<GNSAdNetworkConnector> connector;

@property (nonatomic, retain) NSTimer *timer;

@property (nonatomic, strong) VungleInterstitial *vungleInterstitialAd;

@property(nonatomic, assign) BOOL requestingAd;

@end

@implementation GNSExtrasVungle
@end

@implementation GNSAdapterVungleFullscreenInterstitialAd

- (void)ALLog:(NSString *)logMessage {
    if (loggingEnabled) {
        NSLog(@"[INFO]GNSVungleAdapter: %@", logMessage);
    }
}

+ (NSString *)adapterVersion {
    return @"3.1.1";
}

+ (Class<GNSAdNetworkExtras>)networkExtrasClass {
    return [GNSExtrasVungle class];
}

- (id<GNSAdNetworkExtras>)networkExtrasParameter:(GNSAdNetworkExtraParams *) parameter
{
    GNSExtrasVungle * extra = [[GNSExtrasVungle alloc]init];
    extra.app_id = parameter.external_link_id;
    extra.placementReferenceId = parameter.external_link_media_id;
    
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
    [self.connector adapter:self didFailToSetupAdWithError:[NSError errorWithDomain:kGNSAdapterVungleInterstitialAdKeyErrorDomain
                                                                               code:101
                                                                           userInfo:@{NSLocalizedDescriptionKey: @"Vungle SDK initialization timeout."}]];
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
    
    GNSExtrasVungle *extras = [self.connector networkExtras];
    
    self.vungleInterstitialAd = [[VungleInterstitial alloc] initWithPlacementId:extras.placementReferenceId];
    self.vungleInterstitialAd.delegate = self;
    [self.vungleInterstitialAd load:nil];
}

- (void)presentAdWithRootViewController:(UIViewController *)viewController {
    
    if([self isReadyForDisplay]) {
        [self.vungleInterstitialAd presentWith:viewController];
    }
}

- (void)stopBeingDelegate {
    self.connector = nil;
    if (self.vungleInterstitialAd != nil) {
        [self.vungleInterstitialAd setDelegate:nil];
    }
}

- (BOOL)isReadyForDisplay
{
    return [self.vungleInterstitialAd canPlayAd];
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

#pragma mark - VungleInterstitial Delegate Methods
// Ad load events
- (void)interstitialAdDidLoad:(VungleInterstitial *)interstitial {
    [self deleteTimer];
    [self.connector adapterDidReceiveAd:self];
}
- (void)interstitialAdDidFailToLoad:(VungleInterstitial *)interstitial
                          withError:(NSError *)withError {
    [self deleteTimer];
    [self onErrorWithMessage:withError.description];
}
// Ad Lifecycle Events
- (void)interstitialAdWillPresent:(VungleInterstitial *)interstitial {
    [self.connector adapterWillPresentScreenInterstitialAd:self];
}
- (void)interstitialAdDidPresent:(VungleInterstitial *)interstitial {
    
}
- (void)interstitialAdDidFailToPresent:(VungleInterstitial *)interstitial
                             withError:(NSError *)withError {
}
- (void)interstitialAdDidTrackImpression:(VungleInterstitial *)interstitial {
}
- (void)interstitialAdDidClick:(VungleInterstitial *)interstitial {
}
- (void)interstitialAdWillLeaveApplication:(VungleInterstitial *)interstitial {
}
- (void)interstitialAdWillClose:(VungleInterstitial *)interstitial {
}
- (void)interstitialAdDidClose:(VungleInterstitial *)interstitial {
    [self.connector adapterDidCloseAd:self];
}

@end
