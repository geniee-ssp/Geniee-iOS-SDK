#import "GoogleRewardViewController.h"
@import GoogleMobileAds;

@interface GoogleRewardViewController () <GADFullScreenContentDelegate>

@property (weak, nonatomic) IBOutlet UITextField *unitIdView;
@property (weak, nonatomic) IBOutlet UIButton *buttonLoad;
@property (weak, nonatomic) IBOutlet UIButton *buttonShow;

@property(nonatomic, strong) GADRewardedAd *rewardedAd;

@end

@implementation GoogleRewardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _buttonShow.enabled = NO;
}

- (IBAction)downButtonLoad:(id)sender {
    NSString* unitId = _unitIdView.text;
    if (unitId.length == 0) {
        return;
    }

    GAMRequest *request = [GAMRequest request];
    [GADRewardedAd loadWithAdUnitID:unitId request:request completionHandler:^(GADRewardedAd *ad, NSError *error) {
        if (error) {
            self.buttonLoad.enabled = YES;
            NSLog(@"ViewController: downButtonLoad error = %@", error.localizedDescription);
            return;
        }
        NSLog(@"ViewController: downButtonLoad ad loaded.");
        self.buttonShow.enabled = YES;
        self.rewardedAd = ad;
        self.rewardedAd.fullScreenContentDelegate = self;
    }];

    _buttonLoad.enabled = NO;
}

- (IBAction)downButtonShow:(id)sender {
    if (self.rewardedAd) {
        NSLog(@"ViewController: downButtonShow show.");
        [self.rewardedAd presentFromRootViewController:self userDidEarnRewardHandler:^ {
            GADAdReward *reward = self.rewardedAd.adReward;
            NSLog(@"ViewController: rewardedAd:userDidEarnRewardHandler type = %@, amount = %lf", reward.type, [reward.amount doubleValue]);
        }];
    } else {
        NSLog(@"ViewController: downButtonShow not show.");
    }
    self.buttonLoad.enabled = YES;
}


#pragma mark: GADFullScreenContentDelegate

/// Tells the delegate that the rewarded ad was presented.
- (void)adDidPresentFullScreenContent:(id)ad {
    NSLog(@"ViewController: adDidPresentFullScreenContent");
}

/// Tells the delegate that the rewarded ad failed to present.
- (void)ad:(id)ad
    didFailToPresentFullScreenContentWithError:(NSError *)error {
    NSLog(@"ViewController: didFailToPresentFullScreenContentWithError error = %@", [error localizedDescription]);
}

/// Tells the delegate that the rewarded ad was dismissed.
- (void)adDidDismissFullScreenContent:(id)ad {
    NSLog(@"ViewController: adDidDismissFullScreenContent");
    _buttonShow.enabled = NO;
    _rewardedAd = nil;
}


@end
