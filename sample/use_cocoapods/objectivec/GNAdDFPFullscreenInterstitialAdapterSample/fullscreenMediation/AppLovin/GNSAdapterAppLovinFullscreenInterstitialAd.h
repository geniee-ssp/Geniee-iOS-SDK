//
//  GNSAdapterApplovinFullscreenInterstitialAd.h
//  GNAdFullscreenInterstitialAdapter
//

#import <Foundation/Foundation.h>
#import <GNAdSDK/GNSAdNetworkConnectorProtocol.h>
#import <GNAdSDK/GNSAdNetworkExtras.h>

@interface GNSAdapterAppLovinFullscreenInterstitialAd : NSObject<GNSAdNetworkAdapter>

@end

@interface GNSExtrasFullscreenApplovin : NSObject<GNSAdNetworkExtras>
@property(nonatomic, copy) NSString *zone_id;
@end

