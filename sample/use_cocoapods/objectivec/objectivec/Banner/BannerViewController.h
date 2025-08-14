#import <UIKit/UIKit.h>
#import <GNAdSDK/GNAdView.h>

@interface BannerViewController : UIViewController<GNAdViewDelegate>
{
    GNAdView *_adView;
    NSMutableArray *_adViews;
    UIScrollView *_scrollView;
    UITextView *_zoneIDText;
    UITextField *_zoneIDTextField;
    UIButton *_showAdButton;
}

@end
