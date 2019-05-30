//
//  GNAdGoogleRewardMediationAdapter.h
//  GNAdGoogleRewardMediationAdapter
//

#import <Foundation/Foundation.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "GNAdSDK/GNSRewardVideoAd.h"
#import "GNAdSDK/GNSRequest.h"
#import "GNAdSDK/GNSAdReward.h"
#import "GNAdSDK/GNSRewardVideoAdDelegate.h"

@interface GNAdGoogleRewardMediationAdapter : NSObject <GADMRewardBasedVideoAdNetworkAdapter, GNSRewardVideoAdDelegate>

@property(nonatomic, weak) id<GADMRewardBasedVideoAdNetworkConnector> connector;
@property(nonatomic, weak) NSString *appId;
@property(nonatomic, weak) NSString *sLogLevel;

@end
