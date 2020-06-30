//
//  RewardRegacyViewController.m
//  GNAdGoogleRewardMediationAdapterSample
//

#import "RewardRegacyViewController.h"
#include "Util.h"
@import GoogleMobileAds;

@interface RewardRegacyViewController () <GADRewardBasedVideoAdDelegate>

@property (weak, nonatomic) IBOutlet UIButton *buttonLoad;
@property (weak, nonatomic) IBOutlet UIButton *buttonShow;

@end

@implementation RewardRegacyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _buttonShow.enabled = NO;

    [GADRewardBasedVideoAd sharedInstance].delegate = self;
}

- (IBAction)downButtonLoad:(id)sender {
    _buttonLoad.enabled = NO;
    _buttonShow.enabled = NO;

    DFPRequest *request = [DFPRequest request];
    //request.testDevices = @[[Util admobDeviceID]];
    [[GADRewardBasedVideoAd sharedInstance] loadRequest:request withAdUnitID:_unitId];
}

- (IBAction)downButtonShow:(id)sender {
    if ([[GADRewardBasedVideoAd sharedInstance] isReady]) {
        [[GADRewardBasedVideoAd sharedInstance] presentFromRootViewController:self];
    }
}


#pragma mark: GADRewardBasedVideoAdDelegate

- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd didRewardUserWithReward:(GADAdReward *)reward {
    
    NSString *rewardMessage =
    [NSString stringWithFormat:@"Reward received with currency %@ , amount %lf", reward.type, [reward.amount doubleValue]];
    NSLog(@"rewardBasedVideoAd:didRewardUserWithReward %@", rewardMessage);
}

- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd didFailToLoadWithError:(NSError *)error {
    NSLog(@"rewardBasedVideoAd:didFailToLoadWithError error = %@", [error localizedDescription]);
    _buttonLoad.enabled = YES;
    _buttonShow.enabled = NO;
}

- (void)rewardBasedVideoAdDidReceiveAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"rewardBasedVideoAdDidReceiveAd");
    _buttonLoad.enabled = YES;
    _buttonShow.enabled = YES;
}

/// Tells the delegate that the reward based video ad opened.
- (void)rewardBasedVideoAdDidOpen:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"rewardBasedVideoAdDidOpen");
}

/// Tells the delegate that the reward based video ad started playing.
- (void)rewardBasedVideoAdDidStartPlaying:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"rewardBasedVideoAdDidStartPlaying");
}

/// Tells the delegate that the reward based video ad completed playing.
- (void)rewardBasedVideoAdDidCompletePlaying:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"rewardBasedVideoAdDidCompletePlaying");
}

/// Tells the delegate that the reward based video ad closed.
- (void)rewardBasedVideoAdDidClose:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"rewardBasedVideoAdDidClose");
    _buttonShow.enabled = NO;
}

/// Tells the delegate that the reward based video ad will leave the application.
- (void)rewardBasedVideoAdWillLeaveApplication:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"rewardBasedVideoAdWillLeaveApplication");
}

@end
