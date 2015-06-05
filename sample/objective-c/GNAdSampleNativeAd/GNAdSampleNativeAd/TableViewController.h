//
//  TableViewController.h
//  GNAdSampleNativeAd
//

#import <UIKit/UIKit.h>
#import <GNAdSDK/GNNativeAdRequest.h>
#import <GNAdSDK/GNNativeAd.h>

@interface TableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, GNNativeAdRequestDelegate>
{
    GNNativeAdRequest *_nativeAdRequest;
}

@end
