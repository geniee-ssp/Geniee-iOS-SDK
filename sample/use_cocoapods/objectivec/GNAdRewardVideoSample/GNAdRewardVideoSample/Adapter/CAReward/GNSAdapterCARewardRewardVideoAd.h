//
//  GNSAdapterCARewardRewardVideoAd.h
//  GNSAdSDK
//

#import <Foundation/Foundation.h>

#import <GNAdSDK/GNSRewardVideoAdNetworkAdapterProtocol.h>
#import <GNAdSDK/GNSAdNetworkExtras.h>
#import <MediaSDK/MediaSDK.h>
#import <MediaSDK/MSGVAManager.h>

@interface GNSAdapterCARewardRewardVideoAd : NSObject<GNSRewardVideoAdNetworkAdapter, MSGVAVideoAdDelegate>

@property MSGVAManager *gvaAdManager;

@end

@interface GNSExtrasCAReward : NSObject<GNSAdNetworkExtras>

@property(nonatomic, copy) NSString *m_id;
@property(nonatomic, copy) NSString *sdk_token;
@property(nonatomic, copy) NSString *type;
@property(nonatomic, copy) NSDecimalNumber *amount;
@property(nonatomic, copy) NSString *placement;
@property(nonatomic, copy) NSString *media_user_id;

@end
