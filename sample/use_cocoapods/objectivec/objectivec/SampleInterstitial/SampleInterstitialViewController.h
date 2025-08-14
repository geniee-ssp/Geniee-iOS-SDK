#import <UIKit/UIKit.h>
#import <GNAdSDK/GNInterstitial.h>

@interface SampleInterstitialViewController : UIViewController<GNInterstitialDelegate>
{
    GNInterstitial *_interstitial;
}

@end

