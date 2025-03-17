//
//  ViewController.h
//  GNAdSampleBanner
//

#import <UIKit/UIKit.h>
#import <GNAdSDK/GNAdView.h>

@interface ViewController : UIViewController<GNAdViewDelegate>
{
    NSMutableArray *_adViews;
    UIScrollView *_scrollView;
}

@end

