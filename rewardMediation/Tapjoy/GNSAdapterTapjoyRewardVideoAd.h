//
//  GNSAdapterTapjoyRewardVideoAd.h
//  GNAdSDK
//

#import <Foundation/Foundation.h>

#import <GNAdSDK/GNSAdNetworkAdapterProtocol.h>
#import <GNAdSDK/GNSAdNetworkExtras.h>
#import <Tapjoy/TJPlacement.h>

@interface GNSAdapterTapjoyRewardVideoAd : NSObject<GNSAdNetworkAdapter>

@property (nonatomic, assign) BOOL isConfigured;

- (void)onErrorWithMessage:(NSString*) message;

@end

@interface GNSExtrasTapjoy : NSObject<GNSAdNetworkExtras>

@property(nonatomic, copy) NSString *sdk_key;
@property(nonatomic, copy) NSString *placement_id;
@property(nonatomic, copy) NSString *type;
@property(nonatomic, copy) NSDecimalNumber *amount;

@end

