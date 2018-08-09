//
//  GNSAdapterAdColonyRewardVideoAd.h
//  GNAdSDK
//

#import <Foundation/Foundation.h>

#import <GNAdSDK/GNSRewardVideoAdNetworkAdapterProtocol.h>
#import <GNAdSDK/GNSAdNetworkExtras.h>

@interface GNSAdapterAdColonyRewardVideoAd : NSObject<GNSRewardVideoAdNetworkAdapter>

@property (nonatomic, assign) BOOL isConfigured;
@property (nonatomic, assign) BOOL ad_available;

@end

@interface GNSExtrasAdColony : NSObject<GNSAdNetworkExtras>

@property(nonatomic, copy) NSString *app_id;
@property(nonatomic, copy) NSString *zone_id;
@property(nonatomic, copy) NSString *type;
@property(nonatomic, copy) NSDecimalNumber *amount;

@end
