#import "MainViewController.h"

@import GoogleMobileAds;

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [GADMobileAds.sharedInstance startWithCompletionHandler:nil];
    GADMobileAds.sharedInstance.requestConfiguration.testDeviceIdentifiers = @[[Util admobDeviceID]];
    
    _scrollView.contentSize = CGSizeMake(0, 1100);
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *bundleIdentifier = [bundle bundleIdentifier];
    bool isUseCocoapods = [bundleIdentifier isEqual: @"jp.com.geniee.sample-objectivec-cocoapods"];
    
    [[self createButton:@"Banner" y:360] addTarget:self action:@selector(showBanner:) forControlEvents:UIControlEventTouchUpInside];
    [[self createButton:@"Fullscreen Interstitial" y:270 isEnable:isUseCocoapods] addTarget:self action:@selector(showFullscreenInterstitial:) forControlEvents:UIControlEventTouchUpInside];
    [[self createButton:@"Reward Video" y:180 isEnable:isUseCocoapods] addTarget:self action:@selector(showRewardVideo:) forControlEvents:UIControlEventTouchUpInside];
    [[self createButton:@"Google Banner" y:90] addTarget:self action:@selector(showGoogleBanner:) forControlEvents:UIControlEventTouchUpInside];
    [[self createButton:@"Google Fullscreen Interstitial" y:0] addTarget:self action:@selector(showGoogleFullscreenInterstitial:) forControlEvents:UIControlEventTouchUpInside];
    [[self createButton:@"Google Reward" y:-90] addTarget:self action:@selector(showGoogleReward:) forControlEvents:UIControlEventTouchUpInside];
    [[self createButton:@"Launch Google Ad Inspector" y:-180] addTarget:self action:@selector(launchGoogleAdInspector:) forControlEvents:UIControlEventTouchUpInside];
    [[self createButton:@"Multiple Banner" y:-270] addTarget:self action:@selector(showMultipleBanner:) forControlEvents:UIControlEventTouchUpInside];
    [[self createButton:@"Native" y:-360] addTarget:self action:@selector(showNative:) forControlEvents:UIControlEventTouchUpInside];
    [[self createButton:@"Sample Interstitial" y:-450] addTarget:self action:@selector(showSampleInterstitial:) forControlEvents:UIControlEventTouchUpInside];
    [[self createButton:@"Sample Video" y:-540] addTarget:self action:@selector(showSampleVideo:) forControlEvents:UIControlEventTouchUpInside];
}

- (UIButton *)createButton:(NSString *)title y:(NSInteger)y isEnable:(bool)isEnable {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    if (isEnable) {
        [button setTitle:title forState:UIControlStateNormal];
        button.backgroundColor = [UIColor blueColor];
    } else {
        [button setTitle:[title stringByAppendingString:@"\n(This sample is only\nsupported by use_cocoapods.)"] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor grayColor];
        button.titleLabel.numberOfLines = 3;
        button.enabled = false;
    }
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(self.view.center.x - 125, self.view.center.y - y, 250, 80);
    button.layer.cornerRadius = 10;
    [_scrollView addSubview:button];
    return button;
}

- (UIButton *)createButton:(NSString *)title y:(NSInteger)y {
    return [self createButton:title y:y isEnable:true];
}

- (void)showViewController:(UIViewController *)vc {
    [vc setModalPresentationStyle:UIModalPresentationPopover];
    [self presentViewController:vc animated:true completion:nil];
}

- (void)showStoryboard:(NSString *)nameAndId {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:nameAndId bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:nameAndId];
    [vc setModalPresentationStyle:UIModalPresentationPopover];
    [self presentViewController:vc animated:true completion:nil];
}

- (void)showBanner:(id)sender {
    [self showViewController: [[BannerViewController alloc] init]];
}

- (void)showFullscreenInterstitial:(id)sender {
    [self showStoryboard: @"FullscreenInterstitial"];
}

- (void)showRewardVideo:(id)sender {
    [self showStoryboard: @"RewardVideo"];
}

- (void)showGoogleBanner:(id)sender {
    [self showStoryboard: @"GoogleBanner"];
}

- (void)showGoogleFullscreenInterstitial:(id)sender {
    [self showStoryboard: @"GoogleFullscreenInterstitial"];
}

- (void)showGoogleReward:(id)sender {
    [self showStoryboard: @"GoogleReward"];
}

- (void)launchGoogleAdInspector:(id)sender {
    [GADMobileAds.sharedInstance presentAdInspectorFromViewController:self
      completionHandler:^(NSError *error) {
        // Error will be non-nil if there was an issue and the inspector was not displayed.
    }];
}

- (void)showMultipleBanner:(id)sender {
    [self showStoryboard: @"MultipleBanner"];
}

- (void)showNative:(id)sender {
    [self showStoryboard: @"Native"];
}

- (void)showSampleInterstitial:(id)sender {
    [self showViewController: [[SampleInterstitialViewController alloc] init]];
}

- (void)showSampleVideo:(id)sender {
    [self showViewController: [[SampleVideoViewController alloc] init]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
