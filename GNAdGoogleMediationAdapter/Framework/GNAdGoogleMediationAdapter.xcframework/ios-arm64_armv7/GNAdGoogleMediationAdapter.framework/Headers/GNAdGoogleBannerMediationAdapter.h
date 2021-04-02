//
//  GNAdGoogleBannerMediationAdapter.h
//  GNAdGoogleBannerMediationAdapter
//
//  Created by Geniee on 2018/07/24.
//  Copyright © 2018年 Geniee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@import GoogleMobileAds;
#import "GNAdSDK/GNAdView.h"
#import "GNAdSDK/Log4GNAd.h"


//! Project version number for GNAdGoogleBannerMediationAdapter.
FOUNDATION_EXPORT double GNAdGoogleBannerMediationAdapterVersionNumber;

//! Project version string for GNAdGoogleBannerMediationAdapter.
FOUNDATION_EXPORT const unsigned char GNAdGoogleBannerMediationAdapterVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <GNAdGoogleBannerMediationAdapter/PublicHeader.h>
@interface GNAdGoogleBannerMediationAdapter : NSObject <GNAdViewDelegate, GADCustomEventBanner>
{
    GNAdView* mAdView;
}

@property (nonatomic, assign) id<GADCustomEventBannerDelegate> delegate;


/// デバッグログの出力レベルを設定します。
@property(nonatomic) GNLogPriority GNAdlogPriority;

@end
