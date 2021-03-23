//
//  GNSFullscreenInterstitialAdDelegate.h
//  GNAdSDK
//

#import <Foundation/Foundation.h>
#import "GNSFullscreenInterstitialAd.h"

@protocol GNSFullscreenInterstitialAdDelegate <NSObject>

@optional

- (void)fullscreenInterstitialDidReceiveAd:(GNSFullscreenInterstitialAd *)fullscreenInterstitial;

- (void)fullscreenInterstitial:(GNSFullscreenInterstitialAd *)fullscreenInterstitial
                    didFailToLoadWithError:(NSError *)error;

- (void)fullscreenInterstitialAdDidClose:(GNSFullscreenInterstitialAd *)fullscreenInterstitial;

- (void)fullscreenInterstitialAdDidClick:(GNSFullscreenInterstitialAd *)fullscreenInterstitial;

- (void)fullscreenInterstitialWillPresentScreen:(GNSFullscreenInterstitialAd *)fullscreenInterstitial;

@end
