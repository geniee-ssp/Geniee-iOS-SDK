#import <UIKit/UIKit.h>
#import <GNAdSDK/GNNativeAdRequest.h>
#import <GNAdSDK/GNNativeAd.h>

@interface ImageTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, GNNativeAdRequestDelegate>
{
    GNNativeAdRequest *_nativeAdRequest;
}
@property(nonatomic, copy)NSString *zoneid;

@end

