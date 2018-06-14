//
//  TableViewController.h
//  GNAdSampleMultipleNative

#import <UIKit/UIKit.h>
#import <GNAdSDK/GNNativeAd.h>
#import <GNAdSDK/GNNativeAdRequest.h>

@interface TableViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate,GNNativeAdRequestDelegate>
{
    GNNativeAdRequest *nativeAdRequest;
}

@end
