//
//  GNAdDFPRewardMediationAdapter.h
//  GNAdDFPRewardMediationAdapter
//
//  Created by Long Uni on 2018/06/06.
//  Copyright © 2018年 Yamamoto Kazunori. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "GNAdSDK/GNSRewardVideoAd.h"
#import "GNAdSDK/GNSRequest.h"
#import "GNAdSDK/GNSAdReward.h"
#import "GNAdSDK/GNSRewardVideoAdDelegate.h"

@interface GNAdDFPRewardMediationAdapter : NSObject <GADMRewardBasedVideoAdNetworkAdapter, GNSRewardVideoAdDelegate>

@property(nonatomic, weak) id<GADMRewardBasedVideoAdNetworkConnector> connector;
@property(nonatomic, weak) NSString *appId;
@property(nonatomic, weak) NSString *sLogLevel;

@end
