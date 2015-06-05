//
//  ViewController.h
//  GNAdSampleInterstitial
//

#import <UIKit/UIKit.h>
#import <GNAdSDK/GNInterstitial.h>

@interface ViewController : UIViewController<GNInterstitialDelegate>
{
    GNInterstitial *_interstitial;
}

@end

