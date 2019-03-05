//
//  GNSAdapterTapjoyFullscreenInterstitialAd.h
//  GNAdFullscreenInterstitialSample
//

#import <Foundation/Foundation.h>
#import <Tapjoy/Tapjoy.h>
#import <GNAdSDK/GNSAdNetworkConnectorProtocol.h>
#import <GNAdSDK/GNSAdNetworkExtras.h>

@interface GNSAdapterTapjoyFullscreenInterstitialAd : NSObject<GNSAdNetworkAdapter>

@end

@interface GNSExtrasFullscreenTapjoy : NSObject<GNSAdNetworkExtras>
@property(nonatomic, copy) NSString *tjSDKKey;
@property(nonatomic, copy) NSString *tjPlacementId;
@end
