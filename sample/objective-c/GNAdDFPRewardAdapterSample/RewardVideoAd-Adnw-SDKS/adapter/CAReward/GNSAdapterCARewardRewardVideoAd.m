//
//  GNSAdapterCARewardRewardVideoAd.m
//  GNSAdSDK
//

#import "GNSAdapterCARewardRewardVideoAd.h"
#import <MediaSDK/MediaSDK.h>
#import <MediaSDK/MSPVA.h>
#import <GNAdSDK/GNSRewardVideoAdNetworkConnectorProtocol.h>
#import <GNAdSDK/GNSAdNetworkExtraParams.h>
#import <GNAdSDK/GNSAdReward.h>

static NSString *const kGNSAdapterCARewardRewardVideoAdKeyErrorDomain = @"jp.co.geniee.GNSAdapterCARewardRewardVideoAd";
static BOOL loggingEnabled = YES;

@interface GNSAdapterCARewardRewardVideoAd () <UIApplicationDelegate, MSPVAViewControllerDelegate>

@property(nonatomic, strong) GNSAdReward *reward;
@property(nonatomic, weak) id<GNSRewardVideoAdNetworkConnector> connector;
@property (nonatomic, retain) NSTimer *timer;

@end

@implementation GNSExtrasCAReward
@end

@implementation GNSAdapterCARewardRewardVideoAd

- (void)ALLog:(NSString *)logMessage {
    if (loggingEnabled) {
        NSLog(@"[INFO]GNSCARewardAdapter: %@", logMessage);
    }
}

+ (NSString *)adapterVersion {
    return @"2.4.4";
}

+ (Class<GNSAdNetworkExtras>)networkExtrasClass {
    return [GNSExtrasCAReward class];
}

- (id<GNSAdNetworkExtras>)networkExtrasParameter:(GNSAdNetworkExtraParams *) parameter
{
    GNSExtrasCAReward * extra = [[GNSExtrasCAReward alloc]init];
    extra.m_id = parameter.external_link_id;
    extra.sdk_token = parameter.external_link_media_id;
    extra.type = parameter.type;
    extra.amount = parameter.amount;

    extra.placement = @"placement_1";
    // Please set orientation to "portrait" or "landscape" with your app's orientation
    extra.orientation = @"portrait";
    //extra.testMode = parameter.testMode;
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
    [self ALLog:@"setUp"];
    [self.connector adapterDidSetUpRewardVideoAd:self];
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
    NSError *error = [NSError errorWithDomain: kGNSAdapterCARewardRewardVideoAdKeyErrorDomain
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
    GNSExtrasCAReward *extras = [self.connector networkExtras];
    [self ALLog:[NSString stringWithFormat:@"MediaId=%@", extras.m_id]];
    [self ALLog:[NSString stringWithFormat:@"SDKKey=%@", extras.sdk_token]];
    NSString *uid = [MSPVA createMediaUserId];
    [self ALLog:[NSString stringWithFormat:@"media_user_id=%@", uid]];

    if (extras.testMode) [MediaSDK setDebugOn];
    [MediaSDK setObject:extras.m_id forKey:@"m_id"];
    [MediaSDK setObject:uid forKey:@"media_user_id"];
    [MediaSDK setObject:extras.sdk_token forKey:@"sdk_token"];
    [MediaSDK setObject:extras.placement forKey:@"placement"];
    [MSPVA setDelegate:self];
    [MSPVA requestAd];
}

- (void)presentRewardVideoAdWithRootViewController:(UIViewController *)viewController {
    [MSPVA execute];
}

- (void)stopBeingDelegate {
    self.connector = nil;
}

- (BOOL)isReadyForDisplay
{
    return _ad_available;
}

- (void)pvaViewController:(MSPVAViewController *)viewController onPVAMessage:(NSString *)message {
    [self ALLog:[NSString stringWithFormat:@"onPVAMessage message = '%@'.", message]];
    NSDictionary* ret = [MSPVA getQueryDictionary:message];
    if([ret count] > 0) {
        [self deleteTimer];
        NSString* type = [ret objectForKey:@"type"];
        NSString* status = [ret objectForKey:@"status"];
        //NSString* placement = [ret objectForKey:@"placement"];
        //NSString* reward_id = [ret objectForKey:@"id"];
        //NSString* amaount = [ret objectForKey:@"amount"];
        //NSString* event = [ret objectForKey:@"event"];
        
        if([@"ad_available" isEqualToString:type]) {
            if([@"ok" isEqualToString:status]) {
                [self ALLog:@"Ad was available"];
                _ad_available = YES;
                /// Tells the delegate that a reward video ad was received.
                [self.connector adapterDidReceiveRewardVideoAd:self];
            } else {
                NSDictionary *errorInfo = @{ NSLocalizedDescriptionKey : @"No Ad was available" };
                NSError *error = [NSError errorWithDomain: kGNSAdapterCARewardRewardVideoAdKeyErrorDomain
                                                     code: 1
                                                 userInfo: errorInfo];
                _ad_available = NO;
                /// Tells the delegate that the reward video ad failed to load.
                [self.connector adapter: self didFailToLoadRewardVideoAdwithError: error];
            }
        } else if([@"video_start" isEqualToString:type]) {
            _ad_available = NO;
            /// Tells the delegate that the reward video ad started playing.
            [self.connector adapterDidStartPlayingRewardVideoAd:self];
        } else if([@"close" isEqualToString:type]) {
            _ad_available = NO;
            /// Tells the delegate that the reward video ad closed.
            [self.connector adapterDidCloseRewardVideoAd:self];
        } else if([@"incentive" isEqualToString:type]) {
            _ad_available = NO;
            GNSExtrasCAReward *extras = [self.connector networkExtras];
            self.reward = [[GNSAdReward alloc]
                           initWithRewardType: extras.type
                           rewardAmount: extras.amount];
            if (self.reward) {
                /// Tells the delegate that the reward video ad has rewarded the user.
                [self.connector adapter: self didRewardUserWithReward: self.reward];
                self.reward = nil;
            }
        }
    }
}


@end
