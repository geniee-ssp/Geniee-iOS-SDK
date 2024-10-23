//
//  GNSAdapterNendFullscreenInterstitialAd.m
//  GNAdFullscreenInterstitialAdapter
//

#import "GNSAdapterNendFullscreenInterstitialAd.h"
#import <NendAd/NADInterstitialVideo.h>
#import <NendAd/NADFullBoardLoader.h>

static NSString *const kGNSAdapterNendInterstitialAdKeyErrorDomain = @"jp.co.geniee.GNSAdapterNendInterstitialAd";
static BOOL loggingEnbale = YES;

@interface GNSAdapterNendFullscreenInterstitialAd() <NADFullBoardDelegate, NADInterstitialVideoDelegate>
@property(nonatomic, retain) NSTimer *timer;
@property(nonatomic, assign) BOOL isFullboardLoaded;
@property(nonatomic, assign) BOOL isIntersitialVideoLoaded;
@property(nonatomic, weak)id<GNSAdNetworkConnector> connector;
@property(nonatomic)NADInterstitialVideo *interstitialVideo;
@property(nonatomic)NADFullBoardLoader *loader;
@property(nonatomic)NADFullBoard *fullboardAd;
@end

@implementation GNSExtrasNend
@end

@implementation GNSAdapterNendFullscreenInterstitialAd

- (void)AllLog:(NSString *)logMessage
{
    if (loggingEnbale) {
        NSLog(@"[INFO]GNSInterstitialNendAdapter: %@", logMessage);
    }
}

#pragma mark - GNSAdNetworkAdapter
+ (NSString *)adapterVersion
{
    return @"3.1.1";
}

+ (Class<GNSAdNetworkExtras>)networkExtrasClass
{
    return [GNSExtrasNend class];
}

- (id<GNSAdNetworkExtras>)networkExtrasParameter:(GNSAdNetworkExtraParams *)parameter
{
    GNSExtrasNend *extra = [[GNSExtrasNend alloc] init];
    extra.spotId = parameter.external_link_id;
    extra.apiKey = parameter.external_link_media_id;
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
    GNSExtrasNend *extra = [self.connector networkExtras];
    _isFullboardLoaded = NO;
    self.loader = [[NADFullBoardLoader alloc]initWithSpotId:extra.spotId apiKey:extra.apiKey];
    __weak __typeof(self) weakSelf = self;
    [self.loader loadAdWithCompletionHandler:^(NADFullBoard *ad, NADFullBoardLoaderError error) {
        weakSelf.isFullboardLoaded = YES;
        if (ad) {
            ad.delegate = weakSelf;
            weakSelf.fullboardAd = ad;
        } else {
            if (weakSelf.isIntersitialVideoLoaded && !weakSelf.interstitialVideo.isReady) {
                NSString *errorMessage = @"";
                switch (error) {
                    case NADFullBoardLoaderErrorFailedAdRequest:
                        errorMessage = @"広告リクエストに失敗しました。";
                        break;
                    case NADFullBoardLoaderErrorInvalidAdSpaces:
                        errorMessage = @"フルボード広告で利用できない広告枠が指定されました。";
                        break;
                    case NADFullBoardLoaderErrorFailedDownloadImage:
                        errorMessage = @"広告画像のダウンロードに失敗しました。";
                        break;
                    default:
                        break;
                }
                NSDictionary *errorInfo = @{NSLocalizedDescriptionKey: errorMessage};
                NSError *error = [NSError errorWithDomain:kGNSAdapterNendInterstitialAdKeyErrorDomain code:1 userInfo:errorInfo];
                [weakSelf.connector adapter:self didFailToLoadAdwithError:error];
            }
        }
    }];
    
    // Interstitial Video load
    self.interstitialVideo = [[NADInterstitialVideo alloc]initWithSpotId:extra.spotId apiKey:extra.apiKey];
    self.interstitialVideo.delegate = self;
    _isIntersitialVideoLoaded = NO;
    [self.interstitialVideo loadAd];
}

- (void)presentAdWithRootViewController:(UIViewController *)viewController
{
    if ([self isReadyForDisplay]) {
        if (self.interstitialVideo.isReady) {
            [self.interstitialVideo showAdFromViewController:viewController];
        } else if (self.fullboardAd){
            [self.fullboardAd showFromViewController:viewController];
        }
    }
}

- (BOOL)isReadyForDisplay
{
    return (self.fullboardAd || self.interstitialVideo.isReady);
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
    NSError *error = [NSError errorWithDomain:kGNSAdapterNendInterstitialAdKeyErrorDomain code:1 userInfo:errorInfo];
    [self.connector adapter:self didFailToLoadAdwithError:error];
}

#pragma mark NADFullBoardDelegate
- (void)NADFullBoardDidShowAd:(NADFullBoard *)ad
{
    [self AllLog:@"Nend fullboard is showing."];
    [self.connector adapterWillPresentScreenInterstitialAd:self];
}

- (void)NADFullBoardDidClickAd:(NADFullBoard *)ad
{
    [self AllLog:@"Nend Fullboard did clicked."];
    [self.connector adapterDidClickAd:self];
}

- (void)NADFullBoardDidDismissAd:(NADFullBoard *)ad
{
    [self AllLog:@"Nend Fullboard did closed."];
    [self.connector adapterDidCloseAd:self];

}

#pragma mark NADInterstitialVideoDelegate
- (void)nadInterstitialVideoAdDidReceiveAd:(NADInterstitialVideo *)nadInterstitialVideoAd
{
    [self deleteTimer];
    _isIntersitialVideoLoaded = YES;
    [self AllLog:@"NendInterstitialAd is loaded successfully"];
    [self.connector adapterDidReceiveAd:self];
}

- (void)nadInterstitialVideoAd:(NADInterstitialVideo *)nadInterstitialVideoAd didFailToLoadWithError:(NSError *)error
{
    [self deleteTimer];
    _isIntersitialVideoLoaded = YES;
    if (_isFullboardLoaded && !self.fullboardAd) {
        [self AllLog:[NSString stringWithFormat:@"didFailToLoadWithError error = %@", [error localizedDescription]]];
        [self.connector adapter:self didFailToLoadAdwithError:error];
    }
}

- (void)nadInterstitialVideoAdDidStartPlaying:(NADInterstitialVideo *)nadInterstitialVideoAd
{
    [self AllLog:@"Nend InterstitialVideo is showing."];
    [self.connector adapterWillPresentScreenInterstitialAd:self];
}

- (void)nadInterstitialVideoAdDidClose:(NADInterstitialVideo *)nadInterstitialVideoAd
{
    [self AllLog:@"Nend InterstitialVideo did closed."];
    [self.connector adapterDidCloseAd:self];
}

- (void)nadInterstitialVideoAdDidClickAd:(NADInterstitialVideo *)nadInterstitialVideoAd
{
    [self AllLog:@"Nend Interstitial did clicked."];
    [self.connector adapterDidClickAd:self];
}

@end
