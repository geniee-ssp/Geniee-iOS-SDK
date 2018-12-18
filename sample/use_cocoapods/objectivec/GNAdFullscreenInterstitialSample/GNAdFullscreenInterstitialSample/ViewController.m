//
//  ViewController.m
//  GNAdFullscreenInterstitialSample
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _zoneIDText.delegate = self;
    
    [GNSFullscreenInterstitialAd sharedInstance].delegate = self;
}

- (void)requestFullscreenInterstitialAd {
    self.loadAdButton.hidden = YES;
    self.showAdButton.hidden = YES;
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
    self.loadAdButton.hidden = NO;
    self.showAdButton.hidden = NO;
}

- (void)fullscreenInterstitial:(GNSFullscreenInterstitialAd *)fullscreenInterstitial didFailToLoadWithError:(NSError *)error
{
    NSLog(@"FullscreenInterstitialAd load failed: %@", error.description);
}

- (void)fullscreenInterstitialAdDidClick:(GNSFullscreenInterstitialAd *)fullscreenInterstitial
{
    NSLog(@"FullscreenInterstitialAd clicked.");
}

- (void)fullscreenInterstitialAdDidClose:(GNSFullscreenInterstitialAd *)fullscreenInterstitial
{
    NSLog(@"FullscreenInterstitialAd Closed");
}

- (void)fullscreenInterstitialWillPresentScreen:(GNSFullscreenInterstitialAd *)fullscreenInterstitial
{
    NSLog(@"FullscreenInterstitialAd did presented");
}


@end
