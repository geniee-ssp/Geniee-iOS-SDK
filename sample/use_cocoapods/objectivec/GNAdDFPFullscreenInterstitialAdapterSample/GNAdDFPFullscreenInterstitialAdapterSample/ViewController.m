//
//  ViewController.m
//  GNAdDFPFullscreenInterstitialAdapterSample
//
//  Created by Nguyenthanh Long on 12/17/18.
//  Copyright © 2018 Geniee. All rights reserved.
//

#import "ViewController.h"
@import GoogleMobileAds;

@interface ViewController ()<GADInterstitialDelegate, UITextFieldDelegate>
@property(nonatomic, strong) DFPInterstitial *interstitial;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _showAdButton.hidden = YES;
    _dfpAdUnitIdLabel.delegate = self;
}

- (void)loadAd
{
    self.interstitial = [[DFPInterstitial alloc]initWithAdUnitID:_dfpAdUnitIdLabel.text];
    self.interstitial.delegate = self;
    DFPRequest *request = [DFPRequest request];
    [self.interstitial loadRequest:request];
    _showAdButton.hidden = YES;
}

- (IBAction)requestAd:(id)sender {
    [self loadAd];
}

- (IBAction)showAd:(id)sender {
    if (self.interstitial.isReady) {
        [self.interstitial presentFromRootViewController:self];
    }
}

#pragma mark GADInterstitialDelegate
/// Tells the delegate an ad request succeeded.
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
    NSLog(@"interstitialDidReceiveAd");
    self.showAdButton.hidden = NO;
}

/// Tells the delegate an ad request failed.
- (void)interstitial:(DFPInterstitial *)ad
didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"interstitial:didFailToReceiveAdWithError: %@", [error localizedDescription]);
}

/// Tells the delegate that an interstitial will be presented.
- (void)interstitialWillPresentScreen:(DFPInterstitial *)ad {
    NSLog(@"interstitialWillPresentScreen");
}

/// Tells the delegate the interstitial is to be animated off the screen.
- (void)interstitialWillDismissScreen:(DFPInterstitial *)ad {
    NSLog(@"interstitialWillDismissScreen");
}

/// Tells the delegate the interstitial had been animated off the screen.
- (void)interstitialDidDismissScreen:(DFPInterstitial *)ad {
    NSLog(@"interstitialDidDismissScreen");
}

/// Tells the delegate that a user click will open another app
/// (such as the App Store), backgrounding the current app.
- (void)interstitialWillLeaveApplication:(DFPInterstitial *)ad {
    NSLog(@"interstitialWillLeaveApplication");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
