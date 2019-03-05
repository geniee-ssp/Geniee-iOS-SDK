//
//  GNSAdapterImobileFullscreenInterstitialAd.h
//  GNAdFullscreenInterstitialAdapter
//

#import <Foundation/Foundation.h>
#import <GNAdSDK/GNSAdNetworkConnectorProtocol.h>
#import <GNAdSDK/GNSAdNetworkExtras.h>

@interface GNSAdapterImobileFullscreenInterstitialAd : NSObject<GNSAdNetworkAdapter>

@end

@interface GNSExtrasImobile : NSObject<GNSAdNetworkExtras>
@property(nonatomic,copy) NSString *publisherId;
@property(nonatomic,copy) NSString *mediaId;
@property(nonatomic,copy) NSString *spotId;
@end
