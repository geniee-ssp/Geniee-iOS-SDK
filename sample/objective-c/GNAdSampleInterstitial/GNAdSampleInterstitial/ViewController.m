//
//  ViewController.m
//  GNAdSampleInterstitial
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

    _interstitial = [[GNInterstitial alloc] initWithID:@"YOUR_SSP_APP_ID"];
    _interstitial.delegate = self;
    _interstitial.rootViewController = self;
    //_interstitial.geoLocationEnable = YES;
    //_interstitial.GNAdlogPriority = GNLogPriorityInfo;
    
    [self showSampleButton];
}

- (void)dealloc
{
    _interstitial.delegate = nil;
}

- (void)loadEventFunc
{
    [_interstitial load];
}

- (void)showEventFunc
{
    if (_interstitial.isReady) {
        [_interstitial show:self];
    }

    showbutton.alpha = 0.4;
    showbutton.enabled = NO;
}

#pragma mark GNInterstitialDelegate function

// GNInterstitialDelegate listener override function
// Sent when an interstitial ad request succeeded
- (void)onReceiveSetting
{
    NSLog(@"ViewController: onReceiveSetting.");
    [self.view makeToast:@"onReceiveSetting"];
    
    showbutton.alpha = 1.0;
    showbutton.enabled = YES;
}

// GNInterstitialDelegate listener override function
// Sent when an interstitial ad request failed
// (Network Connection Unavailable, Frequency capping, Out of ad stock)
- (void)onFailedToReceiveSetting {
    NSLog(@"ViewController: onFailedToReceiveSetting.");
    [self.view makeToast:@"onFailedToReceiveSetting"];
    
    showbutton.alpha = 0.4;
    showbutton.enabled = NO;
}

// GNInterstitialDelegate listener override function
// Sent just after closing interstitial ad because the
// user clicked close button in an ad.
- (void)onClose {
    NSLog(@"ViewController: onClose.");
    [self.view makeToast:@"onClose"];
}

// GNInterstitialDelegate listener override function
// Sent just after closing interstitial ad because the
// user clicked the button configured through server-side.
- (void)onButtonClick:(NSUInteger)nButtonIndex {
    NSLog(@"ViewController: onButtonClick: %d", (int)nButtonIndex);
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
