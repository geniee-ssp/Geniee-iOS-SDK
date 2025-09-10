#import <UIKit/UIKit.h>
#import <GNAdSDK/GNAdVideo.h>

@interface SampleVideoViewController : UIViewController<GNAdVideoDelegate>
{
    GNAdVideo *_videoAd;
}

@end

