//
//  ViewController.m
//  GNAdSampleMediationBanner
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _adView = [[GNAdView alloc] initWithFrame:CGRectMake(0, 20, 320, 50)
                                   adSizeType:GNAdSizeTypeSmall appID:@"YOUR_SSP_APP_ID"];
    _adView.delegate = self;
    _adView.rootViewController = self;
    //_adView.GNAdlogPriority = GNLogPriorityInfo;
    //_adView.geoLocationEnable = YES;
    [self.view addSubview:_adView];
    [_adView startAdLoop];
}

- (void)dealloc
{
    [_adView stopAdLoop];
    _adView.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
