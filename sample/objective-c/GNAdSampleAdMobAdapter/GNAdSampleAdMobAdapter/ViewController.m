//
//  ViewController.m
//  GNAdSampleAdMobAdapter
//

@import GoogleMobileAds;

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Create a view of the standard size at the top of the screen.
    _bannerView = [[GADBannerView alloc] initWithFrame:CGRectMake(0.0,20.0,
                                                                  GAD_SIZE_320x50.width,
                                                                  GAD_SIZE_320x50.height)];
    
    // Change the ad unit ID to AdMob_Mediation_ID.
    _bannerView.adUnitID = @"YOUR_ADMOB_BANNER_UNIT_ID";
    _bannerView.delegate = self;
    _bannerView.rootViewController = self;
    [self.view addSubview:_bannerView];
    
    _bannerView.center = CGPointMake(self.view.center.x, _bannerView.center.y);
    // Load the ads with a general ad request.
    [_bannerView loadRequest:[GADRequest request]];
}

#pragma mark GADBannerViewDelegate impl

// We've received an ad successfully.
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    NSLog(@"Received ad successfully");
}

- (void)adView:(GADBannerView *)view
didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"Failed to receive ad with error: %@", [error localizedFailureReason]);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
