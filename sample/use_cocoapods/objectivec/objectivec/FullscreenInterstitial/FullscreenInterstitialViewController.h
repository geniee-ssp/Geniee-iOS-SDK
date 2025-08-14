#import <UIKit/UIKit.h>
#import <GNAdSDK/GNSFullscreenInterstitialAd.h>
#import <GNAdSDK/GNSRequest.h>
#import <GNAdSDK/GNSFullscreenInterstitialAdDelegate.h>

@interface FullscreenInterstitialViewController : UIViewController<GNSFullscreenInterstitialAdDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *zoneIDText;

@property (weak, nonatomic) IBOutlet UIButton *showAdButton;
@property (weak, nonatomic) IBOutlet UIButton *loadAdButton;

@end

