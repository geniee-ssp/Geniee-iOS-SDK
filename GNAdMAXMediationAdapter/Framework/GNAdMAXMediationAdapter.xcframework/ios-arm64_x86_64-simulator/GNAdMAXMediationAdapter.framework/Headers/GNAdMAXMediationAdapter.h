//
//  GNAdGoogleBannerMediationAdapter.h
//  GNAdGoogleBannerMediationAdapter
//
//  Created by Geniee on 2018/07/24.
//  Copyright © 2018年 Geniee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "GNAdSDK/GNAdView.h"
#import "GNAdSDK/Log4GNAd.h"
#import <AppLovinSDK/AppLovinSDK.h>


@interface GNAdMAXMediationAdapter : ALMediationAdapter < MAAdapter, MAAdViewAdapter, MAInterstitialAdapter, MARewardedAdapter> {
    GNAdView *gnAdView;
}

@property (nonatomic, assign) id<MAAdViewAdapterDelegate> delegate;
@property (nonatomic, assign) id<MAInterstitialAdapterDelegate> maxInterstitialDelegate;
@property (nonatomic, assign) id<MARewardedAdapterDelegate> maxRewardDelegate;

@end
