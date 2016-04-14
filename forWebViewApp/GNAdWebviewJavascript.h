//
//  GNAdWebviewJavascript.h
//  GNAdSDK
//

#import <UIKit/UIKit.h>

#if defined(__cplusplus)
#define GNAD_EXTERN extern "C"
#else
#define GNAD_EXTERN extern
#endif

// An GNAdWebviewJavascript ad.
@interface GNAdWebviewJavascript : NSObject <UIWebViewDelegate>

#pragma mark Pre-Request

// Initializes a GNAdWebviewJavascript and sets it to the specified webview.
- (id)initWithWebView:(UIWebView *)uiWebView keywords:(NSArray *)keywords;

@end
