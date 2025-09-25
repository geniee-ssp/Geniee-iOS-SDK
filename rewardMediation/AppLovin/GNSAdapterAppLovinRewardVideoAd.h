//
//  GNSAdapterAppLovinRewardVideoAd.h
//  GNAdSDK
//

#import <Foundation/Foundation.h>

#import <GNAdSDK/GNSAdNetworkAdapterProtocol.h>
#import <GNAdSDK/GNSAdNetworkExtras.h>

@interface GNSAdapterAppLovinRewardVideoAd : NSObject<GNSAdNetworkAdapter>

@end

@interface GNSExtrasAppLovin : NSObject<GNSAdNetworkExtras>

@property (nonatomic, copy) NSString *sdkKey;
@property (nonatomic, copy) NSString *zoneId;
@property(nonatomic, copy) NSString *type;
@property(nonatomic, copy) NSDecimalNumber *amount;

@end
