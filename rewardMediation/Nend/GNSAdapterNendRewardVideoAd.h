//
//  GNSAdapterNendRewardVideoAd.h
//  GNAdSDK
//


#import <Foundation/Foundation.h>
#import <GNAdSDK/GNSAdNetworkConnectorProtocol.h>
#import <GNAdSDK/GNSAdNetworkExtras.h>

@interface GNSAdapterNendRewardVideoAd : NSObject<GNSAdNetworkAdapter>

- (void)onErrorWithMessage:(NSString*) message;

@end

@interface GNSExtrasNend: NSObject<GNSAdNetworkExtras>

@property(nonatomic, copy) NSString *spotId;
@property(nonatomic, copy) NSString *apiKey;
@property(nonatomic, copy) NSString *type;
@property(nonatomic, copy) NSDecimalNumber *amount;

@end
