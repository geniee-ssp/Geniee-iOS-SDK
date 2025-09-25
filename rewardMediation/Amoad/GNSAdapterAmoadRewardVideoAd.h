//
//  GNSAdapterAmoadRewardVideoAd.h
//  GNAdRewardVideoSample
//

#import <Foundation/Foundation.h>
#import <GNAdSDK/GNSAdNetworkConnectorProtocol.h>
#import <GNAdSDK/GNSAdNetworkExtras.h>

@interface GNSAdapterAmoadRewardVideoAd : NSObject<GNSAdNetworkAdapter>

- (void)onErrorWithMessage:(NSString *)message;

@end

@interface GNSExtrasAmoad: NSObject<GNSAdNetworkExtras>

@property(nonatomic, copy) NSString *sId;
@property(nonatomic, copy) NSString *type;
@property(nonatomic, copy) NSDecimalNumber *amount;

@end

