//
//  ViewController.m
//  GNAdDFPRewardMediationAdapterSample
//

#import "ViewController.h"

@interface ViewController ()

/// Is an ad being loaded.
@property(nonatomic, assign, getter=isRewardBasedVideoRequestLoading) BOOL rewardBasedVideoRequestLoading;

/// The countdown timer.
@property(nonatomic, strong) NSTimer *timer;
/// The game counter.
@property(nonatomic, assign) NSInteger counter;

/// Number of coins the user has earned.
@property(nonatomic, assign) NSInteger coinCount;
@property (weak, nonatomic) IBOutlet UITextField *dfpAdUnitIdLabel;

@end



@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [GADRewardBasedVideoAd sharedInstance].delegate = self;
    
    self.showVideoButton.hidden = YES;
}


- (IBAction)showVideo:(id)sender {
    if ([[GADRewardBasedVideoAd sharedInstance] isReady]) {
        [[GADRewardBasedVideoAd sharedInstance] presentFromRootViewController:self];
    }
}

- (IBAction)playAgain:(id)sender {
    
    DFPRequest *request = [DFPRequest request];
    
    [[GADRewardBasedVideoAd sharedInstance] loadRequest:request withAdUnitID:_dfpAdUnitIdLabel.text];
    
    self.showVideoButton.hidden = YES;
}

#pragma mark: GADRewardBasedVideoAdDelegate

- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd didRewardUserWithReward:(GADAdReward *)reward {
    
    NSString *rewardMessage =
    [NSString stringWithFormat:@"Reward received with currency %@ , amount %lf",
     reward.type,
     [reward.amount doubleValue]];
    NSLog(@"didRewardUserWithReward %@", rewardMessage);
}

- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd didFailToLoadWithError:(NSError *)error {
    NSLog(@"didFailToLoadWithError error = %@", error);
}

- (void)rewardBasedVideoAdDidReceiveAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    
    NSLog(@"rewardBasedVideoAdDidReceiveAd");
    
    self.showVideoButton.hidden = NO;
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
    
    self.showVideoButton.hidden = YES;
}

/// Tells the delegate that the reward based video ad will leave the application.
- (void)rewardBasedVideoAdWillLeaveApplication:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"rewardBasedVideoAdWillLeaveApplication");
}


@end
