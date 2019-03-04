//
//  GNSAdapterTapjoyFullscreenInterstitialAd.m
//  GNAdFullscreenInterstitialSample
//

#import "GNSAdapterTapjoyFullscreenInterstitialAd.h"
#import <Tapjoy/TJPlacement.h>

static NSString *const kGNSAdapterTapjoyInterstitialAdKeyErrorDomain = @"jp.co.geniee.GNSAdapterTapjoyInterstitialAd";
static BOOL loggingEnable = YES;

@interface GNSAdapterTapjoyFullscreenInterstitialAd() <TJPlacementDelegate>
@property(nonatomic, retain) NSTimer *timer;
@property(nonatomic, assign) NSInteger timeout;
@property(nonatomic, weak)id<GNSAdNetworkConnector> connector;

@property(nonatomic, strong) TJPlacement *tjPlacement;
@property(nonatomic, strong) GNSExtrasFullscreenTapjoy *extras;

@end

@implementation GNSExtrasFullscreenTapjoy
@end

@implementation GNSAdapterTapjoyFullscreenInterstitialAd

- (void)AllLog:(NSString *)logMessage
{
    if (loggingEnable) {
        NSLog(@"[INFO]GNSInterstitialTapjoyAdapter: %@", logMessage);
    }
}

#pragma mark - GNSAdNetworkAdapter
+ (NSString *)adapterVersion {
    return @"2.7.0";
}

- (instancetype)initWithAdNetworkConnector:(id<GNSAdNetworkConnector>)connector {
    self = [super init];
    if (self) {
        self.connector = connector;
    }
    return self;
}

- (BOOL)isReadyForDisplay {
    if (!_tjPlacement) {
        return NO;
    }
    return [_tjPlacement isContentReady];
}

+ (Class<GNSAdNetworkExtras>)networkExtrasClass {
    return [GNSExtrasFullscreenTapjoy class];
}

- (id<GNSAdNetworkExtras>)networkExtrasParameter:(GNSAdNetworkExtraParams *)parameter {
    GNSExtrasFullscreenTapjoy *extra = [[GNSExtrasFullscreenTapjoy alloc] init];
    extra.tjSDKKey = parameter.external_link_id;
    extra.tjPlacementId = parameter.external_link_media_id;
    return extra;
}

- (void)presentAdWithRootViewController:(UIViewController *)viewController {
    if ([self isReadyForDisplay]) {
        [_tjPlacement showContentWithViewController:viewController];
        
        [self.connector adapterWillPresentScreenInterstitialAd:self];
    }
}

- (void)requestAd:(NSInteger)timeOut {
    if ([self isReadyForDisplay]) {
        [self.connector adapterDidReceiveAd:self];
        return;
    }
    [self setTimerWith:timeOut];
    _extras = [self.connector networkExtras];
    
    [self AllLog:[NSString stringWithFormat:@"tjSDKKey=%@", _extras.tjSDKKey]];
    [self AllLog:[NSString stringWithFormat:@"tjPlacementId=%@", _extras.tjPlacementId]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tjcConnectSuccess:)
                                                 name:TJC_CONNECT_SUCCESS
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tjcConnectFail:)
                                                 name:TJC_CONNECT_FAILED
                                               object:nil];
    
    [Tapjoy connect:_extras.tjSDKKey options:@{ TJC_OPTION_ENABLE_LOGGING : @(NO) }];
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
    NSError *error = [NSError errorWithDomain:kGNSAdapterTapjoyInterstitialAdKeyErrorDomain code:1 userInfo:errorInfo];
    [self.connector adapter:self didFailToLoadAdwithError:error];
}

#pragma TJC_CONNECT
-(void)tjcConnectSuccess:(NSNotification*)notifyObj
{
    if (_tjPlacement == nil) {
        _tjPlacement = [TJPlacement placementWithName: _extras.tjPlacementId delegate:self];
    }
    
    if ([Tapjoy isConnected]) {
        [_tjPlacement requestContent];
    } else {
        [self AllLog:@"Tapjoy SDK must finish connecting before requesting content."];
    }
    
}


- (void)tjcConnectFail:(NSNotification*)notifyObj
{
    [self deleteTimer];
    [self AllLog:@"tjcConnectFail: Tapjoy failed to connect"];
    NSDictionary *errorInfo = @{NSLocalizedDescriptionKey: @"Tapjoy failed to connect"};
    NSError *error = [NSError errorWithDomain:kGNSAdapterTapjoyInterstitialAdKeyErrorDomain code:1 userInfo:errorInfo];
    [self.connector adapter:self didFailToLoadAdwithError:error];
}

#pragma mark - TJPlacementDelegate
- (void)requestDidSucceed:(TJPlacement*)placement {
    [self AllLog:@"requestDidSucceed"];
}
- (void)requestDidFail:(TJPlacement*)placement error:(NSError*)error {
    
    [self deleteTimer];
    [self AllLog:[NSString stringWithFormat:@"didFailToLoadWithError error = %@", [error localizedDescription]]];
    [self.connector adapter:self didFailToLoadAdwithError:error];
}
- (void)contentIsReady:(TJPlacement*)placement {
    
    [self AllLog:@"contentIsReady"];
    [self deleteTimer];
    if (self.tjPlacement != nil && self.tjPlacement.isContentAvailable) {
        
        [self AllLog:@"There is some content for this placement"];
        [self.connector adapterDidReceiveAd:self];
        
    } else {
        
        [self AllLog:@"There is no content for this placement"];
        NSDictionary *errorInfo = @{ NSLocalizedDescriptionKey : @"There is no content for this placement" };
        NSError *error = [NSError errorWithDomain: kGNSAdapterTapjoyInterstitialAdKeyErrorDomain
                                             code: 1
                                         userInfo: errorInfo];
        [self.connector adapter: self didFailToLoadAdwithError: error];
    }
}

- (void)contentDidAppear:(TJPlacement*)placement {
}
- (void)contentDidDisappear:(TJPlacement*)placement {
    [self.connector adapterDidCloseAd:self];
}
- (void)placement:(TJPlacement*)placement didRequestPurchase:(TJActionRequest*)request productId:(NSString*)productId {
    
}

- (void)placement:(TJPlacement*)placement didRequestReward:(TJActionRequest*)request itemId:(NSString*)itemId quantity:(int)quantity {
    
}

@end
