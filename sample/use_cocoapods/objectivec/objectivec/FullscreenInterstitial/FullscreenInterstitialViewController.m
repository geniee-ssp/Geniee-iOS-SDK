#import "FullscreenInterstitialViewController.h"

@interface FullscreenInterstitialViewController ()

@end

@implementation FullscreenInterstitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _zoneIDText.delegate = self;
    
    [GNSFullscreenInterstitialAd sharedInstance].delegate = self;
    
    self.showAdButton.enabled = NO;
}

- (void)requestFullscreenInterstitialAd {
    self.loadAdButton.enabled = NO;
    GNSRequest *request = [GNSRequest request];
    //request.geoLocationEnable = NO;
    request.GNAdlogPriority = GNLogPriorityInfo;
    [[GNSFullscreenInterstitialAd sharedInstance] loadRequest:request withZoneID:_zoneIDText.text];
}

- (IBAction)loadInterstitialAd:(id)sender {
    [self requestFullscreenInterstitialAd];
}

- (IBAction)showInterstitialAd:(id)sender {
    if ([[GNSFullscreenInterstitialAd sharedInstance] canShow]) {
        [[GNSFullscreenInterstitialAd sharedInstance] show:self];
    }
}

// Hide the keyboard when press return key in a UITextField
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark GNSFullscreenInterstitialAdDelegate
- (void)fullscreenInterstitialDidReceiveAd:(GNSFullscreenInterstitialAd *)fullscreenInterstitial
{
    NSLog(@"FullscreenInterstitialAd received.");
    self.showAdButton.enabled = YES;
}

- (void)fullscreenInterstitial:(GNSFullscreenInterstitialAd *)fullscreenInterstitial didFailToLoadWithError:(NSError *)error
{
    NSLog(@"FullscreenInterstitialAd load failed: %@", error.description);
    self.loadAdButton.enabled = YES;
}

- (void)fullscreenInterstitialAdDidClick:(GNSFullscreenInterstitialAd *)fullscreenInterstitial
{
    NSLog(@"FullscreenInterstitialAd clicked.");
}

- (void)fullscreenInterstitialAdDidClose:(GNSFullscreenInterstitialAd *)fullscreenInterstitial
{
    NSLog(@"FullscreenInterstitialAd Closed");
    self.loadAdButton.enabled = YES;
    self.showAdButton.enabled = NO;
}

- (void)fullscreenInterstitialWillPresentScreen:(GNSFullscreenInterstitialAd *)fullscreenInterstitial
{
    NSLog(@"FullscreenInterstitialAd did presented");
}


@end
