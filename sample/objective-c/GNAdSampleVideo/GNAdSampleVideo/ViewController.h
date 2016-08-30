//
//  ViewController.h
//  GNAdSampleVideo
//

#import <UIKit/UIKit.h>
#import <GNAdSDK/GNAdVideo.h>

@interface ViewController : UIViewController<GNAdVideoDelegate>
{
    GNAdVideo *_videoAd;
}

@end

