#import "NativeMainViewController.h"
#import "SimpleViewController.h"
#import "ImageTableViewController.h"
#import "VideoTableViewController.h"

@interface NativeMainViewController ()

@property (weak, nonatomic) IBOutlet UITextField *zoneidTextView;

@end

@implementation NativeMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _zoneidTextView.delegate = self;
}

//Table Viewのセクション数を指定
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // 今回はセクション１個
    return 1;
}

//Table Viewのセルの数を指定
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

//各セルの要素を設定する
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"mainTableCell";
    
    // tableCell の ID で UITableViewCell のインスタンスを生成
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Tag番号0で UILabel インスタンスの取得
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

// セルの高さを設定する
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    float height = 60.0f;
    
    return height;
}

- (void)showAd:(UIViewController *)vc {
    //[self.navigationController pushViewController:vc animated:NO];
    [vc setModalPresentationStyle:UIModalPresentationPopover];
    [self presentViewController:vc animated:true completion:nil];
}

#pragma mark - Table View Click
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* zoneid = _zoneidTextView.text;
    if (0 == (int)indexPath.row) {
        VideoTableViewController *videoVC =  [self.storyboard instantiateViewControllerWithIdentifier:@"VideoTableViewController"];
        videoVC.zoneid = zoneid;
        [self showAd: videoVC];
    } else if (1 == (int)indexPath.row) {
        ImageTableViewController *imageVC =  [self.storyboard instantiateViewControllerWithIdentifier:@"ImageTableViewController"];
        imageVC.zoneid = zoneid;
        [self showAd: imageVC];
    } else if (2 == (int)indexPath.row) {
        SimpleViewController *simpleVC =  [self.storyboard instantiateViewControllerWithIdentifier:@"SimpleViewController"];
        simpleVC.zoneid = zoneid;
        [self showAd: simpleVC];
        
    }
}

#pragma mark - UITextFieldDelegate
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end

