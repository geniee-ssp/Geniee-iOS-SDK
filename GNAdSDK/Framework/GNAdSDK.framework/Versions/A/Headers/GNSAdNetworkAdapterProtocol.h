//
//  GADMRewardVideoAdNetworkAdapter.h
//  GNAdSDK
//


#import <UIKit/UIKit.h>
#import "GNSAdNetworkExtras.h"
#import "GNSAdNetworkExtraParams.h"

@protocol GNSAdNetworkConnector;

/// Your adapter must conform to this protocol to provide reward  video ads.
@protocol GNSAdNetworkAdapter<NSObject>

/// Returns a version string for the adapter.
+ (NSString *)adapterVersion;

/// The extras class that is used to specify additional parameters for a request to this ad network.
/// Returns Nil if the network does not have extra settings for publishers to send.
+ (Class<GNSAdNetworkExtras>)networkExtrasClass;

- (id<GNSAdNetworkExtras>)networkExtrasParameter:(GNSAdNetworkExtraParams *) parameter;

/// Returns an initialized instance of the adapter. The adapter must only maintain a weak reference
/// to the provided connector.
- (instancetype)initWithAdNetworkConnector:
        (id<GNSAdNetworkConnector>)connector;

/// Tells the adapter to set up reward  video ads. The adapter should notify the Geniee
/// Ads SDK whether set up has succeeded or failed using callbacks provided in the connector. When
/// set up fails, the Geniee Ads SDK may try to set up the adapter again.
- (void)setUp;

/// Tells the adapter to request a reward  video ad. This method is called after the adapter
/// has been set up. The adapter should notify the Geniee Ads SDK if the request succeeds or
/// fails using callbacks provided in the connector.
- (void)requestAd:(NSInteger)timeOut;

/// Tells the adapter to present the reward  video ad with the provided view controller. This
/// method is only called after the adapter successfully requested an ad.
- (void)presentAdWithRootViewController:(UIViewController *)viewController;

/// Tells the adapter to remove itself as a delegate or notification observer from the underlying ad
/// network SDK.
- (void)stopBeingDelegate;

- (BOOL)isReadyForDisplay;

@end
