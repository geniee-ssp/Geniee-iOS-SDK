//
//  GNSRewardVideoAdNetworkConnector.h
//

#import "GNSMediationAdRequest.h"
#import "GNSAdReward.h"
#import "GNSRewardVideoAdNetworkAdapterProtocol.h"

/// Reward video ad network adapters interact with the mediation SDK using an object that
/// conforms to the GNSRewardVideoAdNetworkConnector protocol.
@protocol GNSRewardVideoAdNetworkConnector<GNSMediationAdRequest>

/// Tells the delegate that the adapter successfully set up a reward video ad.
- (void)adapterDidSetUpRewardVideoAd:
        (id<GNSRewardVideoAdNetworkAdapter>)rewardVideoAdAdapter;

/// Tells the delegate that the adapter failed to set up a reward video ad.
- (void)adapter:(id<GNSRewardVideoAdNetworkAdapter>)rewardVideoAdAdapter
    didFailToSetUpRewardVideoAdWithError:(NSError *)error;

/// Tells the delegate that a reward video ad has loaded.
- (void)adapterDidReceiveRewardVideoAd:
        (id<GNSRewardVideoAdNetworkAdapter>)rewardVideoAdAdapter;

/// Tells the delegate that a reward  video ad failed to load.
- (void)adapter:(id<GNSRewardVideoAdNetworkAdapter>)rewardVideoAdAdapter
    didFailToLoadRewardVideoAdwithError:(NSError *)error;

/// Tells the delegate that a reward video ad has started playing.
- (void)adapterDidStartPlayingRewardVideoAd:
        (id<GNSRewardVideoAdNetworkAdapter>)rewardVideoAdAdapter;

/// Tells the delegate that a reward video ad has closed.
- (void)adapterDidCloseRewardVideoAd:
        (id<GNSRewardVideoAdNetworkAdapter>)rewardVideoAdAdapter;

/// Tells the delegate that the adapter has rewarded the user.
- (void)adapter:(id<GNSRewardVideoAdNetworkAdapter>)rewardVideoAdAdapter
    didRewardUserWithReward:(GNSAdReward *)reward;

@end
