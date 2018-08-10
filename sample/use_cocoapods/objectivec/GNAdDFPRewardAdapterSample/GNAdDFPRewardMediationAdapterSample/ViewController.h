//
//  ViewController.h
//  GNAdDFPRewardMediationAdapterSample
//

#import <UIKit/UIKit.h>

#import <GNAdSDK/GNSRewardVideoAd.h>
#import <GNAdSDK/GNSRequest.h>
#import <GNAdSDK/GNSAdReward.h>
#import <GNAdSDK/GNSRewardVideoAdDelegate.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface ViewController : UIViewController <GNSRewardVideoAdDelegate , GADRewardBasedVideoAdDelegate>

@property (weak, nonatomic) IBOutlet UITextField *zoneIDText;

@property (weak, nonatomic) IBOutlet UILabel *gameLabel;

@property (weak, nonatomic) IBOutlet UIButton *showVideoButton;

@property (weak, nonatomic) IBOutlet UIButton *playAgainButton;

@property (weak, nonatomic) IBOutlet UILabel *coinCountLabel;

@end
