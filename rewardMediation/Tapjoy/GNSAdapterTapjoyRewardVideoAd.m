//
//  GNSAdapterTapjoyRewardVideoAd.m
//  GNAdSDK
//

#import "GNSAdapterTapjoyRewardVideoAd.h"
#import <Tapjoy/Tapjoy.h>
#import <Tapjoy/TJPlacement.h>
#import <GNAdSDK/GNSAdNetworkConnectorProtocol.h>
#import <GNAdSDK/GNSAdNetworkExtraParams.h>
#import <GNAdSDK/GNSAdReward.h>

static NSString *const kGNSAdapterTapjoyRewardVideoAdKeyErrorDomain = @"jp.co.geniee.GNSAdapterTapjoyRewardVideoAd";
static BOOL loggingEnabled = YES;
static BOOL establishingConnection = NO;


@interface GNSAdapterTapjoyRewardVideoAd () <UIApplicationDelegate, TJPlacementDelegate, TJPlacementVideoDelegate>

@property(nonatomic, strong) GNSAdReward *reward;
@property(nonatomic, weak) TJPlacement *p;
@property(nonatomic, assign) BOOL requestingAd;

@property(nonatomic, weak) id<GNSAdNetworkConnector> connector;
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, assign) NSInteger timeout;

@end

@implementation GNSExtrasTapjoy
@end

@implementation GNSAdapterTapjoyRewardVideoAd

- (void)ALLog:(NSString *)logMessage {
    if (loggingEnabled) {
        NSLog(@"[INFO]GNSTapjoyAdapter: %@", logMessage);
    }
}

+ (NSString *)adapterVersion {
    return @"3.1.1";
}

+ (Class<GNSAdNetworkExtras>)networkExtrasClass {
    return [GNSExtrasTapjoy class];
}

- (id<GNSAdNetworkExtras>)networkExtrasParameter:(GNSAdNetworkExtraParams *) parameter
{
    GNSExtrasTapjoy * extra = [[GNSExtrasTapjoy alloc]init];
    extra.sdk_key = parameter.external_link_media_id;
    extra.placement_id = parameter.external_link_id;
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
    
    [self ALLog:[NSString stringWithFormat:@"setUp Tapjoy version = %ld", (long)[Tapjoy version]]];
    
    //Set up success and failure notifications
    if ([Tapjoy isLimitedConnected] == false) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(tjcConnectSuccess:)
                                                     name:TJC_LIMITED_CONNECT_SUCCESS
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(tjcConnectFail:)
                                                     name:TJC_LIMITED_CONNECT_FAILED
                                                   object:nil];
        //Turn on Tapjoy debug mode
        //[Tapjoy setDebugEnabled:YES];

        //Connect to Tapjoy server
        if (establishingConnection == NO) {
            GNSExtrasTapjoy *extras = [self.connector networkExtras];
            [Tapjoy limitedConnect:extras.sdk_key];
            establishingConnection = YES;
        }
    }
    [self.connector adapterDidSetupAd:self];
}

