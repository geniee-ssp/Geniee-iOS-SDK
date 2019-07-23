//
//  ViewController.m
//  GNAdSampleAdMobAdapter
//

@import GoogleMobileAds;

#import "ViewController.h"

@interface ViewController()

@property(nonatomic, strong) DFPBannerView *bannerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Instantiate the banner view with your desired banner size.
    self.bannerView = [[DFPBannerView alloc] initWithAdSize:kGADAdSizeMediumRectangle];
    [self addBannerViewToView:self.bannerView];

    // Replace this ad unit ID with your own ad unit ID.
    self.bannerView.adUnitID = @"MY_ADMANAGER_OR_ADMOB_AD_UNIT_ID";
    self.bannerView.rootViewController = self;
    DFPRequest *request = [DFPRequest request];
    [self.bannerView loadRequest:request];
    
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


#pragma mark - view positioning

-(void)addBannerViewToView:(UIView *_Nonnull)bannerView {
    self.bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.bannerView];
    if (@available(ios 11.0, *)) {
        [self positionBannerViewAtBottomOfSafeArea:bannerView];
    } else {
        [self positionBannerViewAtBottomOfView:bannerView];
    }
}

- (void)positionBannerViewAtBottomOfSafeArea:(UIView *_Nonnull)bannerView NS_AVAILABLE_IOS(11.0) {
    // Position the banner. Stick it to the bottom of the Safe Area.
    // Centered horizontally.
    UILayoutGuide *guide = self.view.safeAreaLayoutGuide;
    [NSLayoutConstraint activateConstraints:@[
                                              [bannerView.centerXAnchor constraintEqualToAnchor:guide.centerXAnchor],
                                              [bannerView.centerYAnchor constraintEqualToAnchor:guide.centerYAnchor]
                                              ]];
}

- (void)positionBannerViewAtBottomOfView:(UIView *_Nonnull)bannerView {
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bannerView
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bannerView
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1
                                                           constant:0]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
