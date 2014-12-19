//
//  ViewController.h
//  GNAdSampleInterstitial
//

#import <UIKit/UIKit.h>
#import "GNInterstitial.h"

@interface ViewController : UIViewController<GNInterstitialDelegate>
{
    GNInterstitial *_interstitial;
}

@end

