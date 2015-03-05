//
//  ViewController.h
//  GNAdSampleAdMobAdapter
//

#import <UIKit/UIKit.h>
#import "GADBannerView.h"
#import "GADBannerViewDelegate.h"

@interface ViewController : UIViewController<GADBannerViewDelegate> {
    GADBannerView *bannerView_;
}


@end

