//
//  GNSAdReward.h
//  GNAdSDK
//

#import <Foundation/Foundation.h>


@interface GNSAdReward : NSObject

/// Type of the reward.
@property(nonatomic, readonly, copy) NSString *type;

/// Amount rewarded to the user.
@property(nonatomic, readonly, copy) NSDecimalNumber *amount;

/// Returns an initialized GNSAdReward with the provided reward type and reward amount.
- (instancetype)initWithRewardType:(NSString *)rewardType
                      rewardAmount:(NSDecimalNumber *)rewardAmount;

@end

