//
//  ViewController.m
//  GNAdRewardVideoSample
//

#import "ViewController.h"



/// Constant for coin rewards.
static const NSInteger GameOverReward = 1;

static const NSInteger GameLength = 5;

@interface ViewController ()

/// Is an ad being loaded.
@property(nonatomic, assign, getter=isRewardBasedVideoRequestLoading) BOOL rewardBasedVideoRequestLoading;

/// The countdown timer.
@property(nonatomic, strong) NSTimer *timer;
/// The game counter.
@property(nonatomic, assign) NSInteger counter;

/// Number of coins the user has earned.
@property(nonatomic, assign) NSInteger coinCount;

@end



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _zoneIDText.delegate = self;
    
    [GNSRewardVideoAd sharedInstance].delegate = self;
    self.coinCount = 0;
    [self earnCoins:0];
    
    [self startNewGame];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)requestRewardedVideo {
    self.rewardBasedVideoRequestLoading = YES;
    
    GNSRequest *request = [GNSRequest request];
    //request.geoLocationEnable = NO;
    request.GNAdlogPriority = GNLogPriorityInfo;
    
    [[GNSRewardVideoAd sharedInstance] loadRequest:request
                                        withZoneID:_zoneIDText.text];
}

- (void)startNewGame {
    [self requestRewardedVideo];
    
    self.playAgainButton.hidden = YES;
    self.showVideoButton.hidden = YES;
    self.counter = GameLength;
    self.gameLabel.text = [NSString stringWithFormat:@"%ld", (long)self.counter];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:self
                                                selector:@selector(decrementCounter:)
                                                userInfo:nil
                                                 repeats:YES];
    self.timer.tolerance = GameLength * 0.1;
}

- (void)decrementCounter:(NSTimer *)timer {
    self.counter--;
    if (self.counter > 0) {
        self.gameLabel.text = [NSString stringWithFormat:@"game %ld", (long)self.counter];
    } else {
        [self endGame];
    }
}

- (void)earnCoins:(NSInteger)coins {
    self.coinCount += coins;
    [self.coinCountLabel setText:[NSString stringWithFormat:@"Coins: %ld", (long)self.coinCount]];
}

- (void)endGame {
    [self.timer invalidate];
    self.timer = nil;
    self.gameLabel.text = @"Game over!";
    if ([[GNSRewardVideoAd sharedInstance] canShow]) {
        self.showVideoButton.hidden = NO;
    }
    self.playAgainButton.hidden = NO;
    
    // Reward user with coins for finishing the game.
    [self earnCoins:GameOverReward];
}

- (IBAction)showVideo:(id)sender {
    if ([[GNSRewardVideoAd sharedInstance] canShow]) {
        [[GNSRewardVideoAd sharedInstance] show:self];
    } else {
        [[[UIAlertView alloc]
          initWithTitle:@"Reward video not ready"
          message:@"The Reward video didn't finish loading or failed to load or need to reload"
          delegate:self
          cancelButtonTitle:@"OK"
          otherButtonTitles:nil] show];
    }
}

- (IBAction)playAgain:(id)sender {
    [self startNewGame];
}

/// Tells the delegate that the reward video ad failed to load.
- (void)rewardVideoAd:(GNSRewardVideoAd *)rewardVideoAd
didFailToLoadWithError:(NSError *)error
{
    NSLog(@"ViewController: Reward video ad failed to load. error: %@", [error description]);
}

/// Tells the delegate that a reward video ad was received.
- (void)rewardVideoAdDidReceiveAd:(GNSRewardVideoAd *)rewardVideoAd
{
    NSLog(@"ViewController: Reward video ad is received.");
}

/// Tells the delegate that the reward video ad started playing.
- (void)rewardVideoAdDidStartPlaying:(GNSRewardVideoAd *)rewardVideoAd
{
    NSLog(@"ViewController: Reward video ad started playing.");
}

/// Tells the delegate that the reward video ad closed.
- (void)rewardVideoAdDidClose:(GNSRewardVideoAd *)rewardVideoAd
{
    NSLog(@"ViewController: Reward video ad is closed.");
    self.showVideoButton.hidden = YES;
}

/// Tells the delegate that the reward video ad has rewarded the user.
- (void)rewardVideoAd:(GNSRewardVideoAd *)rewardVideoAd
didRewardUserWithReward:(GNSAdReward *)reward
{
    NSLog(@"ViewController: Reward received type=%@, amount=%lf"
          ,reward.type
          ,[reward.amount doubleValue]);
    
    [self earnCoins:[reward.amount integerValue]];
    self.showVideoButton.hidden = YES;
}

// Hide the keyboard when press return key in a UITextField
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
