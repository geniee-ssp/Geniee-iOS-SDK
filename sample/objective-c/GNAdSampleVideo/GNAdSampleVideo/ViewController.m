//
//  ViewController.m
//  GNAdSampleVideo
//

#import "ViewController.h"
#import "UIView+Toast.h"

@interface ViewController ()
{
    UIButton *loadbutton;
    UIButton *showbutton;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _videoAd = [[GNAdVideo alloc] initWithID:@"YOUR_ZONE_ID_FOR_VIDEO"];
    //Optional sets alternative interstitial
    //[_videoAd setAlternativeInterstitialAppID:@"YOUR_ZONE_ID_FOR_INTERSTITIAL"];
    
    _videoAd.delegate = self;
    _videoAd.rootViewController = self;
    //_videoAd.GNAdlogPriority = GNLogPriorityInfo;
    //_videoAd.geoLocationEnable = YES;
    
    [self showSampleButton];
}

- (void)dealloc
{
    _videoAd.delegate = nil;
}

- (void)loadEventFunc
{
    [_videoAd load];
}

- (void)showEventFunc
{
    if ([_videoAd isReady]) {
        [_videoAd show:self];
    }
    showbutton.alpha = 0.4;
    showbutton.enabled = NO;
}

#pragma mark GNAdVideoDelegate

//GNAdVideoDelegate override function
// Sent when an video ad request succeeded.
- (void)onGNAdVideoReceiveSetting
{
    NSLog(@"GenieeSampleViewController: onGNAdVideoReceiveSetting.");
    [self.view makeToast:@"onGNAdVideoReceiveSetting"];
    showbutton.alpha = 1.0;
    showbutton.enabled = YES;
}

//GNAdVideoDelegate override function
// Sent when an video ad request failed.
// (Network Connection Unavailable, Frequency capping, Out of ad stock)
- (void)onGNAdVideoFailedToReceiveSetting
{
    NSLog(@"GenieeSampleViewController: onGNAdVideoFailedToReceiveSetting.");
    [self.view makeToast:@"onFailedToReceiveSetting"];
    showbutton.alpha = 0.4;
    showbutton.enabled = NO;
}

//GNAdVideoDelegate override function
// Sent just after closing ad because the user clicked skip button in video ad or
// close button in alternative interstitial ad.
- (void)onGNAdVideoClose{
    NSLog(@"GenieeSampleViewController: onGNAdVideoClose.");
    [self.view makeToast:@"onClose"];
}

//GNAdVideoDelegate override function
// Sent just after closing alternative interstitial ad because the
// user clicked the button configured through server-side.
- (void)onGNAdVideoButtonClick:(NSUInteger)nButtonIndex
{
    NSLog(@"GenieeSampleViewController: onButtonClick: %d", (int)nButtonIndex);
    NSString *str = [NSString stringWithFormat:@"onButtonClick: %d", (int)nButtonIndex];
    [self.view makeToast:str];
    // Describe the process corresponding the button number （nButtonIndex：1、2、...） a user pushed
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showSampleButton {
    // Sample button to load the Ad
    loadbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loadbutton setTitle:@"load interstitial" forState:UIControlStateNormal];
    loadbutton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    loadbutton.frame = CGRectMake((self.view.frame.size.width - 150)/2, 30, 150, 40);
    loadbutton.backgroundColor = [UIColor blackColor];
    [loadbutton addTarget:self action:@selector(loadEventFunc) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loadbutton];
    
    showbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [showbutton setTitle:@"show interstitial" forState:UIControlStateNormal];
    showbutton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    showbutton.frame = CGRectMake((self.view.frame.size.width - 150)/2, 90, 150, 40);
    showbutton.backgroundColor = [UIColor blackColor];
    [showbutton addTarget:self action:@selector(showEventFunc) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showbutton];
    
    showbutton.alpha = 0.4;
    showbutton.enabled = NO;
}


@end
