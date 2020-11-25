//
//  VideoTableViewController.m
//  GNAdSampleNativeAd
//

#import "VideoTableViewController.h"
#import "VideoTableViewCell.h"
#import "MyCellData.h"
#import "GNQueue.h"
#import <GNAdSDK/Log4GNAd.h>

@interface VideoTableViewController ()
{
    BOOL _loading;
    NSTimeInterval secondsStart, secondsEnd;
    GNQueue *queueAds;
}

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (nonatomic, strong) NSMutableArray *cellDataList;

@end

@implementation VideoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    secondsStart = [NSDate timeIntervalSinceReferenceDate];
    _cellDataList = [NSMutableArray array];
    queueAds = [[GNQueue alloc] initWithSize:100];

    // Create GNNativeAdRequest
    _nativeAdRequest = [[GNNativeAdRequest alloc] initWithID:_zoneid];
    [Log4GNAd setPriority:GNLogPriorityInfo];
    _nativeAdRequest.delegate = self;
    //_nativeAdRequest.GNAdlogPriority = GNLogPriorityInfo;
    _nativeAdRequest.geoLocationEnable = YES;
    NSRange range = [_zoneid rangeOfString:@","];
    if (range.location == NSNotFound) {
        [_nativeAdRequest loadAds];
    } else {
        [_nativeAdRequest multiLoadAds];
    }

    [self requestCellDataListAsync];
}

- (void)dealloc
{
    _nativeAdRequest.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - GNNativeAdRequestDelegate

- (void)nativeAdRequestDidReceiveAds:(NSArray*)nativeAds
{
    secondsEnd = [NSDate timeIntervalSinceReferenceDate];
    NSLog(@"TableViewController: nativeAdRequestDidReceiveAds in %f seconds.", (double)(secondsEnd - secondsStart));
    for (GNNativeAd *nativeAd in nativeAds) {
        [queueAds enqueue:nativeAd];
    }
}

- (void)nativeAdRequest:(GNNativeAdRequest *)request didFailToReceiveAdsWithError:(NSError *)error
{
    NSLog(@"TableViewController: didFailToReceiveAdsWithError : %@.", [error localizedDescription]);
}

- (BOOL)shouldStartExternalBrowserWithClick:(GNNativeAd *)nativeAd landingURL:(NSString *)landingURL
{
    NSLog(@"TableViewController: shouldStartExternalBrowserWithClick : %@.", landingURL);
    return YES;
}

#pragma mark - Get My Cell Data

- (void)requestCellDataListAsync
{
    _loading = YES;
    [self performSelector:@selector(createCellDataList) withObject:nil afterDelay:0.5];
}

- (void)createCellDataList
{
    int totalCnt = 20;
    int adCnt = [queueAds count];
    for (int i = 0; i < totalCnt; i++) {
        if ([queueAds count] > 0 &&  adCnt > 0 && totalCnt / adCnt > 0 && i % (totalCnt / adCnt) == 0) {
            id ad = [queueAds dequeue];
            [_cellDataList addObject:ad];
        } else {
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
    VideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    // Since the cell is reused, initialize it.
    if ([cell.media subviews].count == 0) {
        // add the tap event.
        [self setTaqEvent:cell];
    }
    for (UIView *view in [cell.media subviews]) {
        BOOL isVideoView = [view isKindOfClass:[GNSNativeVideoPlayerView class]];
        if (isVideoView) {
            [(GNSNativeVideoPlayerView*)view remove];
        }
        [view removeFromSuperview];
    }

    CGRect rect = CGRectMake(0, 0, cell.media.frame.size.width, cell.media.frame.size.height);
    if ([[_cellDataList objectAtIndex:indexPath.row] isKindOfClass:[GNNativeAd class]]) {
        GNNativeAd *nativeAd = (GNNativeAd *)[_cellDataList objectAtIndex:indexPath.row];
        if (nativeAd != nil) {
            cell.nativeAd = nativeAd;
            cell.title.text = (nativeAd.title) ? nativeAd.title : @"No title";
            cell.description.text = (nativeAd.description) ? nativeAd.description : @"No description";
            if ([nativeAd hasVideoContent]) {
                // For video.
                GNSNativeVideoPlayerView *videoView = [self getVideoView:rect nativeAd:nativeAd];
                [cell.media addSubview:videoView];
            } else {
                // For image.
                if (nativeAd.icon_url != nil) {
                   NSURL *nsurl = [NSURL URLWithString:nativeAd.icon_url];
                   UIImageView* imageView = [self getImageView:rect nsurl:nsurl];
                   [cell.media addSubview:imageView];
                }
            }
            [nativeAd trackingImpressionWithView:cell];
        }
    } else {
        MyCellData *myCellData = (MyCellData *)[_cellDataList objectAtIndex:indexPath.row];
        cell.nativeAd = nil;
        cell.title.text = [myCellData.title stringByAppendingFormat:@" No.%ld", indexPath.row + 1];
        cell.description.text = myCellData.content;

        UIImageView *imageView = [self getImageView:rect nsurl:myCellData.imgURL];
        [cell.media addSubview:imageView];
    }
    return cell;
}

- (void)setTaqEvent:(UIView*)view {
    // Single tap
    UITapGestureRecognizer* tapSingle = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSingle:)];
    tapSingle.numberOfTapsRequired = 1;
    tapSingle.numberOfTouchesRequired = 1;
    [view addGestureRecognizer:tapSingle];
}

- (void)tapSingle:(UITapGestureRecognizer *)sender {
    if (sender.numberOfTouches == 1) {
        VideoTableViewCell* view = (VideoTableViewCell*)sender.view;
        if (view != nil) {
            if (view.nativeAd != nil) {
                [view.nativeAd trackingClick:view];
            } else {
                [self performSegueWithIdentifier:@"selectRow" sender:self];
            }
        }
    }
}

#pragma mark - Scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat contentOffsetWidthWindow = self.tableView.contentOffset.y + self.tableView.bounds.size.height;
    BOOL leachToBottom = contentOffsetWidthWindow >= self.tableView.contentSize.height;
    if (!leachToBottom || _loading) return;
    [_indicator startAnimating];
    
    secondsStart = [NSDate timeIntervalSinceReferenceDate];
    NSRange range = [_zoneid rangeOfString:@","];
    if (range.location == NSNotFound) {
        [_nativeAdRequest loadAds];
    } else {
        [_nativeAdRequest multiLoadAds];
    }
    [self requestCellDataListAsync];
}

