//
//  GNSAdapterPangleRewardVideoAd.h
//  GNAdSDK
//

#import <Foundation/Foundation.h>

#import <GNAdSDK/GNSAdNetworkAdapterProtocol.h>
#import <GNAdSDK/GNSAdNetworkExtras.h>

@interface GNSAdapterPangleRewardVideoAd : NSObject<GNSAdNetworkAdapter>

@property (nonatomic, assign) BOOL isConfigured;

- (void)onErrorWithMessage:(NSString*) message;

@end

@interface GNSExtrasPangle : NSObject<GNSAdNetworkExtras>

@property(nonatomic, copy) NSString *pangleAppId;
@property(nonatomic, copy) NSString *pangleAdUnitId;
@property(nonatomic, copy) NSString *type;
@property(nonatomic, copy) NSDecimalNumber *amount;

@end

