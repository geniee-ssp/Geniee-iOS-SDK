//
//  GNSAdapterNendRewardVideoAd.m
//  GNAdSDK
//


#import "GNSAdapterNendRewardVideoAd.h"
#import <NendAd/NendAd.h>

static NSString *const kGNSAdapterNendRewardVideoAdKeyErrorDomain = @"jp.co.geniee.GNSAdapterNendRewardVideoAd";
static BOOL loggingEnabled = YES;

@interface GNSAdapterNendRewardVideoAd() <UIApplicationDelegate, NADRewardedVideoDelegate>

@property(nonatomic, strong) GNSAdReward *reward;
@property(nonatomic) NADRewardedVideo *rewardedVideo;
@property(nonatomic, assign) BOOL requestingAd;
@property(nonatomic, weak) id<GNSRewardVideoAdNetworkConnector> connector;
@property(nonatomic, retain) NSTimer *timer;
@property(nonatomic, assign) NSInteger timeout;


@end

@implementation GNSExtrasNend
@end

@implementation GNSAdapterNendRewardVideoAd

- (void)AllLog:(NSString *)logMessage {
    if(loggingEnabled) {
        NSLog(@"[INFO]GNSNendAdapter: %@", logMessage);
    }
}

#pragma mark - implement GNSRewardVideoAdNetworkConnector

+ (NSString *)adapterVersion {
    return @"2.4.4";
}

+ (Class<GNSAdNetworkExtras>)networkExtrasClass {
    return [GNSExtrasNend class];
}

- (id<GNSAdNetworkExtras>)networkExtrasParameter:(GNSAdNetworkExtraParams *)parameter {
    GNSExtrasNend *extra = [[GNSExtrasNend alloc] init];
    extra.spotId = parameter.external_link_id;
    extra.apiKey = parameter.external_link_media_id;
    extra.type = parameter.type;
    extra.amount = parameter.amount;
    return extra;
}

- (instancetype)initWithRewardVideoAdNetworkConnector:(id<GNSRewardVideoAdNetworkConnector>)connector {
    self = [super init];
    if (self) {
        self.connector = connector;
    }
    return self;
}

- (void)setUp {
    [self AllLog:@"setup"];
    [self.connector adapterDidSetUpRewardVideoAd:self];
}

- (void)requestRewardVideoAd:(NSInteger)timeout {
    
    if ([self isReadyForDisplay]) {
        [self.connector adapterDidReceiveRewardVideoAd:self];
        return;
    }
    [self setTimerWith:timeout];
    
    self.reward = nil;
    GNSExtrasNend *extras = [self.connector networkExtras];
    [self AllLog:[NSString stringWithFormat:@"SportId = %@",extras.spotId]];
    [self AllLog:[NSString stringWithFormat:@"ApiKey = %@",extras.apiKey]];
    self.rewardedVideo = [[NADRewardedVideo alloc] initWithSpotId:extras.spotId apiKey:extras.apiKey];
    self.rewardedVideo.mediationName = @"geniee";
    self.rewardedVideo.delegate = self;
    self.rewardedVideo.isOutputLog = YES;
    [self.rewardedVideo loadAd];
}

- (void)presentRewardVideoAdWithRootViewController:(UIViewController *)viewController {
    if (self.rewardedVideo.isReady) {
        [self.rewardedVideo showAdFromViewController:viewController];
    }
}

- (void)stopBeingDelegate {
    self.connector = nil;
}

- (BOOL)isReadyForDisplay {
    return [self.rewardedVideo isReady];
}

- (void)onErrorWithMessage:(NSString*) message
{
    [self deleteTimer];
    [self AllLog: message];
    NSDictionary *errorInfo = @{ NSLocalizedDescriptionKey : message };
    NSError *error = [NSError errorWithDomain: kGNSAdapterNendRewardVideoAdKeyErrorDomain
                                         code: 1
                                     userInfo: errorInfo];
    [self.connector adapter: self didFailToLoadRewardVideoAdwithError: error];
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
    
    [self AllLog:@"Rewarded video loading Timeout."];
    NSDictionary *errorInfo = @{ NSLocalizedDescriptionKey : @"Rewarded video loading Timeout."};
    NSError *error = [NSError errorWithDomain:kGNSAdapterNendRewardVideoAdKeyErrorDomain
                                         code:1
                                     userInfo:errorInfo];
    [self.connector adapter:self didFailToLoadRewardVideoAdwithError:error];
}

#pragma mark - NendDelegate

- (void)nadRewardVideoAdDidReceiveAd:(NADRewardedVideo *)nadRewardedVideoAd
{
    [self AllLog:@"nadRewardVideoAdDidReceiveAd"];
    [self deleteTimer];
    [self.connector adapterDidReceiveRewardVideoAd:self];
}

- (void)nadRewardVideoAd:(NADRewardedVideo *)nadRewardedVideoAd didFailToLoadWithError:(NSError *)error
{
    [self AllLog:[NSString stringWithFormat:@"didFailToLoadWithError error = %@", [error localizedDescription]]];
    [self deleteTimer];
    [self.connector adapter:self didFailToLoadRewardVideoAdwithError:error];
    
}

- (void)nadRewardVideoAdDidStartPlaying:(NADRewardedVideo *)nadRewardedVideoAd
{
    [self AllLog:@"nadRewardVideoAdDidStartPlaying"];
    [self.connector adapterDidStartPlayingRewardVideoAd:self];
}

- (void)nadRewardVideoAdDidStopPlaying:(NADRewardedVideo *)nadRewardedVideoAd
{
    [self AllLog:@"nadRewardVideoAdDidStopPlaying"];
    [self.connector adapterDidCloseRewardVideoAd:self];
}


- (void)nadRewardVideoAd:(NADRewardedVideo *)nadRewardedVideoAd didReward:(NADReward *)reward
{
    [self AllLog:[NSString stringWithFormat:@"Rewarded video playback ended: %@",reward]];
    GNSExtrasNend *extras = [self.connector networkExtras];
    self.reward = [[GNSAdReward alloc] initWithRewardType:extras.type
                                             rewardAmount:extras.amount];
    if (self.reward) {
        [self.connector adapter:self didRewardUserWithReward:self.reward];
        self.reward = nil;
    }
}

@end
