//
//  GNAdGoogleFullscreenInterstitialMediationAdapter.h
//  GNAdGoogleFullscreenInterstitialMediationAdapter
//

#import <Foundation/Foundation.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
#import <GNAdSDK/GNSFullscreenInterstitialAd.h>
#import <GNAdSDK/GNSFullscreenInterstitialAdDelegate.h>
#import <GNAdSDK/GNSRequest.h>
#import <GNAdSDK/Log4GNAd.h>

@interface GNAdGoogleFullscreenInterstitialMediationAdapter : NSObject<GADCustomEventInterstitial, GNSFullscreenInterstitialAdDelegate>
@property(nonatomic, assign) id<GADCustomEventInterstitialDelegate> delegate;
@property(nonatomic, weak) NSString *appId;
/// デバッグログの出力レベルを設定します。
@property(nonatomic) GNLogPriority GNAdlogPriority;

@end

