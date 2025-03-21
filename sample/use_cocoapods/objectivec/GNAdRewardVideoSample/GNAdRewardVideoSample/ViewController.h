//
//  ViewController.h
//  GNAdRewardVideoSample
//

#import <UIKit/UIKit.h>

#import <GNAdSDK/GNSRewardVideoAd.h>
#import <GNAdSDK/GNSRequest.h>
#import <GNAdSDK/GNSAdReward.h>
#import <GNAdSDK/GNSRewardVideoAdDelegate.h>

@interface ViewController : UIViewController <GNSRewardVideoAdDelegate , UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *zoneIDText;

@property (weak, nonatomic) IBOutlet UILabel *gameLabel;

@property (weak, nonatomic) IBOutlet UIButton *showVideoButton;

@property (weak, nonatomic) IBOutlet UIButton *playAgainButton;

@property (weak, nonatomic) IBOutlet UILabel *coinCountLabel;

@end

