//
//  ViewController.h
//  GNAdSampleVideo
//

#import <UIKit/UIKit.h>
#import "GNAdVideo.h"

@interface ViewController : UIViewController<GNAdVideoDelegate>
{
    GNAdVideo *_videoAd;
}

@end

