//
//  ViewController.m
//  GNAdSampleBanner
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _adView = [[GNAdView alloc] initWithAdSizeType:GNAdSizeTypeTall appID:@"YOUR_ZONE_ID"];
    _adView.delegate = self;
    _adView.rootViewController = self;
    //_adView.GNAdlogPriority = GNLogPriorityInfo;

    [self.view addSubview:_adView];
    _adView.center = CGPointMake(self.view.center.x, self.view.center.y);
    [_adView startAdLoop];
}

- (void)dealloc
{
    [_adView startAdLoop];
    _adView.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldStartExternalBrowserWithClick:(GNAdView *)adView landingURL:(NSString *)landingURL
{
    NSLog(@"ViewController: shouldStartExternalBrowserWithClick: %@.",landingURL);
    return YES;
}

@end
