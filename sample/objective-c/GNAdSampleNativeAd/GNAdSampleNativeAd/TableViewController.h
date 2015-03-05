//
//  TableViewController.h
//  GNAdSampleNativeAd
//

#import <UIKit/UIKit.h>
#import "GNNativeAdRequest.h"
#import "GNNativeAd.h"

@interface TableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, GNNativeAdRequestDelegate>
{
    GNNativeAdRequest *_nativeAdRequest;
}

@end
