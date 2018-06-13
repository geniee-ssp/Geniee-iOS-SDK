//
//  ViewController.m
//  GNAdSampleBanner
//

#import "ViewController.h"

@interface ViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *zoneIDTextField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _zoneIDTextField.delegate = self;
    
    _adView = [[GNAdView alloc] initWithFrame:CGRectMake(0, 20, 320, 50)
                                   adSizeType:GNAdSizeTypeSmall appID:_zoneIDTextField.text];
    _adView.delegate = self;
    _adView.rootViewController = self;
    //_adView.geoLocationEnable = YES;
    _adView.GNAdlogPriority = GNLogPriorityInfo;
    
    [self.view addSubview:_adView];

    _adView.center = CGPointMake(self.view.center.x, _adView.center.y);
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

- (BOOL)shouldStartExternalBrowserWithClick:(GNAdView *)gnAdView landingURL:(NSString *)landingURL
{
    NSLog(@"ViewController: shouldStartExternalBrowserWithClick : %@.", landingURL);
    return YES;
}

- (IBAction)pushedButton:(id)sender {
    _adView = nil;
    
    if (!_zoneIDTextField.text) {
        return;
    }
    
    _adView = [[GNAdView alloc] initWithFrame:CGRectMake(0, 20, 300, 250)
                                   adSizeType:GNAdSizeTypeTall
                                        appID:_zoneIDTextField.text];
    _adView.delegate = self;
    _adView.rootViewController = self;
    [self.view addSubview:_adView];
    
    _adView.center = CGPointMake(self.view.center.x, _adView.center.y);
    [_adView startAdLoop];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    textField.resignFirstResponder;
    return true;
}

@end
