//
//  GNSAdapterNendRewardVideoAd.h
//  GNAdSDK
//


#import <Foundation/Foundation.h>
#import <GNAdSDK/GNSRewardVideoAdNetworkConnectorProtocol.h>
#import <GNAdSDK/GNSAdNetworkExtras.h>

@interface GNSAdapterNendRewardVideoAd : NSObject<GNSRewardVideoAdNetworkAdapter>

- (void)onErrorWithMessage:(NSString*) message;

@end

@interface GNSExtrasNend: NSObject<GNSAdNetworkExtras>

@property(nonatomic, copy) NSString *spotId;
@property(nonatomic, copy) NSString *apiKey;
@property(nonatomic, copy) NSString *type;
@property(nonatomic, copy) NSDecimalNumber *amount;

@end
