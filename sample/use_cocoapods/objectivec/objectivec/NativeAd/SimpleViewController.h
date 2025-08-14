#import <UIKit/UIKit.h>
#import <GNAdSDK/GNNativeAd.h>
#import <GNAdSDK/GNNativeAdRequest.h>
#import <GNAdSDK/GNSNativeVideoPlayerView.h>

@interface SimpleViewController : UIViewController <GNNativeAdRequestDelegate, GNSNativeVideoPlayerDelegate>

@property(nonatomic, copy)NSString *zoneid;

@end

