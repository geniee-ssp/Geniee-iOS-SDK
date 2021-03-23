//
//  ViewController.m
//  GNAdGoogleBannerAdapterSample
//

@import GoogleMobileAds;

#import "ViewController.h"
#import "Util.h"

@interface ViewController() <GADBannerViewDelegate, UIPickerViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *unitIdView;
@property (weak, nonatomic) IBOutlet UIPickerView *adSizeView;

@property(nonatomic, strong) GAMBannerView *bannerView;

@end

@implementation ViewController {
    NSMutableArray* adSizeArray;
    int adSizeIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    adSizeIndex = 0;
    _unitIdView.delegate = self;
    _adSizeView.delegate = self;
    [self setAdSizeArray];

    GADMobileAds.sharedInstance.requestConfiguration.testDeviceIdentifiers = @[[Util admobDeviceID]];
}

- (void)setAdSizeArray {
    adSizeArray = [NSMutableArray array];
    [adSizeArray addObject:@"Select AdSizeType"];
    [adSizeArray addObject:@"Banner"];              // 320x50
    [adSizeArray addObject:@"MediumRectangle"];     // 300x250
}

- (GADAdSize)getAdSizeType:(int)index {
    GADAdSize adSizeType = kGADAdSizeInvalid;
    switch (index) {
        case 1:
            adSizeType = kGADAdSizeBanner;
            break;
        case 2:
            adSizeType = kGADAdSizeMediumRectangle;
            break;
        default:
            adSizeType = kGADAdSizeInvalid;
            break;
    }
    return adSizeType;
}

- (IBAction)loadDownButton:(id)sender {
    if (_unitIdView.text.length == 0) {
        return;
    }
    if (adSizeIndex == 0) {
        return;
    }
    if (self.bannerView != nil) {
        [self.bannerView removeFromSuperview];
        self.bannerView.delegate = nil;
        self.bannerView = nil;
    }

    // Instantiate the banner view with your desired banner size.
    _bannerView = [[GAMBannerView alloc] initWithAdSize:[self getAdSizeType:adSizeIndex]];
    [self addBannerViewToView:self.bannerView];
    _bannerView.adUnitID = _unitIdView.text;
    _bannerView.delegate = self;
    _bannerView.rootViewController = self;
    GAMRequest * request = [GAMRequest request];
    [self.bannerView loadRequest:request];
}


#pragma mark - view positioning
-(void)addBannerViewToView:(UIView *_Nonnull)bannerView {
    self.bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.bannerView];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bannerView
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bannerView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1
                                                           constant:-20]];
}


#pragma mark GADBannerViewDelegate impl

// We've received an ad successfully.
- (void)bannerViewDidReceiveAd:(nonnull GADBannerView *)bannerView {
    NSLog(@"ViewController: bannerViewDidReceiveAd");
}

- (void)bannerView:(nonnull GADBannerView *)bannerView
        didFailToReceiveAdWithError:(nonnull NSError *)error {
    NSLog(@"ViewController: didFailToReceiveAdWithError: %@", [error localizedDescription]);
}


#pragma mark UIPickerViewDelegate.

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView: (UIPickerView*)pView numberOfRowsInComponent:(NSInteger) component {
    NSInteger cnt = [adSizeArray count];
    return cnt;
}

- (NSString*)pickerView: (UIPickerView*) pView titleForRow:(NSInteger) row forComponent:(NSInteger)componet
{
    return [adSizeArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    adSizeIndex = (int)[pickerView selectedRowInComponent:0];
}


#pragma mark - UITextFieldDelegate
-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
