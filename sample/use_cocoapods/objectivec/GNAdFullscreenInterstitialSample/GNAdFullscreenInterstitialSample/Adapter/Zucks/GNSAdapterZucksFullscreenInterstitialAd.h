//
//  GNSAdapterZucksFullscreenInterstitialAd.h
//  GNAdFullscreenInterstitialAdapter
//

#import <Foundation/Foundation.h>
#import <GNAdSDK/GNSAdNetworkConnectorProtocol.h>
#import <GNAdSDK/GNSAdNetworkExtras.h>

@interface GNSAdapterZucksFullscreenInterstitialAd : NSObject<GNSAdNetworkAdapter>

@end

@interface GNSExtrasZucks : NSObject<GNSAdNetworkExtras>
@property(nonatomic,copy) NSString *frameId;
@end
