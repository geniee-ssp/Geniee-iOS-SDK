//
//  GNSAdapterAppLovinRewardVideoAd.h
//  GNAdSDK
//

#import <Foundation/Foundation.h>

#import <GNAdSDK/GNSRewardVideoAdNetworkAdapterProtocol.h>
#import <GNAdSDK/GNSAdNetworkExtras.h>

@interface GNSAdapterAppLovinRewardVideoAd : NSObject<GNSRewardVideoAdNetworkAdapter>

@end

@interface GNSExtrasAppLovin : NSObject<GNSAdNetworkExtras>

@property (nonatomic, copy) NSString *placement_id;
@property(nonatomic, copy) NSString *type;
@property(nonatomic, copy) NSDecimalNumber *amount;

@end
