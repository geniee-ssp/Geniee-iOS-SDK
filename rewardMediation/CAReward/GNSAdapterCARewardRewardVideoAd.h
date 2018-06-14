//
//  GNSAdapterCARewardRewardVideoAd.h
//  GNSAdSDK
//

#import <Foundation/Foundation.h>

#import <GNAdSDK/GNSRewardVideoAdNetworkAdapterProtocol.h>
#import <GNAdSDK/GNSAdNetworkExtras.h>

@interface GNSAdapterCARewardRewardVideoAd : NSObject<GNSRewardVideoAdNetworkAdapter>

@property (nonatomic, assign) BOOL isConfigured;
@property (nonatomic, assign) BOOL ad_available;

@end

@interface GNSExtrasCAReward : NSObject<GNSAdNetworkExtras>

@property(nonatomic, copy) NSString *m_id;
@property(nonatomic, copy) NSString *sdk_token;
@property(nonatomic, copy) NSString *type;
@property(nonatomic, copy) NSDecimalNumber *amount;

@property(nonatomic, copy) NSString *placement;
@property(nonatomic, copy) NSString *orientation;
@property(nonatomic, assign) BOOL testMode;

@end
