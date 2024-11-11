//
//  GNSAdapterVungleFullscreenInterstitialAd.h
//  GNAdSDK
//

#import <Foundation/Foundation.h>

#import <GNAdSDK/GNSAdNetworkAdapterProtocol.h>
#import <GNAdSDK/GNSAdNetworkExtras.h>

@interface GNSAdapterGoogleAdxFullscreenInterstitialAd : NSObject<GNSAdNetworkAdapter>

- (void)onErrorWithMessage:(NSString*) message;

@end

@interface GNSExtrasFullscreenGoogleAdx : NSObject<GNSAdNetworkExtras>

@property(nonatomic, copy) NSString *adUnitId;

@end

