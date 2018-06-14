//
//  GNSAdapterMaioRewardVideoAd.m
//  GNAdSDK
//

#import "GNSAdapterMaioRewardVideoAd.h"

#import <Maio/Maio.h>
#import <GNAdSDK/GNSRewardVideoAdNetworkConnectorProtocol.h>
#import <GNAdSDK/GNSAdNetworkExtraParams.h>
#import <GNAdSDK/GNSAdReward.h>

static NSString *const kGNSAdapterMaioRewardVideoAdKeyErrorDomain = @"jp.co.geniee.GNSAdapterMaioRewardVideoAd";
static BOOL loggingEnabled = YES;

@interface GNSAdapterMaioRewardVideoAd () <MaioDelegate>

@property(nonatomic, strong) GNSAdReward *reward;
@property(nonatomic, weak) id<GNSRewardVideoAdNetworkConnector> connector;
@property (nonatomic, retain) NSTimer *timer;

@end

@implementation GNSExtrasMaio
@end

@implementation GNSAdapterMaioRewardVideoAd

- (void)ALLog:(NSString *)logMessage {
    if (loggingEnabled) {
        NSLog(@"[INFO]GNSMaioAdapter: %@", logMessage);
    }
}

+ (NSString *)adapterVersion {
    return @"2.4.4";
}

+ (Class<GNSAdNetworkExtras>)networkExtrasClass {
    return [GNSExtrasMaio class];
}

- (id<GNSAdNetworkExtras>)networkExtrasParameter:(GNSAdNetworkExtraParams *) parameter
{
    GNSExtrasMaio * extra = [[GNSExtrasMaio alloc]init];
    extra.media_id = parameter.external_link_id;
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
    [self.connector adapterDidSetUpRewardVideoAd:self];
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
    NSError *error = [NSError errorWithDomain: kGNSAdapterMaioRewardVideoAdKeyErrorDomain
                                         code: 1
                                     userInfo: errorInfo];
    [self.connector adapter: self didFailToLoadRewardVideoAdwithError: error];
}


- (void)requestRewardVideoAd:(NSInteger)timeout {
    
    //Return the result when already loaded
    if ([self isReadyForDisplay]) {
        [self.connector adapterDidReceiveRewardVideoAd:self];
        return;
    }
    // set Timer
    [self setTimerWith:timeout];
    
    self.reward = nil;
    GNSExtrasMaio *extras = [self.connector networkExtras];
    [self ALLog:[NSString stringWithFormat:@"MediaId=%@", extras.media_id]];
    [Maio startWithMediaId:extras.media_id delegate:self];
}

- (void)presentRewardVideoAdWithRootViewController:(UIViewController *)viewController {
    [Maio showWithViewController:viewController];
}

- (void)stopBeingDelegate {
    self.connector = nil;
}

- (BOOL)isReadyForDisplay
{
    return [Maio canShow];
}

#pragma mark - MaioDelegate


// Maio have auto load by maioDidChangeCanShow
- (void)maioDidInitialize
{
    // Called when Ads first loaded
    [self.connector adapterDidReceiveRewardVideoAd:self];
}

- (void)maioDidFail:(NSString *)zoneId reason:(MaioFailReason)reason
{
    [self deleteTimer];
    NSDictionary *errorInfo = @{ NSLocalizedDescriptionKey : @"No ad to show." };
    NSError *error = [NSError errorWithDomain: kGNSAdapterMaioRewardVideoAdKeyErrorDomain
                                         code: reason
                                     userInfo: errorInfo];
    [self.connector adapter: self didFailToLoadRewardVideoAdwithError: error];
}

- (void)maioDidChangeCanShow:(NSString *)zoneId newValue:(BOOL)newValue
{
    // Called when Ads second loaded or later
    [self ALLog:[NSString stringWithFormat:@"load change: zoneId=%@, value=%ld", zoneId, (long)newValue]];
    // Received Ad
    if (newValue){
        [self deleteTimer];
        [self.connector adapterDidReceiveRewardVideoAd:self];
    }
}

#pragma mark - MaioDelegate
- (void)maioDidClickAd:(NSString *)zoneId
{

}

- (void)maioWillStartAd:(NSString *)zoneId
{
    [self.connector adapterDidStartPlayingRewardVideoAd:self];
}

- (void)maioDidCloseAd:(NSString *)zoneId
{
    [self.connector adapterDidCloseRewardVideoAd:self];
}

/** MARK: Plz translate
 *  It will be called when the ad play ends.
 *  It is called only at the end of the first playback and is not called at the end of replay playback.
 *
 *  @param zoneId Identifier of the zone displaying the advertisement
 *  @param playtime Video playback time (sec)
 *  @param skipped  skipped YES if the video was skipped, NO otherwise
 *  @param rewardParam When the zone is set to Reward type, arbitrary character string parameters set in the management screen are passed in advance. Otherwise nil
 */

- (void)maioDidFinishAd:(NSString *)zoneId playtime:(NSInteger)playtime skipped:(BOOL)skipped rewardParam:(NSString *)rewardParam
{

    [self ALLog:[NSString stringWithFormat:@"Rewarded video playback ended: zoneId=%@ playtime=%ld skipped=%ld param=%@",
                 zoneId,
                 (long)playtime,
                 (long)skipped,
                 rewardParam]];
    GNSExtrasMaio *extras = [self.connector networkExtras];
    self.reward = [[GNSAdReward alloc]
                   initWithRewardType: extras.type
                   rewardAmount: extras.amount];
    
    if (!skipped && self.reward) {
        [self.connector adapter: self didRewardUserWithReward: self.reward];
        self.reward = nil;
    }
}

@end
