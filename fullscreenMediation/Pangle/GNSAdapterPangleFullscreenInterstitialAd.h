//
//  GNSAdapterPangleFullscreenInterstitialAd.h
//  GNAdFullscreenInterstitialSample
//

#import <Foundation/Foundation.h>
#import <GNAdSDK/GNSAdNetworkConnectorProtocol.h>
#import <GNAdSDK/GNSAdNetworkExtras.h>

@interface GNSAdapterPangleFullscreenInterstitialAd : NSObject<GNSAdNetworkAdapter>

@end

@interface GNSExtrasFullscreenPangle : NSObject<GNSAdNetworkExtras>
@property(nonatomic, copy) NSString *pangleAppId;
@property(nonatomic, copy) NSString *pangleAdUnitId;
@end
