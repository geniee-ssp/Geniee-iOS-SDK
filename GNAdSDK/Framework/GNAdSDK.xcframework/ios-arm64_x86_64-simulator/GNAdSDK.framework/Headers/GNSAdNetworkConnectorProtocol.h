//
//  GNSAdNetworkConnector.h
//  GNAdSDK
//

#import "GNSMediationAdRequest.h"
#import "GNSAdReward.h"
#import "GNSAdNetworkAdapterProtocol.h"

/// Reward video ad network adapters interact with the mediation SDK using an object that
/// conforms to the GNSAdNetworkConnector protocol.
@protocol GNSAdNetworkConnector<GNSMediationAdRequest>

#pragma mark - Common
/// Tells the delegate that the adapter successfully set up a advertisement.
- (void)adapterDidSetupAd:
        (id<GNSAdNetworkAdapter>)adNetworkAdapter;

/// Tells the delegate that the adapter failed to set up a advertisement.
- (void)adapter:(id<GNSAdNetworkAdapter>)adNetworkAdapter
    didFailToSetupAdWithError:(NSError *)error;

/// Tells the delegate that a advertisement has loaded.
- (void)adapterDidReceiveAd:
        (id<GNSAdNetworkAdapter>)adNetworkAdapter;

/// Tells the delegate that a advertisement failed to load.
- (void)adapter:(id<GNSAdNetworkAdapter>)adNetworkAdapter
    didFailToLoadAdwithError:(NSError *)error;

/// Tells the delegate that a advertisement has closed.
- (void)adapterDidCloseAd:(id<GNSAdNetworkAdapter>)adNetworkAdapter;

// Tells the delegate that a advertisement has clicked.
- (void)adapterDidClickAd:(id<GNSAdNetworkAdapter>)adNetworkAdapter;

#pragma mark - Interstitial
- (void)adapterWillPresentScreenInterstitialAd:(id<GNSAdNetworkAdapter>)adNetworkAdapter;

#pragma mark - RewardVideo
/// Tells the delegate that a reward video ad has started playing.
- (void)adapterDidStartPlayingRewardVideoAd:
        (id<GNSAdNetworkAdapter>)adNetworkAdapter;

/// Tells the delegate that the adapter has rewarded the user.
- (void)adapter:(id<GNSAdNetworkAdapter>)adNetworkAdapter
    didRewardUserWithReward:(GNSAdReward *)reward;

@end
