//
//  ViewController.h
//  GNAdSampleBanner
//

#import <UIKit/UIKit.h>
#import "GNAdView.h"

@interface ViewController : UIViewController<GNAdViewDelegate>
{
    GNAdView *_adView;
}

@end

