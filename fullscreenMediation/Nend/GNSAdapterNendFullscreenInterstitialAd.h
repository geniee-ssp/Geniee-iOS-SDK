//
//  GNSAdapterNendFullscreenInterstitialAd.h
//  GNAdFullscreenInterstitialAdapter
//

#import <Foundation/Foundation.h>
#import <GNAdSDK/GNSAdNetworkConnectorProtocol.h>
#import <GNAdSDK/GNSAdNetworkExtras.h>

@interface GNSAdapterNendFullscreenInterstitialAd : NSObject<GNSAdNetworkAdapter>


@end

@interface GNSExtrasNend : NSObject<GNSAdNetworkExtras>
@property(nonatomic,copy) NSString *spotId;
@property(nonatomic,copy) NSString *apiKey;
@end
