//
//  RewardNewViewController.m
//  GNAdGoogleRewardMediationAdapterSample
//

#import "RewardNewViewController.h"
#include "Util.h"
@import GoogleMobileAds;

@interface RewardNewViewController () <GADRewardedAdDelegate>

@property (weak, nonatomic) IBOutlet UIButton *buttonLoad;
@property (weak, nonatomic) IBOutlet UIButton *buttonShow;

@property(nonatomic, strong) GADRewardedAd *rewardedAd;

@end

@implementation RewardNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _buttonShow.enabled = NO;
}

- (IBAction)downButtonLoad:(id)sender {
    _rewardedAd = [[GADRewardedAd alloc] initWithAdUnitID:_unitId];
    GADRequest *request = [GADRequest request];
    //request.testDevices = @[[Util admobDeviceID]];
    [_rewardedAd loadRequest:request completionHandler:^(GADRequestError * _Nullable error) {
        self.buttonLoad.enabled = YES;
        if (error) {
            // Handle ad failed to load case.
            NSLog(@"loadRequest error = %@", error.localizedDescription);
        } else {
            // Ad successfully loaded.
            self.buttonShow.enabled = YES;
        }
    }];
    _buttonLoad.enabled = NO;
}

- (IBAction)downButtonShow:(id)sender {
    if (_rewardedAd.isReady) {
        [_rewardedAd presentFromRootViewController:self delegate:self];
    }
}


#pragma mark: GADRewardedAdDelegate
/// Tells the delegate that the user earned a reward.
- (void)rewardedAd:(GADRewardedAd *)rewardedAd userDidEarnReward:(GADAdReward *)reward {
    NSString *rewardMessage =
            [NSString stringWithFormat:@"Reward received with currency %@ , amount %lf",
             reward.type, [reward.amount doubleValue]];
    NSLog(@"rewardedAd:userDidEarnReward %@", rewardMessage);
}

/// Tells the delegate that the rewarded ad was presented.
- (void)rewardedAdDidPresent:(GADRewardedAd *)rewardedAd {
    NSLog(@"rewardedAdDidPresent");
}

/// Tells the delegate that the rewarded ad failed to present.
- (void)rewardedAd:(GADRewardedAd *)rewardedAd didFailToPresentWithError:(NSError *)error {
    NSLog(@"rewardedAd:didFailToPresentWithError error = %@", error.localizedDescription);
}

/// Tells the delegate that the rewarded ad was dismissed.
- (void)rewardedAdDidDismiss:(GADRewardedAd *)rewardedAd {
    NSLog(@"rewardedAdDidDismiss");
    _buttonShow.enabled = NO;
}

@end
