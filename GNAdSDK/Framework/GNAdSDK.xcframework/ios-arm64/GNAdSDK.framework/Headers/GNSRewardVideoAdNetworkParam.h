//
//  GNSRewardVideoAdNetworkParam.h
//  GNAdSDK
//

#import <Foundation/Foundation.h>
#import "GNSAdNetworkParam.h"

@interface GNSRewardVideoAdNetworkParam : GNSAdNetworkParam

@property(nonatomic, copy) NSString *type;
@property(nonatomic, copy) NSDecimalNumber *amount;

- (id)initWithZone:(NSInteger)zoneID content:(NSDictionary *)rewardContent;

@end
