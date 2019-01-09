//
//  VideoTableViewController.h
//  GNAdSampleNativeAd
//

#import <UIKit/UIKit.h>
#import <GNAdSDK/GNNativeAd.h>
#import <GNAdSDK/GNNativeAdRequest.h>
#import <GNAdSDK/GNSNativeVideoPlayerView.h>

@interface VideoTableViewController : UITableViewController <UITableViewDataSource, GNNativeAdRequestDelegate, GNSNativeVideoPlayerDelegate>
{
    GNNativeAdRequest *_nativeAdRequest;
}
@property(nonatomic, copy)NSString *zoneid;

@end

