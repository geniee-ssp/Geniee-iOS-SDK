//
//  GNSAdapterMaioRewardVideoAd.h
//  GNAdSDK
//

#import <Foundation/Foundation.h>

#import <GNAdSDK/GNSRewardVideoAdNetworkAdapterProtocol.h>
#import <GNAdSDK/GNSAdNetworkExtras.h>

@interface GNSAdapterMaioRewardVideoAd : NSObject<GNSRewardVideoAdNetworkAdapter>

@end

@interface GNSExtrasMaio : NSObject<GNSAdNetworkExtras>

@property(nonatomic, copy) NSString *media_id;
@property(nonatomic, copy) NSString *type;
@property(nonatomic, copy) NSDecimalNumber *amount;

@end
