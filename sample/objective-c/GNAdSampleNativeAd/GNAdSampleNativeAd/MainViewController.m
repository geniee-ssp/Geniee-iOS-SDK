//
//  MainViewController.m
//  GNAdSampleNativeAd
//

#import "MainViewController.h"
#import "SimpleViewController.h"
#import "ImageTableViewController.h"
#import "VideoTableViewController.h"

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UITextField *zoneidTextView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _zoneidTextView.delegate = self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"mainTableCell";
    
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    UILabel *label = (UILabel *)[cell viewWithTag:0];
    NSString* strItem = @"No item";
    switch (indexPath.row) {
        case 0:
            strItem = @"Native video sample";
            break;
        case 1:
            strItem = @"Native image sample";
            break;
        case 2:
            strItem = @"Simple native video sample";
            break;
        default:
            break;
    }
    label.text = strItem;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    float height = 60.0f;
    
    return height;
}

#pragma mark - Table View Click
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* zoneid = _zoneidTextView.text;
    if (0 == (int)indexPath.row) {
        VideoTableViewController *videoVC =  [self.storyboard instantiateViewControllerWithIdentifier:@"VideoTableViewController"];
        videoVC.zoneid = zoneid;
        [self.navigationController pushViewController:videoVC animated:NO];
    } else if (1 == (int)indexPath.row) {
        ImageTableViewController *imageVC =  [self.storyboard instantiateViewControllerWithIdentifier:@"ImageTableViewController"];
        imageVC.zoneid = zoneid;
        [self.navigationController pushViewController:imageVC animated:NO];
    } else if (2 == (int)indexPath.row) {
        SimpleViewController *simpleVC =  [self.storyboard instantiateViewControllerWithIdentifier:@"SimpleViewController"];
        simpleVC.zoneid = zoneid;
        [self.navigationController pushViewController:simpleVC animated:NO];
    }
}

#pragma mark - UITextFieldDelegate
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end

