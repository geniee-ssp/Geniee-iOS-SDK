//
//  ViewController.h
//  GNAdSampleMediationBanner
//

#import <UIKit/UIKit.h>
#import <GNAdSDK/GNAdView.h>

@interface ViewController : UIViewController<GNAdViewDelegate>
{
    GNAdView *_adView;
}

@end

