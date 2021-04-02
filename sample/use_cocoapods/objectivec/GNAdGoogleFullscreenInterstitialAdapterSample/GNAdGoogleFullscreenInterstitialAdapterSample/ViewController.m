//
//  ViewController.m
//  GNAdGoogleFullscreenInterstitialAdapterSample
//

#import "ViewController.h"
#import "Util.h"
@import GoogleMobileAds;

@interface ViewController ()<GADFullScreenContentDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *unitIdView;
@property (weak, nonatomic) IBOutlet UIButton *buttonLoad;
@property (weak, nonatomic) IBOutlet UIButton *buttonShow;

@property(nonatomic, strong) GAMInterstitialAd *interstitial;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _buttonShow.enabled = NO;
    _unitIdView.delegate = self;

    GADMobileAds.sharedInstance.requestConfiguration.testDeviceIdentifiers = @[ [Util admobDeviceID] ];
}

- (IBAction)downButtonLoad:(id)sender {
    NSString* unitId = _unitIdView.text;
    if (unitId.length == 0) {
        return;
    }

    GAMRequest *request = [GAMRequest request];
    [GAMInterstitialAd loadWithAdManagerAdUnitID:unitId request:request completionHandler:^(GAMInterstitialAd *ad, NSError *error) {
        self.buttonLoad.enabled = YES;
        if (error) {
            NSLog(@"ViewController: downButtonLoad error = %@", error.localizedDescription);
            return;
        }
        NSLog(@"ViewController: downButtonLoad ad loaded.");
        self.buttonShow.enabled = YES;
        self.interstitial = ad;
        self.interstitial.fullScreenContentDelegate = self;
    }];

    _buttonLoad.enabled = NO;
}

- (IBAction)downButtonShow:(id)sender {
    if (self.interstitial) {
        NSLog(@"ViewController: downButtonShow show.");
        [self.interstitial presentFromRootViewController:self];
    } else {
        NSLog(@"ViewController: downButtonShow not show.");
    }
}


#pragma mark GADFullScreenContentDelegate
- (void)adDidPresentFullScreenContent:(id)ad {
    NSLog(@"ViewController: adDidPresentFullScreenContent");
}

- (void)ad:(id)ad didFailToPresentFullScreenContentWithError:(NSError *)error {
    NSLog(@"ViewController: didFailToPresentFullScreenContentWithError error = %@", [error localizedDescription]);
}

- (void)adDidDismissFullScreenContent:(id)ad {
    NSLog(@"ViewController: adDidDismissFullScreenContent");
    _buttonShow.enabled = NO;
    _interstitial = nil;
}


#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
