//
//  GNSAdapterVungleFullscreenInterstitialAd.h
//  GNAdSDK
//

#import <Foundation/Foundation.h>

#import <GNAdSDK/GNSAdNetworkAdapterProtocol.h>
#import <GNAdSDK/GNSAdNetworkExtras.h>

@interface GNSAdapterVungleFullscreenInterstitialAd : NSObject<GNSAdNetworkAdapter>

- (void)onErrorWithMessage:(NSString*) message;

@end

@interface GNSExtrasVungle : NSObject<GNSAdNetworkExtras>

@property(nonatomic, copy) NSString *app_id;
@property(nonatomic, copy) NSString *placementReferenceId;

@end

