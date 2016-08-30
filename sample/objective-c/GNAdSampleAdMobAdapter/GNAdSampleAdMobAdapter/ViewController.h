//
//  ViewController.h
//  GNAdSampleAdMobAdapter
//

#import <UIKit/UIKit.h>
@class GADBannerView;
@class GADBannerViewDelegate;

@interface ViewController : UIViewController<GADBannerViewDelegate> {
    GADBannerView *_bannerView;
}

@end