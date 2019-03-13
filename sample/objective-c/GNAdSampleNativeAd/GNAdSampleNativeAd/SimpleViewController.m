//
//  SimpleViewController.m
//  GNAdSampleNativeAd
//

#import "SimpleUIButton.h"
#import "SimpleViewController.h"
#import <GNAdSDK/GNNativeAdRequest.h>
#import <GNAdSDK/GNSNativeVideoPlayerView.h>
#import <GNAdSDK/Log4GNAd.h>

// When you enable the following macros, the log of the movie festival time is output.
//#define TEST_LOG_VIDEO_TIME

// For view position.
static const NSInteger SIZE_CELL = 600;
static const NSInteger SIZE_GAP = 5;
static const NSInteger SIZE_TEXT = 25;
static const NSInteger SIZE_MEDIA = 350;

@interface SimpleViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *rootView;
@property(nonatomic, strong) GNNativeAdRequest *nativeAdRequest;
#ifdef TEST_LOG_VIDEO_TIME
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, retain) NSMutableArray *viewAry;
#endif

@end

@implementation SimpleViewController

- (void)viewDidLoad {
    [super viewDidLoad];

#ifdef TEST_LOG_VIDEO_TIME
    _viewAry = [NSMutableArray array];
#endif
    // Create GNNativeAdRequest
    _nativeAdRequest = [[GNNativeAdRequest alloc] initWithID:_zoneid];
    [Log4GNAd setPriority:GNLogPriorityInfo];
    _nativeAdRequest.delegate = self;
    _nativeAdRequest.geoLocationEnable = YES;
    NSRange range = [_zoneid rangeOfString:@","];
    if (range.location == NSNotFound) {
        [_nativeAdRequest loadAds];
    } else {
        [_nativeAdRequest multiLoadAds];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (![self.navigationController.viewControllers containsObject:self]) {
        // Pushed back.
#ifdef TEST_LOG_VIDEO_TIME
        [self forceStopOutputLogTimer];
#endif
    }
    [super viewWillDisappear:animated];
}

- (void)dealloc
{
    _nativeAdRequest.delegate = nil;
#ifdef TEST_LOG_VIDEO_TIME
    [self forceStopOutputLogTimer];
#endif
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
#ifdef TEST_LOG_VIDEO_TIME
    [self requestStartOutputLogTimer:view];
#endif
}

- (void)onVideoPlayComplete:(GNSNativeVideoPlayerView*)view {
    NSLog(@"onVideoPlayComplete");
#ifdef TEST_LOG_VIDEO_TIME
    [self requestStopOutputLogTimer:view];
#endif
}

#pragma mark GNNativeAdRequestDelegate
- (void)nativeAdRequest:(GNNativeAdRequest *)request didFailToReceiveAdsWithError:(NSError *)error {
    NSLog(@"nativeAdRequest error = %@.", [error localizedDescription]);
}

- (void)nativeAdRequestDidReceiveAds:(NSArray *)nativeAds {
    NSLog(@"nativeAdRequestDidReceiveAds");
    _scrollView.contentSize = CGSizeMake(_scrollView.contentSize.width, SIZE_CELL*nativeAds.count);
    
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
    rect = CGRectMake(0, (float)(SIZE_CELL*cnt), _rootView.frame.size.width, SIZE_CELL);
    UIView *cellView = [[UIView alloc] initWithFrame:rect];
    [_rootView addSubview:cellView];

    // TitleLine.
    height = 0;
    rect = CGRectMake(0, height, width, SIZE_TEXT);
    UIStackView *titleLineView = [[UIStackView alloc] initWithFrame:rect];
    titleLineView.axis = UILayoutConstraintAxisHorizontal;
    [cellView addSubview:titleLineView];

    // Icon.
    rect = CGRectMake(0, height, SIZE_TEXT, SIZE_TEXT);
    UIImageView* iconView = [[UIImageView alloc] initWithFrame:rect];
    iconView.backgroundColor = UIColor.blueColor;
    iconView.contentMode = UIViewContentModeScaleAspectFit;
    NSURL *iconNsurl = [NSURL URLWithString:nativeAd.icon_url];
    if (iconNsurl) {
        [SimpleViewController requestImageWithURL:iconNsurl completion:^(UIImage *image, NSError *error) {
            if (error) {
                return;
            }
            iconView.image = image;
            iconView.center = CGPointMake(SIZE_TEXT / 2, SIZE_TEXT / 2);
        }];
    }
    [titleLineView addSubview:iconView];
    
    // Title.
    rect = CGRectMake(SIZE_TEXT, height, (width - SIZE_TEXT), SIZE_TEXT);
    UILabel *titleView = [[UILabel alloc] initWithFrame:rect];
    titleView.backgroundColor = UIColor.blueColor;
    titleView.text = (nativeAd.title) ? nativeAd.title : @"No title";
    titleView.textColor = UIColor.whiteColor;
    [titleLineView addSubview:titleView];

    // Media.
    height = SIZE_TEXT + SIZE_GAP;
    rect = CGRectMake(0, height, width, SIZE_MEDIA);
    if ([nativeAd hasVideoContent]) {
        GNSNativeVideoPlayerView* videoView = [self getVideoView:rect nativeAd:nativeAd];
        videoView.backgroundColor = UIColor.grayColor;
        [cellView addSubview:videoView];
    } else {
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:rect];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.backgroundColor = UIColor.grayColor;
        NSString* url = (nativeAd.screenshots_url) ? nativeAd.screenshots_url : nativeAd.icon_url;
        NSURL *nsurl = [NSURL URLWithString:url];
        [SimpleViewController requestImageWithURL:nsurl completion:^(UIImage *image, NSError *error) {
            if (error) {
                return;
            }
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

    // Advertiser.
    height += SIZE_TEXT * lineNum + SIZE_GAP;
    rect = CGRectMake(0, height, width, SIZE_TEXT);
    UILabel *advertiserView = [[UILabel alloc] initWithFrame:rect];
    NSString *advertiserStr = (nativeAd.advertiser) ? nativeAd.advertiser : @"No advertiser";
    advertiserStr = [NSString stringWithFormat:@"Advertiser:%@",advertiserStr];
    advertiserView.text = advertiserStr;
    advertiserView.font = [UIFont systemFontOfSize:12];
    [advertiserView setTextAlignment:NSTextAlignmentRight];
    advertiserView.textColor = UIColor.blackColor;
    [cellView addSubview:advertiserView];

    // Button.
    height += SIZE_TEXT + SIZE_GAP;
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

    // Optout.
    height += SIZE_TEXT + SIZE_GAP;
    rect = CGRectMake(0, height, width, SIZE_TEXT);
    SimpleUIButton *optoutView = [SimpleUIButton buttonWithType:UIButtonTypeCustom];
    optoutView.frame = rect;
    NSString *optoutStr = (nativeAd.optout_text) ? nativeAd.optout_text : @"No optout";
    optoutStr = [NSString stringWithFormat:@"Optout:%@",optoutStr];
    [optoutView setTitle:optoutStr forState:UIControlStateNormal];
    optoutView.titleLabel.font = [UIFont systemFontOfSize:12];
    UIColor* optoutColor = (nativeAd.optout_url) ? [UIColor blueColor] : [UIColor blackColor];
    [optoutView setTitleColor:optoutColor forState:UIControlStateNormal];
    [optoutView addTarget:self action:@selector(optoutButton:) forControlEvents:UIControlEventTouchUpInside];
    CGSize fitSize = [optoutView sizeThatFits:CGSizeMake(width, SIZE_TEXT)];
    rect = CGRectMake((width - fitSize.width), height, fitSize.width, SIZE_TEXT);
    optoutView.frame = rect;
    optoutView.nativeAd = nativeAd;
    [cellView addSubview:optoutView];

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

- (void)optoutButton:(SimpleUIButton*)view
{
    if (view && view.nativeAd && view.nativeAd.optout_url) {
        NSURL* url = [NSURL URLWithString:view.nativeAd.optout_url];
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)clickButton:(SimpleUIButton*)view
{
    if (view && view.nativeAd) {
        [view.nativeAd trackingClick:view];
    }
}

#ifdef TEST_LOG_VIDEO_TIME
- (NSString*)getPlayingTime:(GNSNativeVideoPlayerView*)videoView {
    float playTime = [videoView getCurrentposition];
    float durationTime = [videoView getDuration];
    NSString* str = [NSString stringWithFormat:@"%f / %f", playTime, durationTime];
    return str;
}

- (void)requestStartOutputLogTimer:(GNSNativeVideoPlayerView*)view {
    dispatch_async(
                   dispatch_get_main_queue(),
                   ^{
                       [self->_viewAry addObject:view];
                       if (![self->_timer isValid]) {
                           
                           self->_timer = [NSTimer timerWithTimeInterval:1.0f
                                                                  target:self
                                                                selector:@selector(outputLogForPlayTime:)
                                                                userInfo:nil
                                                                 repeats:YES];
                           [[NSRunLoop currentRunLoop] addTimer:self->_timer forMode:NSRunLoopCommonModes];
                       }
                   }
                   );
}

- (void)requestStopOutputLogTimer:(GNSNativeVideoPlayerView*)view {
    [_viewAry removeObject:view];
    if ([_viewAry count] <= 0) {
        [self forceStopOutputLogTimer];
    }
}

- (void)forceStopOutputLogTimer {
    if ([_timer isValid]) {
        [_timer invalidate];
    }
    _timer = nil;
}

-(void)outputLogForPlayTime:(NSTimer*)timer {
    for(int i = 0; i < [_viewAry count]; i++){
        GNSNativeVideoPlayerView* videoView = [_viewAry objectAtIndex:i];
        NSLog(@"outputLogForPlayTime = [%@]",[self getPlayingTime:videoView]);
    }
}
#endif

@end

