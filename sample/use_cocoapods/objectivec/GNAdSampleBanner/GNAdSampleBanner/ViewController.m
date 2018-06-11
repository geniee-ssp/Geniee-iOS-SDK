//
//  ViewController.m
//  GNAdSampleBanner
//
//  Created by { Kazunori } on 2018/06/10.
//  Copyright © 2018 Yamamoto Kazunori. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _adView = [[GNAdView alloc]
               initWithFrame:CGRectMake(0, 20, 320, 50) adSizeType:GNAdSizeTypeSmall
               appID:@"YOUR_SSP_APP_ID"];
    _adView.delegate = self;
    _adView.rootViewController = self;
    
    [self.view addSubview:_adView];
    _adView.center = CGPointMake(self.view.center.x, _adView.center.y);
    [_adView startAdLoop];
}

- (void)dealloc
{
    [_adView startAdLoop];
    _adView.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldStartExternalBrowserWithClick:(GNAdView *)adView landingURL:(NSString *)landingURL
{
    NSLog(@"ViewController: shouldStartExternalBrowserWithClick: %@.",landingURL);
    return YES;
}

@end
