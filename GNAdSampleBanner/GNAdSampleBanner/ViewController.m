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
    
    _adView = [[GNAdView alloc] initWithFrame:CGRectMake(0, 20, 320, 50)
                                   adSizeType:GNAdSizeTypeSmall appID:@"YOUR_SSP_APP_ID"];
    _adView.delegate = self;
    _adView.rootViewController = self;
    //_adView.geoLocationEnable = YES;
    //_adView.GNAdlogPriority = GNLogPriorityInfo;
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
