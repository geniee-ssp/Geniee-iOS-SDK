//
//  GNSAdapterTikTokRewardVideoAd.h
//  GNAdSDK
//

#import <Foundation/Foundation.h>

#import <GNAdSDK/GNSAdNetworkAdapterProtocol.h>
#import <GNAdSDK/GNSAdNetworkExtras.h>

@interface GNSAdapterTikTokRewardVideoAd : NSObject<GNSAdNetworkAdapter>
@property (nonatomic, assign) BOOL isAdAvailable;
@end

@interface GNSExtrasTikTok : NSObject<GNSAdNetworkExtras>

@property(nonatomic, copy) NSString *appKey;
@property(nonatomic, copy) NSString *slotId;
@property(nonatomic, copy) NSString *type;
@property(nonatomic, copy) NSDecimalNumber *amount;

@end
