//
//  GNAdWebviewJavascript.m
//  GNAdSDK
//

#import "GNAdWebviewJavascript.h"
@import AdSupport;

static NSString *const kGNCustomScheme = @"gnjssdkscheme";
static NSString *const kGNSpecifierCallNative = @"call_native";

@interface GNAdWebviewJavascript () {
    __weak UIWebView *_webView;
    __weak id<UIWebViewDelegate> _webViewDelegate;
    NSArray *_keywords;
}

@end

@implementation GNAdWebviewJavascript

- (id)initWithWebView:(UIWebView *)uiWebView keywords:(NSArray *)keywords {
    if ((self = [super init])) {
        _webView = uiWebView;
        _webViewDelegate = [uiWebView delegate];
        _webView.delegate = self;
        _keywords = [NSArray arrayWithArray:keywords];
    }
    return self;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    if (webView != _webView) {
        return;
    }
    __strong typeof(_webViewDelegate) strongDelegate = _webViewDelegate;
    if (strongDelegate && [strongDelegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [strongDelegate webViewDidStartLoad:webView];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (webView != _webView) {
        return;
    }

    __strong typeof(_webViewDelegate) strongDelegate = _webViewDelegate;
    if (strongDelegate && [strongDelegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [strongDelegate webViewDidFinishLoad:webView];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if (webView != _webView) {
        return;
    }

    __strong typeof(_webViewDelegate) strongDelegate = _webViewDelegate;
    if (strongDelegate &&
        [strongDelegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [strongDelegate webView:webView didFailLoadWithError:error];
    }
}

- (void)webToNativeCall {
    NSString *js = [NSString stringWithFormat:@"gnjssdk_set(%@, '%@', '%@');", ![self canTracking] ? @(true) : @(false), [self idfa], [self bundleId]];
    [_webView stringByEvaluatingJavaScriptFromString:js];
}

- (BOOL)webView:(UIWebView *)webView
    shouldStartLoadWithRequest:(NSURLRequest *)request
                navigationType:(UIWebViewNavigationType)navigationType {
    if (webView != _webView) {
        return YES;
    }

    NSURL *url = [request URL];
    NSString *urlString = [url absoluteString];

    for (NSString *keyword in _keywords) {
        if ([urlString rangeOfString:keyword].location != NSNotFound) {
            // Open by Default Browser
            [[UIApplication sharedApplication] openURL:url];
            return NO;
        }
    }

    __strong typeof(_webViewDelegate) strongDelegate = _webViewDelegate;
    if ([[url scheme] isEqualToString:kGNCustomScheme]) {
        if ([[url resourceSpecifier] isEqualToString:kGNSpecifierCallNative]) {
            [self performSelector:@selector(webToNativeCall)];
        }
        return NO;
    } else if (strongDelegate && [strongDelegate
                                     respondsToSelector:@selector(webView:
                                                            shouldStartLoadWithRequest:
                                                                        navigationType:)]) {
        return [strongDelegate webView:webView
            shouldStartLoadWithRequest:request
                        navigationType:navigationType];
    }
    return YES;
}

- (NSString *)bundleId {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
}

- (BOOL)canTracking {
    if (NSClassFromString(@"ASIdentifierManager")) {
        return [[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled];
    }
    return NO;
}

- (NSString *)idfa {
    if (NSClassFromString(@"ASIdentifierManager")) {
        return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    }
    return @"";
}

@end
