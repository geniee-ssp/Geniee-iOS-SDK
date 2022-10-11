//
//  GNSAdapterVungleFullscreenInterstitialAd.m
//  GNAdSDK
//

#import "GNSAdapterPangleBannerAd.h"
#import <GNAdSDK/GNAdCustomEventBanner.h>
#import <PAGAdSDK/PAGBannerAd.h>
#import <PAGAdSDK/PAGAdSDK.h>
#import <PAGAdSDK/PAGAdSize.h>

static NSString *const kGNSAdapterPangleBannerAdKeyErrorDomain = @"jp.co.geniee.GNSAdapterPangleBannerAd";

@interface GNSAdapterPangleBannerAd ()<GNAdCustomEventBanner, PAGBannerAdDelegate>

@property (nonatomic, strong) PAGBannerAd *bannerAd;
//@property (nonatomic, strong) BOOL isPangleSDKSetup;

@end

@implementation GNSAdapterPangleBannerAd

- (void)requestBannerAd:(NSString *)externalLinkId externalLinkMediaId:(NSString *)externalLinkMediaId adSize:(CGSize)adSize requestExtra:(NSDictionary *)customEventExtra {
    
    if (externalLinkId == nil ||
        externalLinkId.length == 0 ||
        externalLinkMediaId == nil ||
        externalLinkMediaId.length == 0) {
        
        NSDictionary *errorInfo = @{NSLocalizedDescriptionKey: @"Invalid Pangle App Id or Ad Unit Id"};
        NSError *error = [NSError errorWithDomain:kGNSAdapterPangleBannerAdKeyErrorDomain code:1 userInfo:errorInfo];
        
        [self.delegate customEventBanner:self didFailAd:error];
        return;
    }
    
    PAGConfig *config = [PAGConfig shareConfig];
    config.appID = externalLinkId;
    
    [PAGSdk startWithConfig:config completionHandler:^(BOOL success, NSError * _Nonnull error) {
        if (success) {
            [self loadBannerAd:externalLinkMediaId adSize:adSize];
        } else {
            [self.delegate customEventBanner:self didFailAd:error];
        }
    }];
    
    
}

- (void) loadBannerAd:(NSString *)adUnit adSize:(CGSize)adSize {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        struct PAGAdSize pAGAdSize;
        pAGAdSize.size = adSize;
        
        [PAGBannerAd loadAdWithSlotID:adUnit
                              request:[PAGBannerRequest requestWithBannerSize:pAGAdSize]
                    completionHandler:^(PAGBannerAd * _Nullable bannerAd, NSError * _Nullable error) {
            
            if (error) {
                [self.delegate customEventBanner:self didFailAd:error];
                return;
            }
            
            self.bannerAd = bannerAd;
            self.bannerAd.delegate = self;
            self->_bannerAd.bannerView.backgroundColor = [UIColor greenColor];
            
            [self.delegate customEventBanner:self didReceiveAd:self->_bannerAd.bannerView];
        }];
    });
    
}

- (void)adDidShow:(PAGBannerAd *)ad {
    [self.delegate customEventBannerWillPresentModal:self];
}

- (void)adDidClick:(PAGBannerAd *)ad {
    [self.delegate customEventBanner:self clickDidOccurInAd:self.bannerAd.bannerView];
}

- (void)adDidDismiss:(PAGBannerAd *)ad {
    [self.delegate customEventBannerDidDismissModal:self];
}

@synthesize delegate;

@end