- (void)setTimerWith:(NSInteger)timeout
{
    dispatch_async(dispatch_get_main_queue(), ^{
        _timer = [NSTimer scheduledTimerWithTimeInterval:timeout
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
    NSError *error = [NSError errorWithDomain: kGNSAdapterTapjoyRewardVideoAdKeyErrorDomain
                                         code: 1
                                     userInfo: errorInfo];
    [self.connector adapter: self didFailToLoadAdwithError: error];
}


- (void)requestAd:(NSInteger)timeout {
    _timeout = timeout;
    self.requestingAd = YES;
    //Start connect sdk
    if ([Tapjoy isLimitedConnected] == false) {
        if (establishingConnection == NO) {
            GNSExtrasTapjoy *extras = [self.connector networkExtras];
            [Tapjoy limitedConnect:extras.sdk_key];
            establishingConnection = YES;
        }
        return;
    }
    //Return the result when already loaded
    if (_isConfigured && [self isReadyForDisplay]) {
        self.requestingAd = NO;
        [self.connector adapterDidReceiveAd:self];
        return;
    }
    // set Timer
    [self setTimerWith:timeout];
    
    //Start request Ad
    self.reward = nil;
    GNSExtrasTapjoy *extras = [self.connector networkExtras];
    [self ALLog:[NSString stringWithFormat:@"PlacementId=%@", extras.placement_id]];
    [self ALLog:[NSString stringWithFormat:@"SDKKey=%@", extras.sdk_key]];
    
    self.p = [TJPlacement limitedPlacementWithName:extras.placement_id mediationAgent:@"geniee" delegate:self];
    if (self.p != nil) {
        self.p.adapterVersion = [GNSAdapterTapjoyRewardVideoAd adapterVersion];
        self.p.videoDelegate = self;
        [self.p requestContent];
        _isConfigured = YES;
    } else {
        [self onErrorWithMessage:@"Can not create Tapjoy placement"];
    }
    
}

- (void)presentAdWithRootViewController:(UIViewController *)viewController {
    if(self.p != nil && self.p.isContentReady) {
        [self.p showContentWithViewController: viewController];
    }
}

- (void)stopBeingDelegate {
    self.connector = nil;
}

- (BOOL)isReadyForDisplay
{
    return (self.p != nil && self.p.isContentReady);
}

- (void)onErrorWithMessage:(NSString*) message
{
    [self deleteTimer];
    [self ALLog: message];
    NSDictionary *errorInfo = @{ NSLocalizedDescriptionKey : message };
    NSError *error = [NSError errorWithDomain: kGNSAdapterTapjoyRewardVideoAdKeyErrorDomain
                                         code: 1
                                     userInfo: errorInfo];
    [self.connector adapter: self didFailToLoadAdwithError: error];
}

#pragma mark - Tapjoy connection notification

-(void)tjcConnectSuccess:(NSNotification*)notifyObj
{
    [self ALLog:@"tjcConnectSuccess"];
    establishingConnection = NO;
    if (self.requestingAd) {
        [self deleteTimer];
        [self requestAd:_timeout];
    }
}

-(void)tjcConnectFail:(NSNotification*)notifyObj
{
    [self ALLog:@"tjcConnectFail"];
    [self onErrorWithMessage:@"Tapjoy: Can not connect to Tapjoy"];
    establishingConnection = NO;
}

#pragma mark - content status
- (void)requestDidSucceed:(TJPlacement*)placement
{
    [self ALLog:@"requestDidSucceed"];
    self.requestingAd = NO;
}

- (void)requestDidFail:(TJPlacement*)placement error:(NSError*)error
{
    [self ALLog:@"requestDidFail"];
    self.requestingAd = NO;
    [self onErrorWithMessage:@"Tapjoy: Fail to request content"];
}

- (void)contentIsReady:(TJPlacement*)placement
{
    [self ALLog:@"contentIsReady"];
    
    if (self.p != nil && self.p.isContentAvailable) {
        
        [self ALLog:@"There is some content for this placement"];
        [self.connector adapterDidReceiveAd:self];
    } else {
        
        [self ALLog:@"There is no content for this placement"];
        NSDictionary *errorInfo = @{ NSLocalizedDescriptionKey : @"There is no content for this placement" };
        NSError *error = [NSError errorWithDomain: kGNSAdapterTapjoyRewardVideoAdKeyErrorDomain
                                             code: 1
                                         userInfo: errorInfo];
        [self.connector adapter: self didFailToLoadAdwithError: error];
    }
    [self deleteTimer];
    
}

- (void)contentDidAppear:(TJPlacement*)placement
{
    [self ALLog:@"content is showing"];
}

- (void)contentDidDisappear:(TJPlacement*)placement
{
    [self ALLog:@"contentDidDisappear"];
    [self.connector adapterDidCloseAd:self];
}

#pragma mark - video progress
- (void)videoDidStart:(TJPlacement*)placement
{
    [self ALLog:@"videoDidStart"];
    [self.connector adapterDidStartPlayingRewardVideoAd:self];
}

- (void)videoDidComplete:(TJPlacement*)placement
{
    [self ALLog:@"videoDidComplete"];
    GNSExtrasTapjoy *extras = [self.connector networkExtras];
    self.reward = [[GNSAdReward alloc]
                   initWithRewardType: extras.type
                   rewardAmount: extras.amount];
    
    if (self.reward) {
        [self.connector adapter: self didRewardUserWithReward: self.reward];
        self.reward = nil;
    }
}

- (void)videoDidFail:(TJPlacement*)placement error:(NSString*)errorMsg
{
    [self ALLog:[NSString stringWithFormat:@"videoDidFail error = %@", errorMsg]];
}

@end
