//
//  TableViewController.m
//  GNAdSampleMultipleNative


#import "TableViewController.h"
#import "TableViewCell.h"
#import "MyCellData.h"
#import "GNQueue.h"

@interface TableViewController ()
{
    BOOL _loading;
    NSTimeInterval secondsStart, secondsEnd;
    GNQueue *queueAds; // into AdObject.
}

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (strong, nonatomic) NSMutableArray *cellDataList;
@end

static const int CELLCOUNT = 20;

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    secondsStart = [NSDate timeIntervalSinceReferenceDate];
    _cellDataList = [NSMutableArray array];
    queueAds = [[GNQueue alloc] initWithMaxSize:50];
    
    // Create GNNativeAdRequest.
    nativeAdRequest = [[GNNativeAdRequest sharedMenager] initWithID:@"YOUR_SSP_APP_ID"];
    nativeAdRequest.delegate = self;
    nativeAdRequest.GNAdlogPriority = GNLogPriorityInfo; // show log.
    nativeAdRequest.geoLocationEnable = YES;
    
    // ad loading.
    [nativeAdRequest multiLoadAds];
}

- (void)dealloc
{
    nativeAdRequest.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - GNNativeAdRequestDelegate

// Called when GNNativeAdRequest native ads request succeeded.
- (void)nativeAdRequestDidReceiveAds:(NSArray *)nativeAds
{
    secondsEnd = [NSDate timeIntervalSinceReferenceDate];
    NSLog(@"TableViewController: nativeAdRequestDidReceiveAds in %f seconds.",(double)(secondsEnd - secondsStart));
    for (GNNativeAd *nativeAd in nativeAds) {
        [queueAds enqueue:nativeAd];
    }
    [self createCellDataList];
    
}

// Called when GNNativeAdRequest native ads request failed.
- (void)nativeAdRequest:(GNNativeAdRequest *)request didFailToReceiveAdsWithError:(NSError *)error
{
    NSLog(@"TableViewController: didFailToReceiveAdsWithError : %@", [error localizedDescription]);
    
    [self createCellDataList];
}

// Sent before ad begins open landingURL in External Browser.
- (BOOL)shouldStartExternalBrowserWithClick:(GNNativeAd *)nativeAd landingURL:(NSString *)landingURL
{
    NSLog(@"TableViewController %s : %@",__FUNCTION__,landingURL);
    return YES;
}

#pragma mark - Get My Cell Data

- (void)requestCellDataListAsync
{
    _loading = YES;
}

- (void)createCellDataList
{
    for (int i = 0; i < CELLCOUNT; i++) {
        if ([queueAds count] > 0) {
            // ad object.
            id ad = [queueAds dequeue];
            [_cellDataList addObject:ad];
        } else {
            // No ad object.
            [_cellDataList addObject:[[MyCellData alloc] init]];
        }
    }
    [_indicator stopAnimating];
    [self.tableView reloadData];
    _loading = NO;
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cellDataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SampleDataCell";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.iconView.layer.borderColor = [UIColor blackColor].CGColor;
    cell.iconView.layer.borderWidth = 1;
    cell.iconView.layer.cornerRadius = 10;
    cell.iconView.layer.masksToBounds = YES;
    
    if ([[_cellDataList objectAtIndex:indexPath.row] isKindOfClass:[GNNativeAd class]]) {
        // GNNativeAd Cell.
        GNNativeAd *nativeAd = (GNNativeAd *)[_cellDataList objectAtIndex:indexPath.row];
        if (nativeAd != nil) {
            cell.nativeAd = nativeAd;
            cell.titleLabel.text = nativeAd.title;
            cell.descriptionLabel.text = nativeAd.description;
            cell.iconView.image = nil;
            NSURL *url = [NSURL URLWithString:nativeAd.icon_url];
            // NSURL *url = [NSURL URLWithString:nativeAd.screenshots_url];
            [TableViewController requestImageWithURL:url completion:^(UIImage *image, NSError *error){
                if (error) return;
                
                [cell.iconView setImage:image];
            }];
            // tracking point.
            [nativeAd trackingImpressionWithView:cell];
        }
    } else {
        // Not GNNativeAd Cell
        MyCellData *mycellData = (MyCellData *)[_cellDataList objectAtIndex:indexPath.row];
        cell.nativeAd = nil;
        cell.titleLabel.text = [mycellData.title stringByAppendingFormat:@" No.%ld",indexPath.row + 1];
        cell.descriptionLabel.text = mycellData.content;
        cell.iconView.image = nil;
        NSURL *url = mycellData.imgURL;
        
        [TableViewController requestImageWithURL:url completion:^(UIImage *image, NSError *error){
            if (error || ![url isEqual:mycellData.imgURL]) return;
            cell.iconView.image = image;
        }];
    }
    return cell;
}

#pragma mark - Scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat contentOffsetWidthWindow = self.tableView.contentOffset.y + self.tableView.bounds.size.height;
    BOOL leachToBottom = contentOffsetWidthWindow >= self.tableView.contentSize.height;
    if (!leachToBottom || _loading) return;
    [_indicator startAnimating];
    secondsStart = [NSDate timeIntervalSinceReferenceDate];
    [nativeAdRequest multiLoadAds]; // load ad.
    [self requestCellDataListAsync];
}

#pragma mark - Table View Click

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell *cell = (TableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.nativeAd != nil) {
        [cell.nativeAd trackingClick:cell];
    } else {
        [self performSegueWithIdentifier:@"selectRow" sender:self];
    }
}

#pragma mark - Request and Creqte Icon Image

+ (void)requestImageWithURL:(NSURL*)url completion:(void (^)(UIImage *image, NSError *error))completion
{
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    
    [[session dataTaskWithRequest:request
                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
                    if (error) {
                        completion(nil,error);
                        return;
                    }
                    __block UIImage *image = [UIImage imageWithData:data];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(image,nil);
                        return;
                    });
                }] resume];
}
@end
