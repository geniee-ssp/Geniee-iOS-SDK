//
//  MainViewController.m
//  GNAdGoogleRewardMediationAdapterSample
//

#import "MainViewController.h"
#import "RewardNewViewController.h"
#import "RewardRegacyViewController.h"

@interface MainViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *adUnitIdView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _adUnitIdView.delegate = self;
}

- (IBAction)downButtonRegacyApi:(id)sender {
    NSString* unitId = _adUnitIdView.text;
    if (unitId.length == 0) {
        return;
    }

    RewardRegacyViewController* vc =  [self.storyboard instantiateViewControllerWithIdentifier:@"RewardRegacyViewController"];
    vc.unitId = unitId;
    [self.navigationController pushViewController:vc animated:NO];
}

- (IBAction)downButtonNewApi:(id)sender {
    NSString* unitId = _adUnitIdView.text;
    if (unitId.length == 0) {
        return;
    }

    RewardNewViewController* vc =  [self.storyboard instantiateViewControllerWithIdentifier:@"RewardNewViewController"];
    vc.unitId = unitId;
    [self.navigationController pushViewController:vc animated:NO];
}


#pragma mark: UITextFieldDelegate
-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
