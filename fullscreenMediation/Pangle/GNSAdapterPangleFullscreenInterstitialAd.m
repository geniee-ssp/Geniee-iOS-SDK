//
//  GNSAdapterTapjoyFullscreenInterstitialAd.m
//  GNAdFullscreenInterstitialSample
//

#import "GNSAdapterPangleFullscreenInterstitialAd.h"
#import <GNAdSDK/GNSAdNetworkExtraParams.h>
#import <PAGAdSDK/PAGAdSDK.h>

static NSString *const kGNSAdapterPangleInterstitialAdKeyErrorDomain = @"jp.co.geniee.GNSAdapterPangleInterstitialAd";
static BOOL loggingEnable = YES;

@interface GNSAdapterPangleFullscreenInterstitialAd() <PAGLInterstitialAdDelegate>
@property(nonatomic, retain) NSTimer *timer;
@property(nonatomic, assign) NSInteger timeout;
@property(nonatomic, weak)id<GNSAdNetworkConnector> connector;

@property(nonatomic, strong) PAGLInterstitialAd *pangleInterstialAd;
@property(nonatomic, strong) GNSExtrasFullscreenPangle *extras;

@end

@implementation GNSExtrasFullscreenPangle
@end

@implementation GNSAdapterPangleFullscreenInterstitialAd

- (void)AllLog:(NSString *)logMessage
{
    if (loggingEnable) {
        NSLog(@"[INFO]GNSInterstitialPangleAdapter: %@", logMessage);
    }
}

#pragma mark - GNSAdNetworkAdapter
+ (NSString *)adapterVersion {
    return @"3.1.0";
}

- (instancetype)initWithAdNetworkConnector:(id<GNSAdNetworkConnector>)connector {
    self = [super init];
    if (self) {
        self.connector = connector;
    }
    return self;
}

- (BOOL)isReadyForDisplay {
    return self.pangleInterstialAd != nil;
}

+ (Class<GNSAdNetworkExtras>)networkExtrasClass {
    return [GNSExtrasFullscreenPangle class];
}

- (id<GNSAdNetworkExtras>)networkExtrasParameter:(GNSAdNetworkExtraParams *)parameter {
    GNSExtrasFullscreenPangle *extra = [[GNSExtrasFullscreenPangle alloc] init];
    extra.pangleAppId = parameter.external_link_id;
    extra.pangleAdUnitId = parameter.external_link_media_id;
    return extra;
}

- (void)presentAdWithRootViewController:(UIViewController *)viewController {
    if (self.pangleInterstialAd != nil) {
        [self.pangleInterstialAd presentFromRootViewController:viewController];
        
        [self.connector adapterWillPresentScreenInterstitialAd:self];
    }
}

- (void)requestAd:(NSInteger)timeOut {
    
    if ([self isReadyForDisplay]) {
        [self.connector adapterDidReceiveAd:self];
        return;
    }
    [self setTimerWith:timeOut];
    
    GNSExtrasFullscreenPangle *extras = [self.connector networkExtras];
    
    PAGInterstitialRequest *request = [PAGInterstitialRequest request];
    
    [PAGLInterstitialAd loadAdWithSlotID:extras.pangleAdUnitId
                                 request:request completionHandler:^(PAGLInterstitialAd * _Nullable interstitialAd, NSError * _Nullable error) {
        
        if (error) {
            NSDictionary *errorInfo = @{NSLocalizedDescriptionKey: error.description};
            NSError *error = [NSError errorWithDomain:kGNSAdapterPangleInterstitialAdKeyErrorDomain code:1 userInfo:errorInfo];
            [self.connector adapter:self didFailToLoadAdwithError:error];
            
            [self deleteTimer];
            return;
        }
        
        self.pangleInterstialAd = interstitialAd;
        self.pangleInterstialAd.delegate = self;
        
        [self deleteTimer];
        [self.connector adapterDidReceiveAd:self];
    }];
}

- (void)setUp {
    [self AllLog:@"setup"];
    
    GNSExtrasFullscreenPangle *extras = [self.connector networkExtras];
    
    PAGConfig *config = [PAGConfig shareConfig];
    config.appID = extras.pangleAppId;
    [PAGSdk startWithConfig:config completionHandler:^(BOOL success, NSError * _Nonnull error) {
        if (error) {
            
            NSDictionary *errorInfo = @{NSLocalizedDescriptionKey: @"Could not initialize Pangle SDK."};
            NSError *newError = [NSError errorWithDomain:kGNSAdapterPangleInterstitialAdKeyErrorDomain code:1 userInfo:errorInfo];
            [self.connector adapter:self didFailToLoadAdwithError:newError];
            return;
        }
    }];
    
    [self.connector adapterDidSetupAd:self];
}

- (void)stopBeingDelegate {
    self.connector = nil;
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

- (void)sendDidFailToLoadAdWithTimeout
{
    [self deleteTimer];
    [self AllLog:@"Interstial Ad loading timeout."];
    NSDictionary *errorInfo = @{NSLocalizedDescriptionKey: @"Interstitial ad loading timeout."};
    NSError *error = [NSError errorWithDomain:kGNSAdapterPangleInterstitialAdKeyErrorDomain code:1 userInfo:errorInfo];
    [self.connector adapter:self didFailToLoadAdwithError:error];
}

#pragma PAGLInterstitialAdDelegate

- (void)adDidShow:(PAGLInterstitialAd *)ad{
    [self.connector adapterWillPresentScreenInterstitialAd:self];
}

- (void)adDidClick:(PAGLInterstitialAd *)ad{
    [self.connector adapterDidClickAd:self];
}

- (void)adDidDismiss:(PAGLInterstitialAd *)ad{
    [self.connector adapterDidCloseAd:self];
    
    if (self.pangleInterstialAd != nil) {
        self.pangleInterstialAd = nil;
    }
}

@end
