//
//  GNSRewardVideoAdDelegate.h
//  GNAdSDK
//

#import <Foundation/Foundation.h>

#import "GNSAdReward.h"
#import "GNSRewardVideoAd.h"

/// Delegate for receiving state change messages from a GNSRewardVideoAd.
@protocol GNSRewardVideoAdDelegate<NSObject>

@optional

/// Tells the delegate that a reward video ad was received.
- (void)rewardVideoAdDidReceiveAd:(GNSRewardVideoAd *)rewardVideoAd;

/// Tells the delegate that the reward video ad failed to load.
- (void)rewardVideoAd:(GNSRewardVideoAd *)rewardVideoAd
    didFailToLoadWithError:(NSError *)error;

/// Tells the delegate that the reward video ad started playing.
- (void)rewardVideoAdDidStartPlaying:(GNSRewardVideoAd *)rewardVideoAd;

/// Tells the delegate that the reward video ad closed.
- (void)rewardVideoAdDidClose:(GNSRewardVideoAd *)rewardVideoAd;

/// Tells the delegate that the reward video ad has rewarded the user.
- (void)rewardVideoAd:(GNSRewardVideoAd *)rewardVideoAd
    didRewardUserWithReward:(GNSAdReward *)reward;

@end
