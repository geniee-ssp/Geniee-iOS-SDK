//
//  GNSAdapterImobileFullscreenInterstitialAd.m
//  GNAdFullscreenInterstitialAdapter
//

#import "GNSAdapterImobileFullscreenInterstitialAd.h"
#include <ImobileSdkAds/ImobileSdkAds.h>

static NSString *const kGNSAdapterImobileInterstitialAdKeyErrorDomain = @"jp.co.geniee.GNSAdapterImobileInterstitialAd";
static BOOL loggingEnbale = YES;

@interface GNSAdapterImobileFullscreenInterstitialAd() <IMobileSdkAdsDelegate>
@property(nonatomic, retain) NSTimer *timer;
@property(nonatomic, assign) BOOL isReady;
@property(nonatomic, weak)id<GNSAdNetworkConnector> connector;
@end

@implementation GNSExtrasImobile
@end

@implementation GNSAdapterImobileFullscreenInterstitialAd

- (void)AllLog:(NSString *)logMessage
{
    if (loggingEnbale) {
        NSLog(@"[INFO]GNSInterstitialImobileAdapter: %@", logMessage);
    }
}

#pragma mark - GNSAdNetworkAdapter
+ (NSString *)adapterVersion
{
    return @"3.0.1";
}

+ (Class<GNSAdNetworkExtras>)networkExtrasClass
{
    return [GNSExtrasImobile class];
}

- (id<GNSAdNetworkExtras>)networkExtrasParameter:(GNSAdNetworkExtraParams *)parameter
{
    GNSExtrasImobile *extra = [[GNSExtrasImobile alloc] init];
    extra.publisherId = @"66102";
    extra.mediaId = parameter.external_link_id;
    extra.spotId = parameter.external_link_media_id;
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

- (void)setUp
{
    [self AllLog:@"setup"];
    [self.connector adapterDidSetupAd:self];
}

- (void)requestAd:(NSInteger)timeOut
{
    if ([self isReadyForDisplay]) {
        [self.connector adapterDidReceiveAd:self];
        return;
    }
    [self setTimerWith:timeOut];
    GNSExtrasImobile *extra = [self.connector networkExtras];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [ImobileSdkAds registerWithPublisherID:extra.publisherId MediaID:extra.mediaId SpotID:extra.spotId];
        [ImobileSdkAds setSpotDelegate:extra.spotId delegate:self];
        [ImobileSdkAds startBySpotID:extra.spotId];
    });
}

- (void)presentAdWithRootViewController:(UIViewController *)viewController
{
    GNSExtrasImobile *extra = [self.connector networkExtras];
    if ([self isReadyForDisplay]) {
        [ImobileSdkAds showBySpotID:extra.spotId];
    }
}

- (BOOL)isReadyForDisplay
{
    return _isReady;
}

- (void)stopBeingDelegate
{
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
    NSError *error = [NSError errorWithDomain:kGNSAdapterImobileInterstitialAdKeyErrorDomain code:1 userInfo:errorInfo];
    [self.connector adapter:self didFailToLoadAdwithError:error];
}

#pragma mark IMobileSdkAdsDelegate

- (void)imobileSdkAdsSpot:(NSString *)spotid didReadyWithValue:(ImobileSdkAdsReadyResult)value {
    
    [self deleteTimer];
    _isReady = YES;
    [self.connector adapterDidReceiveAd:self];
}

- (void)imobileSdkAdsSpotDidShow:(NSString *)spotid {
    _isReady = NO;
    [self.connector adapterWillPresentScreenInterstitialAd:self];
}

- (void)imobileSdkAdsSpotDidClick:(NSString *)spotid {
    [self.connector adapterDidClickAd:self];
}

- (void)imobileSdkAdsSpotDidClose:(NSString *)spotid {
    [self.connector adapterDidCloseAd:self];
}

- (void)imobileSdkAdsSpot:(NSString *)spotid didFailWithValue:(ImobileSdkAdsFailResult)value {
    
    [self deleteTimer];
    _isReady = NO;
    
    NSString *msg;
    switch (value) {
        case IMOBILESDKADS_ERROR_PARAM:
            msg = @"IMOBILESDKADS_ERROR_PARAM";
            break;
        case IMOBILESDKADS_ERROR_AUTHORITY:
            msg = @"IMOBILESDKADS_ERROR_AUTHORITY";
            break;
        case IMOBILESDKADS_ERROR_RESPONSE:
            msg = @"IMOBILESDKADS_ERROR_RESPONSE";
            break;
        case IMOBILESDKADS_ERROR_NETWORK_NOT_READY:
            msg = @"IMOBILESDKADS_ERROR_NETWORK_NOT_READY";
            break;
        case IMOBILESDKADS_ERROR_NETWORK:
            msg = @"IMOBILESDKADS_ERROR_NETWORK";
            break;
        case IMOBILESDKADS_ERROR_UNKNOWN:
            msg = @"IMOBILESDKADS_ERROR_UNKNOWN";
            break;
        case IMOBILESDKADS_ERROR_AD_NOT_READY:
            msg = @"IMOBILESDKADS_ERROR_AD_NOT_READY";
            break;
        case IMOBILESDKADS_ERROR_NOT_FOUND:
            msg = @"IMOBILESDKADS_ERROR_NOT_FOUND";
            break;
        case IMOBILESDKADS_ERROR_SHOW_TIMEOUT:
            msg = @"IMOBILESDKADS_ERROR_SHOW_TIMEOUT";
            break;
        default:
            msg = @"UNKNOWN";
            break;
    }
    
    NSDictionary *errorInfo = @{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"didFailWithValue: %@", msg]};
    NSError *error = [NSError errorWithDomain:kGNSAdapterImobileInterstitialAdKeyErrorDomain code:1 userInfo:errorInfo];
    [self.connector adapter:self didFailToLoadAdwithError:error];
}

@end
