//
//  GNAdDFPBannerMediationAdapter.h
//  GNAdDFPBannerMediationAdapter
//
//  Created by Geniee on 2018/07/24.
//  Copyright © 2018年 Geniee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "GoogleMobileAds/GADCustomEventBanner.h"
#import "GoogleMobileAds/GADCustomEventBannerDelegate.h"
#import "GNAdSDK/GNAdView.h"
#import "GNAdSDK/Log4GNAd.h"


//! Project version number for GNAdDFPBannerMediationAdapter.
FOUNDATION_EXPORT double GNAdDFPBannerMediationAdapterVersionNumber;

//! Project version string for GNAdDFPBannerMediationAdapter.
FOUNDATION_EXPORT const unsigned char GNAdDFPBannerMediationAdapterVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <GNAdDFPBannerMediationAdapter/PublicHeader.h>
@interface GNAdDFPBannerMediationAdapter : NSObject <GNAdViewDelegate, GADCustomEventBanner>
{
    GNAdView* mAdView;
}

@property (nonatomic, assign) id<GADCustomEventBannerDelegate> delegate;


/// デバッグログの出力レベルを設定します。
@property(nonatomic) GNLogPriority GNAdlogPriority;

@end
