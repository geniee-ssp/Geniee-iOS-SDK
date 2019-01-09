//
//  SimpleViewController.m
//  GNAdSampleNativeAd
//

#import "SimpleUIButton.h"
#import "SimpleViewController.h"
#import <GNAdSDK/GNNativeAdRequest.h>
#import <GNAdSDK/GNSNativeVideoPlayerView.h>
#import <GNAdSDK/Log4GNAd.h>

// For view position.
static const NSInteger SIZE_GAP = 5;
static const NSInteger SIZE_TEXT = 25;
static const NSInteger SIZE_MEDIA = 350;

@interface SimpleViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *rootView;
@property(nonatomic, strong) GNNativeAdRequest *nativeAdRequest;

@end

@implementation SimpleViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Create GNNativeAdRequest
    _nativeAdRequest = [[GNNativeAdRequest alloc] initWithID:_zoneid];
    //[Log4GNAd setPriority:GNLogPriorityInfo];
    _nativeAdRequest.delegate = self;
    _nativeAdRequest.geoLocationEnable = YES;
    NSRange range = [_zoneid rangeOfString:@","];
    if (range.location == NSNotFound) {
        [_nativeAdRequest loadAds];
    } else {
        [_nativeAdRequest multiLoadAds];
    }
}

- (void)dealloc
{
    _nativeAdRequest.delegate = nil;
}

#pragma mark GNSNativeVideoPlayerDelegate
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

#pragma mark GNNativeAdRequestDelegate
- (void)nativeAdRequest:(GNNativeAdRequest *)request didFailToReceiveAdsWithError:(NSError *)error {
    NSLog(@"nativeAdRequest error = %@.", [error localizedDescription]);
}

- (void)nativeAdRequestDidReceiveAds:(NSArray *)nativeAds {
    NSLog(@"nativeAdRequestDidReceiveAds");
    _scrollView.contentSize = CGSizeMake(_scrollView.contentSize.width, 500*nativeAds.count);
    
    int cnt = 0;
    for (GNNativeAd *nativeAd in nativeAds) {
        [self createView:nativeAd cnt:cnt];
        cnt++;
    }
}

- (BOOL)shouldStartExternalBrowserWithClick:(GNNativeAd *)nativeAd landingURL:(NSString *)landingURL {
    return YES;
}

#pragma mark Internal.

- (void)createView:(GNNativeAd*)nativeAd cnt:(int)cnt {
    CGRect rect;
    int width = self.view.frame.size.width;
    int height = 0;

    // CellView.
    rect = CGRectMake(0, (float)(500*cnt), _rootView.frame.size.width, 500);
    UIView *cellView = [[UIView alloc] initWithFrame:rect];
    [_rootView addSubview:cellView];

    // Title.
    height = 0;
    rect = CGRectMake(0, height, width, SIZE_TEXT);
    UILabel *titleView = [[UILabel alloc] initWithFrame:rect];
    titleView.backgroundColor = UIColor.blueColor;
    titleView.text = (nativeAd.title) ? nativeAd.title : @"No title";
    titleView.textColor = UIColor.whiteColor;
    [cellView addSubview:titleView];

    // Media.
    height += SIZE_TEXT + SIZE_GAP;
    rect = CGRectMake(0, height, width, SIZE_MEDIA);
    if ([nativeAd hasVideoContent]) {
        GNSNativeVideoPlayerView* videoView = [self getVideoView:rect nativeAd:nativeAd];
        [cellView addSubview:videoView];
    } else {
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:rect];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        NSURL *nsurl = [NSURL URLWithString:nativeAd.icon_url];
        [SimpleViewController requestImageWithURL:nsurl completion:^(UIImage *image, NSError *error) {
            if (error) return;
            imageView.image = image;
        }];
        [cellView addSubview:imageView];
    }    

    // Description.
    int lineNum = 3;
    height += SIZE_MEDIA + SIZE_GAP;
    rect = CGRectMake(0, height, width, SIZE_TEXT * lineNum);
    UILabel *descriptionView = [[UILabel alloc] initWithFrame:rect];
    descriptionView.numberOfLines = lineNum;
    descriptionView.text = (nativeAd.description) ? nativeAd.description : @"No description";
    descriptionView.textColor = UIColor.blackColor;
    [descriptionView sizeToFit];
    [cellView addSubview:descriptionView];

    // Button.
    height += SIZE_TEXT * lineNum + SIZE_GAP;
    rect = CGRectMake(0, height, width, SIZE_TEXT);
    SimpleUIButton *buttonView = [SimpleUIButton buttonWithType:UIButtonTypeCustom];
    buttonView.frame = rect;
    [buttonView setTitle:@"Click" forState:UIControlStateNormal];
    [buttonView setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    buttonView.contentMode = UIViewContentModeCenter;
    [buttonView addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    buttonView.nativeAd = nativeAd;
    // button frame.
    buttonView.layer.borderColor = [UIColor blueColor].CGColor;
    buttonView.layer.borderWidth = 1;
    [cellView addSubview:buttonView];

    [nativeAd trackingImpressionWithView:cellView];
}

- (GNSNativeVideoPlayerView*)getVideoView:(CGRect)rect nativeAd:(GNNativeAd*)nativeAd {
    GNSNativeVideoPlayerView *videoView = [nativeAd getVideoView:rect];
    videoView.nativeDelegate = self;
    [videoView load];
    return videoView;
}

+ (void)requestImageWithURL:(NSURL*)url completion:(void (^)(UIImage *image, NSError *error))completion {
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

- (void)clickButton:(SimpleUIButton*)view
{
    if (view && view.nativeAd) {
        [view.nativeAd trackingClick:view];
    }
}

@end

