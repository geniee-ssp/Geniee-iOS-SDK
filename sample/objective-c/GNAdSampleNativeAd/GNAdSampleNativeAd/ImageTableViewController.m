//
//  ImageTableViewController.m
//  GNAdSampleNativeAd
//

#import "ImageTableViewController.h"
#import "ImageTableViewCell.h"
#import "MyCellData.h"
#import "GNQueue.h"

@interface ImageTableViewController ()
{
    BOOL _loading;
    NSTimeInterval secondsStart, secondsEnd;
    GNQueue *queueAds;
}

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (nonatomic, strong) NSMutableArray *cellDataList;

@end

@implementation ImageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    secondsStart = [NSDate timeIntervalSinceReferenceDate];
    _cellDataList = [NSMutableArray array];
    queueAds = [[GNQueue alloc] initWithSize:100];
    
    // Create GNNativeAdRequest
    _nativeAdRequest = [[GNNativeAdRequest alloc] initWithID:_zoneid];
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
    NSRange range = [_zoneid rangeOfString:@","];
    if (range.location == NSNotFound) {
        [_nativeAdRequest loadAds];
    } else {
        [_nativeAdRequest multiLoadAds];
    }
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
        // You can identify the GNNativeAd by using the zoneID field of GNNativeAd.
        //if ([nativeAd.zoneID isEqualToString:@"YOUR_ZONE_ID"]) {
        //    [_cellDataList addObject:nativeAd];
        //}
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
    ImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if ([[_cellDataList objectAtIndex:indexPath.row] isKindOfClass:[GNNativeAd class]]) {
        GNNativeAd *nativeAd = (GNNativeAd *)[_cellDataList objectAtIndex:indexPath.row];
        if (nativeAd != nil) {
            cell.nativeAd = nativeAd;
            cell.title.text = (nativeAd.title) ? nativeAd.title : @"No title";
            cell.description.text = (nativeAd.description) ? nativeAd.description : @"No description";
            cell.icon.image = nil;
            if (nativeAd.icon_url != nil) {
                NSURL *url = [NSURL URLWithString:nativeAd.icon_url];
                [ImageTableViewController requestImageWithURL:url completion:^(UIImage *image, NSError *error) {
                    if (error) return;
                    cell.icon.image = image;
                }];
            }
            [nativeAd trackingImpressionWithView:cell];
        }
    } else {
        MyCellData *myCellData = (MyCellData *)[_cellDataList objectAtIndex:indexPath.row];
        cell.nativeAd = nil;
        cell.title.text = [myCellData.title stringByAppendingFormat:@" No.%ld", indexPath.row + 1];
        cell.description.text = myCellData.content;
        cell.icon.image = nil;
        NSURL *url = myCellData.imgURL;
        [ImageTableViewController requestImageWithURL:url completion:^(UIImage *image, NSError *error) {
            if (error || ![url isEqual:myCellData.imgURL]) return;
            cell.icon.image = image;
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
    [_nativeAdRequest loadAds];
    [self requestCellDataListAsync];
}

#pragma mark - Table View Click

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ImageTableViewCell *cell = (ImageTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.nativeAd != nil) {
        [cell.nativeAd trackingClick:cell];
    } else {
        [self performSegueWithIdentifier:@"selectRow" sender:self];
    }
}

#pragma mark - Request and Create Icon Image

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
             image = [ImageTableViewController createIconImageWithImage:image];
             dispatch_async(dispatch_get_main_queue(), ^{
                 completion(image, nil);
                 return;
             });
         });
    }] resume];
}

+ (UIImage*)createIconImageWithImage:(UIImage*)image
{
    return [self roundedImageWithImage:[self resizedImageWithImage:image maxPixel:100]
                          cornerRadius:10.0
                           borderWidth:1.0];
}

+ (UIImage*)resizedImageWithImage:(UIImage*)image maxPixel:(uint)maxPixel
{
    CGFloat w = image.size.width;
    CGFloat h = image.size.height;
    
    if (w == 0 || h == 0) return nil;
    
    double ratio = (float)w / h;
    bool resized = NO;
    
    if (1 < ratio) {
        if (maxPixel < w) {
            w = maxPixel;
            h = (int)(w / ratio);
            resized = YES;
        }
    } else {
        if (maxPixel < h) {
            h = maxPixel;
            w = (int)(h * ratio);
            resized = YES;
        }
    }
    
    CGContextRef context;
    
    UIGraphicsBeginImageContext(CGSizeMake(w, h));
    context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, 0);
    CGContextRotateCTM(context, 0);
    
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    [image drawInRect:CGRectMake(0, 0, w, h)];
    UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}

+ (UIImage*)roundedImageWithImage:(UIImage*)image
                     cornerRadius:(CGFloat)cornerRadius
                      borderWidth:(CGFloat)borderWidth
{
    const CGFloat maxCornerSize = MIN(image.size.width, image.size.height) * 0.5;
    if (cornerRadius > maxCornerSize) {
        cornerRadius = maxCornerSize;
    }
    
    const CGFloat h = image.size.height;
    const CGFloat w = image.size.width;
    CGImageRef cimage = image.CGImage;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h,
                                                 CGImageGetBitsPerComponent(cimage),
                                                 CGImageGetBitsPerComponent(cimage) * 4 * w,
                                                 colorSpace,
                                                 kCGBitmapAlphaInfoMask & kCGImageAlphaNoneSkipLast);
    CGColorSpaceRelease(colorSpace);
    
    // Fill background with white color
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextFillRect(context, CGRectMake(0, 0, w, h));
    
    [self addRoundedCornerPathWithContext:context width:w height:h cornerRadius:cornerRadius];
    CGContextClip(context);
    
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), cimage);
    
    [self addRoundedCornerPathWithContext:context width:w height:h cornerRadius:cornerRadius];
    CGContextSetRGBStrokeColor(context, 0, 0, 0, 1.0);
    CGContextSetLineWidth(context, borderWidth);
    CGContextStrokePath(context);
    
    CGImageRef clippedImage = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    UIImage *roundedImage = [UIImage imageWithCGImage:clippedImage];
    CGImageRelease(clippedImage);
    return roundedImage;
}

+ (void)addRoundedCornerPathWithContext:(CGContextRef)context width:(CGFloat)w height:(CGFloat)h cornerRadius:(CGFloat)r
{
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, r);
    CGContextAddArcToPoint(context, 0, h, r, h, r);
    CGContextAddArcToPoint(context, w, h, w, h-r, r);
    CGContextAddArcToPoint(context, w, 0, w-r, 0, r);
    CGContextAddArcToPoint(context, 0, 0, 0, r, r);
    CGContextClosePath(context);
}

@end

