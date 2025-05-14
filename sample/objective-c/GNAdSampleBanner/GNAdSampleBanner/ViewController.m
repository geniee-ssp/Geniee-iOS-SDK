//
//  ViewController.m
//  GNAdSampleBanner
//

#import "ViewController.h"

@interface ViewController () <GNAdViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _adViews = [[NSMutableArray alloc] init]; // Initialize the array to hold ad views
    
    // Initialize the scroll view
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_scrollView];
    
    // List of ad sizes you want to display
    NSArray *adSizes = @[
//        @(GNAdSizeTypeXSmall),   // 320x48
        @(GNAdSizeTypeSmall),    // 320x50
//        @(GNAdSizeTypeTall),     // 300x250
//        @(GNAdSizeTypeLarge),    // 728x90
//        @(GNAdSizeTypeW468H60),  // 468x60
//        @(GNAdSizeTypeW120H600), // 120x600
//        @(GNAdSizeTypeW160H600), // 160x600
//        @(GNAdSizeTypeW320H100), // 320x100
//        @(GNAdSizeTypeW57H57),   // 57x57
//        @(GNAdSizeTypeW76H76),   // 76x76
//        @(GNAdSizeTypeW480H32),  // 480x32
//        @(GNAdSizeTypeW768H66),  // 768x66
//        @(GNAdSizeTypeW1024H66), // 1024x66
    ];
    
    // Loop through each size and create a corresponding ad view
    CGFloat yOffset = 20; // Starting Y position to place the first ad
    for (NSNumber *adSizeType in adSizes) {
        GNAdSizeType adSize = (GNAdSizeType)[adSizeType integerValue];
        
        // Create a label to display the ad size
        UILabel *sizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, yOffset, self.view.bounds.size.width, 30)]; // Fixed height for label
        sizeLabel.text = [NSString stringWithFormat:@"%dx%d", (int)[self widthForAdSize:adSize], (int)[self heightForAdSize:adSize]];
        sizeLabel.textAlignment = NSTextAlignmentCenter;
        sizeLabel.textColor = [UIColor blackColor];
        sizeLabel.font = [UIFont boldSystemFontOfSize:20];
        [_scrollView addSubview:sizeLabel]; // Add the label above the ad view
        
        // Update the yOffset for the next item
        yOffset += sizeLabel.bounds.size.height + 10; // 10 for spacing between label and ad view
        
        // Initialize ad view with the current ad size
        
        GNAdView *adView;
        
        if (adSize == GNAdSizeTypeSmall) {
            adView = [[GNAdView alloc] initWithAdSizeType:adSize appID:@"1013996"];
        } else {
            adView = [[GNAdView alloc] initWithAdSizeType:adSize appID:@"1022383"];
        }
        
        
        adView.delegate = self;
        adView.rootViewController = self;
        
        // Set the frame (position and size) of the ad view
        CGRect adFrame = CGRectMake(0, yOffset, self.view.bounds.size.width, [self heightForAdSize:adSize]);
        adView.frame = adFrame;
//        
//        adView.layer.borderWidth = 2.0f;
//        adView.layer.borderColor = [UIColor redColor].CGColor;
//        adView.layer.masksToBounds = YES;
        
        // Add the ad view to the scroll view
        [_scrollView addSubview:adView];
        
        // Start the ad loop for this ad view
        [adView startAdLoop];
        
        // Add the ad view to the array for later management
        [_adViews addObject:adView];
        
        // Update the Y offset for the next ad view
        yOffset += adView.bounds.size.height + 20; // Add 20 for spacing between ads
    }
    
    // Set content size for the scroll view to allow scrolling
    _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, yOffset);
}

- (void)dealloc {
    for (GNAdView *adView in _adViews) {
        [adView stopAdLoop];
        adView.delegate = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldStartExternalBrowserWithClick:(GNAdView *)gnAdView landingURL:(NSString *)landingURL {
    NSLog(@"ViewController: shouldStartExternalBrowserWithClick : %@.", landingURL);
    return YES;
}

#pragma GNAdViewDelegate

- (void)adViewDidReceiveAd:(GNAdView *)adView {
    NSLog(@"LongUni adViewDidReceiveAd");
}

- (void)adView:(GNAdView *)adView didFailReceiveAdWithError:(NSError *)error {
    NSLog(@"LongUni didFailReceiveAdWithError: %@", error);
}

- (void)adViewDidHide:(GNAdView *)adView {
    NSLog(@"LongUni adViewDidHide");
}

- (CGFloat)heightForAdSize:(GNAdSizeType)adSize {
    switch (adSize) {
        case GNAdSizeTypeXSmall:
            return 48;  // 320x48
        case GNAdSizeTypeSmall:
            return 50;  // 320x50
        case GNAdSizeTypeTall:
            return 250; // 300x250
        case GNAdSizeTypeLarge:
            return 90;  // 728x90
        case GNAdSizeTypeW468H60:
            return 60;  // 468x60
        case GNAdSizeTypeW120H600:
            return 600; // 120x600
        case GNAdSizeTypeW160H600:
            return 600; // 160x600
        case GNAdSizeTypeW320H100:
            return 100; // 320x100
        case GNAdSizeTypeW57H57:
            return 57;  // 57x57
        case GNAdSizeTypeW76H76:
            return 76;  // 76x76
        case GNAdSizeTypeW480H32:
            return 32;  // 480x32
        case GNAdSizeTypeW768H66:
            return 66;  // 768x66
        case GNAdSizeTypeW1024H66:
            return 66;  // 1024x66
        default:
            return 50;  // Default height
    }
}


- (CGFloat)widthForAdSize:(GNAdSizeType)adSize {
    switch (adSize) {
        case GNAdSizeTypeXSmall:
            return 320;  // 320x48
        case GNAdSizeTypeSmall:
            return 320;  // 320x50
        case GNAdSizeTypeTall:
            return 300;  // 300x250
        case GNAdSizeTypeLarge:
            return 728;  // 728x90
        case GNAdSizeTypeW468H60:
            return 468;  // 468x60
        case GNAdSizeTypeW120H600:
            return 120;  // 120x600
        case GNAdSizeTypeW160H600:
            return 160;  // 160x600
        case GNAdSizeTypeW320H100:
            return 320;  // 320x100
        case GNAdSizeTypeW57H57:
            return 57;   // 57x57
        case GNAdSizeTypeW76H76:
            return 76;   // 76x76
        case GNAdSizeTypeW480H32:
            return 480;  // 480x32
        case GNAdSizeTypeW768H66:
            return 768;  // 768x66
        case GNAdSizeTypeW1024H66:
            return 1024; // 1024x66
        default:
            return 320;  // Default width
    }
}


@end
