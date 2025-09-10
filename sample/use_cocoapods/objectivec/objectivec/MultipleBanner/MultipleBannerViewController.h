#import <UIKit/UIKit.h>
#import <GNAdSDK/GNAdViewRequest.h>
#import <GNAdSDK/GNAdView.h>


@interface MultipleBannerViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, GNAdViewRequestDelegate>
{
    GNAdViewRequest *_adViewRequest;
}

@end
