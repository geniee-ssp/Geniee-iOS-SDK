//
//  GNSAdapterAmoadRewardVideoAd.m
//  GNAdRewardVideoSample
//


#import "GNSAdapterAmoadRewardVideoAd.h"

#import "AMoAd.h"
#import "AMoAdInterstitialVideo.h"
#import <GNAdSDK/GNSAdReward.h>

static NSString *const kGNSAdapterAmoadRewardVideoAdKeyErrorDomain = @"jp.co.genee.GNSAdapterAmoadRewardVideoAd";
static BOOL loggingEnabled = YES;

@interface GNSAdapterAmoadRewardVideoAd() <UIApplicationDelegate, AMoAdInterstitialVideoDelegate>
@property(nonatomic, strong) GNSAdReward *reward;
@property(nonatomic, weak) AMoAdInterstitialVideo *adsource;
@property(nonatomic, assign) BOOL requestingAd;
@property(nonatomic, weak) id<GNSAdNetworkConnector> connector;
@property(nonatomic, retain) NSTimer *timer;
@property(nonatomic, assign) NSInteger timeout;
@end

@implementation GNSExtrasAmoad
@end

@implementation GNSAdapterAmoadRewardVideoAd

- (void)ALLLog:(NSString *)logMessaeg {
    if (loggingEnabled) {
        NSLog(@"[INFO]GNSAmoadAdapter: %@", logMessaeg);
    }
}

#pragma mark - implement GNSAdNetworkConnector

+ (NSString *)adapterVersion {
    return @"3.0.3";
}

+ (Class<GNSAdNetworkExtras>)networkExtrasClass {
    return [GNSExtrasAmoad class];
}

- (id<GNSAdNetworkExtras>)networkExtrasParameter:(GNSAdNetworkExtraParams *)parameter {
    GNSExtrasAmoad *extra = [[GNSExtrasAmoad alloc] init];
    extra.sId = parameter.external_link_id;
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
    
    [self ALLLog:[NSString stringWithFormat:@"setUp AMoAd version: %ld", (long)[AMoAdInterstitialVideo version]]];
    [self.connector adapterDidSetupAd:self];
}

- (void)requestAd:(NSInteger)timeout {
    
    if ([self isReadyForDisplay]) {
        [self.connector adapterDidReceiveAd:self];
        return;
    }
    [self setTimerWith:timeout];
    
    self.reward = nil;
    GNSExtrasAmoad *extras = [self.connector networkExtras];
    [self ALLLog:[NSString stringWithFormat:@"Amoad request sId=%@", extras.sId]];
    dispatch_async(dispatch_get_main_queue(), ^{
        _adsource = [AMoAdInterstitialVideo sharedInstanceWithSid:extras.sId tag:@"genieeReward"];
        [_adsource setDelegate:self];
        [_adsource load];
    });
}

- (void)presentAdWithRootViewController:(UIViewController *)viewController {
    if (self.adsource.loaded) {
        self.adsource.cancellable = NO;
        [self.adsource show];
    }
}

- (void)stopBeingDelegate {
    self.connector = nil;
}

- (BOOL)isReadyForDisplay {
    
    [self ALLLog:[NSString stringWithFormat:@"canShow isReady=%hhd", self.adsource.loaded]];
    
    return self.adsource.loaded;
}

- (void)onErrorWithMessage:(NSString *)message {
    [self deleteTimer];
    [self ALLLog:message];
    NSDictionary *errorInfo = @{ NSLocalizedDescriptionKey : message};
    NSError *error = [NSError errorWithDomain:kGNSAdapterAmoadRewardVideoAdKeyErrorDomain
                                         code:1
                                     userInfo:errorInfo];
    [self.connector adapter:self didFailToLoadAdwithError:error];
    
}

#pragma mark - to connector

- (void)setTimerWith:(NSInteger)timeout {
    dispatch_async(dispatch_get_main_queue(), ^{
        _timer = [NSTimer scheduledTimerWithTimeInterval:timeout
                                                  target:self
                                                selector:@selector(sendDidFailToLoadRewardVideoWithTimeOut)
                                                userInfo:nil
                                                 repeats:NO];
    });
}

- (void)deleteTimer {
    if (_timer != nil) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)sendDidFailToLoadRewardVideoWithTimeOut {
    [self deleteTimer];
    
    [self ALLLog:@"Amoad: Rewarded video loading Timeout."];
    NSDictionary *errorInfo = @{ NSLocalizedDescriptionKey : @"Amoad: Rewarded video loading Timeout."};
    NSError *error = [NSError errorWithDomain:kGNSAdapterAmoadRewardVideoAdKeyErrorDomain
                      
                                         code:1
                                     userInfo:errorInfo];
    [self.connector adapter:self didFailToLoadAdwithError:error];
}

#pragma mark - AmoadDelegate

- (void)amoadInterstitialVideo:(AMoAdInterstitialVideo *)amoadInterstitialVideo didLoadAd:(AMoAdResult)result
{
    [self ALLLog:[NSString stringWithFormat:@"didLoadAd: adResult = %ld", (long)result]];
    [self deleteTimer];
    if (result == AMoAdResultSuccess) {
        [self.connector adapterDidReceiveAd:self];
    } else if (result == AMoAdResultFailure ){
        [self onErrorWithMessage:@"Amoad load Result is Failure"];
    } else {
        [self onErrorWithMessage:@"Amoad load Result is Empty"];
    }
}

- (void)amoadInterstitialVideoDidStart:(AMoAdInterstitialVideo *)amoadInterstitialVideo
{
    [self ALLLog:[NSString stringWithFormat:@"amoadInterstitialVideoDidStart"]];
    [self.connector adapterDidStartPlayingRewardVideoAd:self];
}

- (void)amoadInterstitialVideoWillDismiss:(AMoAdInterstitialVideo *)amoadInterstitialVideo
{
    [self ALLLog:@"amoadInterstitialVideoWillDismiss"];
    [self.connector adapterDidCloseAd:self];
}

- (void)amoadInterstitialVideoDidComplete:(AMoAdInterstitialVideo *)amoadInterstitialVideo
{
    [self ALLLog:@"amoadInterstitialVideoDidComplete"];
    GNSExtrasAmoad *extras = [self.connector networkExtras];
    self.reward = [[GNSAdReward alloc] initWithRewardType:extras.type
                                             rewardAmount:extras.amount];
    if (self.reward) {
        [self.connector adapter:self didRewardUserWithReward:self.reward];
        self.reward = nil;
    }
}
@end
