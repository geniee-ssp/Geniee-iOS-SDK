//
//  AMoAdWeb.h
//
//  Created by AMoAd on 2015/11/10.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/// <p>UIWebViewにアドタグを貼るとき以下の機能を提供する。</p>
/// 1. IDFA連携
/// 2. ダイレクトストア（ブラウザを介さずにストアへ遷移する）
@interface AMoAdWeb : NSObject

/// AMoAdWebの利用を開始する（UIWebViewオブジェクトを作る前に呼んでおく）
+ (void)prepareAd;

/// UIWebViewのデリゲートから呼び出す
/// @param webView 広告を表示しているWebView
/// @param shouldStartLoadWithRequest 呼び出すリクエスト
/// @param navigationType ナビゲーションのタイプ
/// @return BOOL YES...広告ではない、NO...広告なので shouldStartLoadWithRequest で NO を返す
+ (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;

@end
