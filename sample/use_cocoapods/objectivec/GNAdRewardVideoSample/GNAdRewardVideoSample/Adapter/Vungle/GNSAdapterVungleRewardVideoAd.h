//
//  GNSAdapterVungleRewardVideoAd.h
//  GNAdSDK
//

#import <Foundation/Foundation.h>

#import <GNAdSDK/GNSRewardVideoAdNetworkAdapterProtocol.h>
#import <GNAdSDK/GNSAdNetworkExtras.h>

@interface GNSAdapterVungleRewardVideoAd : NSObject<GNSRewardVideoAdNetworkAdapter>

- (void)onErrorWithMessage:(NSString*) message;

@end

@interface GNSExtrasVungle : NSObject<GNSAdNetworkExtras>

@property(nonatomic, copy) NSString *app_id;
@property(nonatomic, copy) NSString *placementReferenceId;
@property(nonatomic, copy) NSString *type;
@property(nonatomic, copy) NSDecimalNumber *amount;

@end

