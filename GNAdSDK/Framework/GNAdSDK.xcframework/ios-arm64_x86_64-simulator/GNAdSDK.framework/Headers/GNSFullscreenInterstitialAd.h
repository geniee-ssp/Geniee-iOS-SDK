//
//  GNSFullscreenInterstitialAd.h
//  GNAdSDK
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GNSRequest.h"
#import "GNSdkMediation.h"

@protocol GNSFullscreenInterstitialAdDelegate;

@interface GNSFullscreenInterstitialAd : GNSdkMediation

@property(nonatomic, weak) id<GNSFullscreenInterstitialAdDelegate> delegate;

+ (GNSFullscreenInterstitialAd *)sharedInstance;

/// unavailable method.
- (instancetype) init __attribute__((unavailable("init not available. use sharedInstance")));

// Initiates the request to fetch the fullscreen interstitial ad.
- (void)loadRequest:(GNSRequest *)request withZoneID:(NSString *)zoneID;

// Indicates if the ad is ready to show.
- (BOOL)canShow;

// Presents the fullscreen interstitial ad with the provided view controller.
- (void)show:(UIViewController *)viewController;

@end
