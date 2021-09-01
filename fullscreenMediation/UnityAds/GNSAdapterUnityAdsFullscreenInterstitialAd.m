//
//  GNSAdapterUnityAdsFullscreenInterstitialAd.h
//  GNAdSDK
//

#import "GNSAdapterUnityAdsFullscreenInterstitialAd.h"

#import "UnityAds/UnityAds.h"
#import <GNAdSDK/GNSAdNetworkConnectorProtocol.h>
#import <GNAdSDK/GNSAdNetworkExtraParams.h>

static NSString *const kGNSAdapterUnityAdsInterstitialAdKeyErrorDomain = @"jp.co.geniee.GNSAdapterUnityAdsInterstitialAd";
static BOOL loggingEnabled = YES;

@interface GNSAdapterUnityAdsFullscreenInterstitialAd () <UnityAdsDelegate>

@property(nonatomic, weak) id<GNSAdNetworkConnector> connector;
@property (nonatomic, retain) NSTimer *timer;

@end

@implementation GNSExtrasUnityAds
@end

@implementation GNSAdapterUnityAdsFullscreenInterstitialAd

- (void)ALLog:(NSString *)logMessage {
    if (loggingEnabled) {
        NSLog(@"[INFO]GNSUnityAdsAdapter: %@", logMessage);
    }
}

+ (NSString *)adapterVersion {
    return @"3.0.1";
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
    NSError *error = [NSError errorWithDomain: kGNSAdapterUnityAdsInterstitialAdKeyErrorDomain
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
    [self ALLog:[NSString stringWithFormat:@"UnityAds request game_id=%@ placement_id=%@", extras.game_id, extras.placement_id]];
    
    [UnityAds initialize:extras.game_id delegate:self];
}

- (BOOL)isReadyForDisplay {
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

- (void)unityAdsDidError:(UnityAdsError)error withMessage:(nonnull NSString *)message {
    
    [self ALLog: [NSString stringWithFormat:@"unityAdsDidError message = %@", message]];
    [self deleteTimer];
    NSDictionary *errorInfo = @{ NSLocalizedDescriptionKey : message };
    NSError *ns_error = [NSError errorWithDomain: kGNSAdapterUnityAdsInterstitialAdKeyErrorDomain
                                            code: error
                                        userInfo: errorInfo];
    [self.connector adapter: self didFailToLoadAdwithError: ns_error];
}

- (void)unityAdsDidFinish:(nonnull NSString *)placementId withFinishState:(UnityAdsFinishState)state {
    
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
    [self ALLog: [NSString stringWithFormat:@"unityAdsDidFinish state = %@", stateString]];
    
    if (state == kUnityAdsFinishStateCompleted){
        
    }
    [self.connector adapterDidCloseAd:self];
}

- (void)unityAdsDidStart:(nonnull NSString *)placementId {
    [self ALLog: @"unityAdsDidStart"];
    [self.connector adapterWillPresentScreenInterstitialAd:self];
}

- (void)unityAdsReady:(nonnull NSString *)placementId {
    [self ALLog: @"unityAdsReady"];
    [self deleteTimer];
    [self.connector adapterDidReceiveAd:self];
}

@end