#pragma mark - Request and Create Icon Image/video

- (GNSNativeVideoPlayerView*)getVideoView:(CGRect)rect nativeAd:(GNNativeAd*)nativeAd {
    GNSNativeVideoPlayerView *videoView = [nativeAd getVideoView:rect];
    videoView.nativeDelegate = self;
    [videoView load];
    return videoView;
}

- (UIImageView*)getImageView:(CGRect)rect nsurl:(NSURL*)nsurl {
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:rect];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [VideoTableViewController requestImageWithURL:nsurl completion:^(UIImage *image, NSError *error) {
        if (error) return;
        imageView.image = image;
    }];
    return imageView;
}

+ (void)requestImageWithURL:(NSURL*)url completion:(void (^)(UIImage *image, NSError *error))completion
{
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionConfiguration * conf = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession * session = [NSURLSession sessionWithConfiguration:conf];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *connectionError) {
         if (connectionError) {
             completion(nil, connectionError);
             return;
         }
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
             __block UIImage *image = [UIImage imageWithData:data];
             dispatch_async(dispatch_get_main_queue(), ^{
                 completion(image, nil);
                 return;
             });
         });
    }] resume];
}

#pragma mark GNSNativeVideoPlayerDelegate Notifications

- (void)onVideoReceiveSetting:(GNSNativeVideoPlayerView*)view
{
    NSLog(@"onVideoReceiveSetting");
    [view show];
}

- (void)onVideoFailWithError:(GNSNativeVideoPlayerView*)view error:(NSError *)error
{
    NSLog(@"onVideoFailWithError cdde = %ld, %@", (long)error.code, error.description);
}

- (void)onVideoStartPlaying:(GNSNativeVideoPlayerView*)view {
    NSLog(@"onVideoStartPlaying");
}

- (void)onVideoPlayComplete:(GNSNativeVideoPlayerView*)view {
    NSLog(@"onVideoPlayComplete");
}

@end
