//
//  MSPVAWKWebViewController.h
//  MediaSDK
//
//  Created by 市村 有貴江 on 2016/12/02.
//  Copyright © 2016年 市村 有貴江. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "MSActivityIndicatorView.h"

@interface MSPVAWKWebViewController : UIViewController<WKNavigationDelegate, WKUIDelegate>
{
    MSActivityIndicatorView* activityIndicator;
}
@property WKWebView* webview;
@property UIButton *closeButton;
@property UIImage *closeImage;
@property UIButton *videoEndCloseButton;
@property UIImage *videoEndCloseImage;

@property int playCount;

- (void)callJSCompletion;
- (void)setCloseButtonVisiblity;

@end
