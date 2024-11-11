//
//  GNSAdapterPangleRewardVideoAd.m
//  GNAdSDK
//

#import "GNSAdapterPangleRewardVideoAd.h"
#import <GNAdSDK/GNSAdNetworkConnectorProtocol.h>
#import <GNAdSDK/GNSAdNetworkExtraParams.h>
#import <GNAdSDK/GNSAdReward.h>
#import <PAGAdSDK/PAGAdSDK.h>

static NSString *const kGNSAdapterPangleRewardVideoAdKeyErrorDomain = @"jp.co.geniee.GNSAdapterPangleRewardVideoAd";
static BOOL loggingEnabled = YES;
static BOOL establishingConnection = NO;


@interface GNSAdapterPangleRewardVideoAd () <UIApplicationDelegate, PAGRewardedAdDelegate>

@property(nonatomic, strong) GNSAdReward *reward;
@property(nonatomic, assign) BOOL requestingAd;
@property(nonatomic, strong) PAGRewardedAd *pangleRewardAd;

@property(nonatomic, weak) id<GNSAdNetworkConnector> connector;
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, assign) NSInteger timeout;

@end

@implementation GNSExtrasPangle
@end

@implementation GNSAdapterPangleRewardVideoAd

- (void)ALLog:(NSString *)logMessage {
    if (loggingEnabled) {
        NSLog(@"[INFO]GNSTapjoyAdapter: %@", logMessage);
    }
}

+ (NSString *)adapterVersion {
    return @"3.2.1";
}

+ (Class<GNSAdNetworkExtras>)networkExtrasClass {
    return [GNSExtrasPangle class];
}

- (id<GNSAdNetworkExtras>)networkExtrasParameter:(GNSAdNetworkExtraParams *) parameter
{
    GNSExtrasPangle * extra = [[GNSExtrasPangle alloc]init];
    extra.pangleAppId = parameter.external_link_id;
    extra.pangleAdUnitId = parameter.external_link_media_id;
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
    
    GNSExtrasPangle *extras = [self.connector networkExtras];
    
    PAGConfig *config = [PAGConfig shareConfig];
    config.appID = extras.pangleAppId;
    [PAGSdk startWithConfig:config completionHandler:^(BOOL success, NSError * _Nonnull error) {
        if (error) {
            NSDictionary *errorInfo = @{NSLocalizedDescriptionKey: @"Could not initialize Pangle SDK."};
            NSError *newError = [NSError errorWithDomain:kGNSAdapterPangleRewardVideoAdKeyErrorDomain code:1 userInfo:errorInfo];
            [self.connector adapter:self didFailToLoadAdwithError:newError];
        }
    }];
    
    [self.connector adapterDidSetupAd:self];
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
    NSError *error = [NSError errorWithDomain: kGNSAdapterPangleRewardVideoAdKeyErrorDomain
                                         code: 1
                                     userInfo: errorInfo];
    [self.connector adapter: self didFailToLoadAdwithError: error];
}


- (void)requestAd:(NSInteger)timeout {
    
    if ([self isReadyForDisplay]) {
        
        [self.connector adapterDidReceiveAd:self];
        [self deleteTimer];
        return;
    }
    [self setTimerWith:timeout];
    
    GNSExtrasPangle *extras = [self.connector networkExtras];
    
    PAGRewardedRequest *request = [PAGRewardedRequest request];
    
    [PAGRewardedAd loadAdWithSlotID:extras.pangleAdUnitId request:request completionHandler:^(PAGRewardedAd * _Nullable rewardedAd, NSError * _Nullable error) {
        if (error) {
            [self onErrorWithMessage:error.description];
            return;
        }
        
        self.pangleRewardAd = rewardedAd;
        self.pangleRewardAd.delegate = self;
        
        [self deleteTimer];
        [self.connector adapterDidReceiveAd:self];
        
    }];
    
}

- (void)presentAdWithRootViewController:(UIViewController *)viewController {
    if (self.pangleRewardAd != nil) {
        [self.pangleRewardAd presentFromRootViewController:viewController];
    }
}

- (void)stopBeingDelegate {
    self.connector = nil;
    
    self.pangleRewardAd = nil;
}

- (BOOL)isReadyForDisplay {
    
    return self.pangleRewardAd != nil;
}

- (void)onErrorWithMessage:(NSString*) message {
    [self deleteTimer];
    [self ALLog: message];
    NSDictionary *errorInfo = @{ NSLocalizedDescriptionKey : message };
    NSError *error = [NSError errorWithDomain: kGNSAdapterPangleRewardVideoAdKeyErrorDomain
                                         code: 1
                                     userInfo: errorInfo];
    [self.connector adapter: self didFailToLoadAdwithError: error];
}

#pragma PAGRewardedAdDelegate

- (void)adDidShow:(PAGRewardedAd *)ad {
    [self.connector adapterDidStartPlayingRewardVideoAd:self];
}

- (void)adDidClick:(PAGRewardedAd *)ad {
}

- (void)adDidDismiss:(PAGRewardedAd *)ad {
    [self.connector adapterDidCloseAd:self];
    self.pangleRewardAd = nil;
    [self deleteTimer];
}

- (void)rewardedAd:(PAGRewardedAd *)rewardedAd userDidEarnReward:(PAGRewardModel *)rewardModel {
    
    GNSExtrasPangle *extras = [self.connector networkExtras];
    self.reward = [[GNSAdReward alloc]
                   initWithRewardType: extras.type
                   rewardAmount: extras.amount];
    
    if (self.reward) {
        [self.connector adapter: self didRewardUserWithReward: self.reward];
        self.reward = nil;
    }
    
}

- (void)rewardedAd:(PAGRewardedAd *)rewardedAd userEarnRewardFailWithError:(NSError *)error {
    NSLog(@"reward earned failed. Error:%@",error);
}

@end
