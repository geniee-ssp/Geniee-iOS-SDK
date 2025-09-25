//
//  GNSAdapterUnityAdsRewardVideoAd.h
//  GNAdSDK
//

#import <Foundation/Foundation.h>

#import <GNAdSDK/GNSAdNetworkAdapterProtocol.h>
#import <GNAdSDK/GNSAdNetworkExtras.h>

@interface GNSAdapterUnityAdsRewardVideoAd : NSObject<GNSAdNetworkAdapter>

@end

@interface GNSExtrasUnityAds : NSObject<GNSAdNetworkExtras>

@property(nonatomic, copy) NSString *game_id;
@property(nonatomic, copy) NSString *placement_id;
@property(nonatomic, copy) NSString *type;
@property(nonatomic, copy) NSDecimalNumber *amount;

@end
