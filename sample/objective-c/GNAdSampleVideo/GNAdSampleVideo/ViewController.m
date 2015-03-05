//
//  ViewController.m
//  GNAdSampleVideo
//

#import "ViewController.h"
#import "UIView+Toast.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _videoAd = [[GNAdVideo alloc] initWithID:@"YOUR_SSP_APP_ID_FOR_VIDEO"];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showSampleButton {
    // Sample button to load the Ad
    UIButton *loadbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loadbutton setTitle:@"load video" forState:UIControlStateNormal];
    loadbutton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    loadbutton.frame = CGRectMake((self.view.frame.size.width - 150)/2, 30, 150, 40);
    loadbutton.backgroundColor = [UIColor blackColor];
    [loadbutton addTarget:self action:@selector(buttonDidPush) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loadbutton];
}

// Sample button to load the Ad
- (void)buttonDidPush
{
    NSLog(@"buttonPush");
    [self.view makeToast:@"load video"];
    // Load GNAdVideo Ad
    [_videoAd load];
}

#pragma mark GNAdVideoDelegate

//GNAdVideoDelegate override function
// Sent when an video ad request succeeded.
- (void)onGNAdVideoReceiveSetting
{
    NSLog(@"GenieeSampleViewController: onGNAdVideoReceiveSetting.");
    [self.view makeToast:@"onReceiveSetting"];
    BOOL is_show = [_videoAd show:self];
    if (is_show) {
        // Describe the process to presents the video ad
        NSLog(@"GenieeSampleViewController: onReceiveSetting: show.");
        [self.view makeToast:@"onReceiveSetting: show"];
    } else {
        // Describe the process not to presents the video ad
        NSLog(@"GenieeSampleViewController: onReceiveSetting: not show.");
        [self.view makeToast:@"onReceiveSetting: not show"];
    }
}

//GNAdVideoDelegate override function
// Sent when an video ad request failed.
// (Network Connection Unavailable, Frequency capping, Out of ad stock)
- (void)onGNAdVideoFailedToReceiveSetting
{
    NSLog(@"GenieeSampleViewController: onGNAdVideoFailedToReceiveSetting.");
    [self.view makeToast:@"onFailedToReceiveSetting"];
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


@end
