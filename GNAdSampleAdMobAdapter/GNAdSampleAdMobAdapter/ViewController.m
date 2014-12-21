//
//  ViewController.m
//  GNAdSampleAdMobAdapter
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Create a view of the standard size at the top of the screen.
    bannerView_ = [[GADBannerView alloc] initWithFrame:CGRectMake(0.0,20.0,
                                                                  GAD_SIZE_320x50.width,
                                                                  GAD_SIZE_320x50.height)];
    
    // Change the ad unit ID to AdMob_Mediation_ID.
    bannerView_.adUnitID = @"YOUR_ADMOB_BANNER_UNIT_ID";
    
    // Set reference to the current root view controller.
    // and then add to view layer
    bannerView_.delegate = self;
    bannerView_.rootViewController = self;
    [self.view addSubview:bannerView_];
    
    bannerView_.center =
    CGPointMake(self.view.center.x, bannerView_.center.y);
    // Load the ads with a general ad request.
    [bannerView_ loadRequest:[GADRequest request]];
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
