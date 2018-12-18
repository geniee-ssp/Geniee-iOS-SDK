//
//  GNSAdapterZucksFullscreenInterstitialAd.m
//  GNAdFullscreenInterstitialAdapter
//

#import "GNSAdapterZucksFullscreenInterstitialAd.h"
@import ZucksAdNetworkSDK;

static NSString *const kGNSAdapterZucksInterstitialAdKeyErrorDomain = @"jp.co.geniee.GNSAdapterZucksInterstitialAd";
static BOOL loggingEnbale = YES;

@interface GNSAdapterZucksFullscreenInterstitialAd()<ZADNFullScreenInterstitialViewDelegate>
@property(nonatomic, retain) NSTimer *timer;
@property(nonatomic, assign) NSInteger timeout;
@property(nonatomic, assign) BOOL isReady;
@property(nonatomic, weak)id<GNSAdNetworkConnector> connector;
@end

@implementation GNSExtrasZucks
@end

@implementation GNSAdapterZucksFullscreenInterstitialAd

- (void)AllLog:(NSString *)logMessage
{
    if (loggingEnbale) {
        NSLog(@"[INFO]GNSInterstitialZucksAdapter: %@", logMessage);
    }
}

#pragma mark - GNSAdNetworkAdapter
+ (NSString *)adapterVersion {
    return @"2.6.0";
}

- (instancetype)initWithAdNetworkConnector:(id<GNSAdNetworkConnector>)connector {
    self = [super init];
    if (self) {
        self.connector = connector;
    }
    return self;
}

- (BOOL)isReadyForDisplay {
    return _isReady;
}

+ (Class<GNSAdNetworkExtras>)networkExtrasClass {
    return [GNSExtrasZucks class];
}

- (id<GNSAdNetworkExtras>)networkExtrasParameter:(GNSAdNetworkExtraParams *)parameter {
    GNSExtrasZucks *extra = [[GNSExtrasZucks alloc] init];
    extra.frameId = parameter.external_link_id;
    return extra;
}

- (void)presentAdWithRootViewController:(UIViewController *)viewController {
    if ([self isReady]) {
        [[ZADNFullScreenInterstitialView sharedInstance] show];
    }
}

- (void)requestAd:(NSInteger)timeOut {
    // 繰り返し表示を想定した実装方法により、表示する前に必ずloadAdしないと行けないです。
    if ([self isReadyForDisplay]) {
        [self.connector adapterDidReceiveAd:self];
        return;
    }
    [self setTimerWith:timeOut];
    GNSExtrasZucks *extra = [self.connector networkExtras];
    dispatch_async(dispatch_get_main_queue(), ^{
        [ZADNFullScreenInterstitialView sharedInstance].frameId = extra.frameId;
        [[ZADNFullScreenInterstitialView sharedInstance] loadAd];
        [ZADNFullScreenInterstitialView sharedInstance].delegate = self;
    });

}

- (void)setUp {
    [self AllLog:@"setup"];
    [self.connector adapterDidSetupAd:self];
}

- (void)stopBeingDelegate {
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
    NSError *error = [NSError errorWithDomain:kGNSAdapterZucksInterstitialAdKeyErrorDomain code:1 userInfo:errorInfo];
    [self.connector adapter:self didFailToLoadAdwithError:error];
}

#pragma mark ZADNFullScreenInterstitialViewDelegate methods
- (void)fullScreenInterstitialViewDidReceiveAd {
    [self deleteTimer];
    _isReady = YES;
    [self AllLog:@"ZucksInterstitialAd is loaded successfully"];
    [self.connector adapterDidReceiveAd:self];
}

- (void)fullScreenInterstitialViewDidLoadFailAdWithErrorType:
(ZADNFullScreenInterstitialLoadErrorType)errorType {
    [self deleteTimer];
    _isReady = NO;
    NSString *errorMessage = @"";
    switch (errorType) {
        case ZADNFullScreenBannerErrorTypeOffline:
            errorMessage = @"Zucks offline";
            break;
        case ZADNFullScreenBannerErrorTypeFrameIdUndefined:
            errorMessage = @"Zucks frameId undefined";
            break;
        case ZADNFullScreenBannerErrorTypeSizeError:
            errorMessage = @"Zucks size error";
            break;
        case ZADNFullScreenBannerErrorTypeAdOutOfStock:
            errorMessage = @"Zucks ad out of stock";
            break;
        case ZADNFullScreenBannerErrorTypeOtherError:
            errorMessage = @"Zucks other error";
            break;
        default:
            break;
    }
    NSDictionary *errorInfo = @{NSLocalizedDescriptionKey: errorMessage};
    NSError *error = [NSError errorWithDomain:kGNSAdapterZucksInterstitialAdKeyErrorDomain code:1 userInfo:errorInfo];
    [self AllLog:[NSString stringWithFormat:@"didFailToLoadWithError error = %@", [error localizedDescription]]];
    [self.connector adapter:self didFailToLoadAdwithError:error];
}

- (void)fullScreenInterstitialViewDidShowAd {
    [self AllLog:@"Zucks interstitial is showing."];
    _isReady = NO;
    [self.connector adapterWillPresentScreenInterstitialAd:self];
}

- (void)fullScreenInterstitialViewDidTapAd {
    [self AllLog:@"Zucks interstitial did clicked."];
    [self.connector adapterDidClickAd:self];
}

- (void)fullScreenInterstitialViewDidDismissAd {
    [self AllLog:@"Zucks interstitial did closed."];
    [self.connector adapterDidCloseAd:self];
}

- (void)fullScreenInterstitialViewCancelDisplayRate {
    [self AllLog:@"Zucks interstitial cancel display rate."];
}

- (void)fullScreenInterstitialViewDidShowFailAdWithErrorType:
(ZADNFullScreenInterstitialShowErrorType)errorType {
    [self AllLog:@"Zucks interstitial show failed."];
}

@end
