//
//  AMoAdLogger.h
//
//  Created by AMoAd on 2014/11/17.
//
#import <Foundation/Foundation.h>

/// <p>ログを出力する</p>
/// <p>サンプルコード</p>
///    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
///      // 広告ログ設定
///      [AMoAdLogger sharedLogger].logging = YES; // ログを出力する
///      [AMoAdLogger sharedLogger].onLogging = ^(NSString *message, NSError *error) {
///        NSLog(@"【ユーザ定義】%@:%@", message, error); // ログの出力方法をカスタマイズする（オプショナル：設定しなくてもログは表示されます）
///      };
///    }
@interface AMoAdLogger : NSObject
/// SDKエラーをログ出力する（YES / NO:デフォルト）
@property (nonatomic) BOOL logging;

/// ログをNSLog以外に出力する場合、このブロックを設定する
@property (nonatomic,copy) void (^onLogging)(NSString *message, NSError *error);

/// トレース出力する（YES / NO:デフォルト）
@property (nonatomic) BOOL trace;

/// トレースをNSLog以外に出力する場合、このブロックを設定する
@property (nonatomic,copy) void (^onTrace)(NSString *message, id target);

/// ロガー・オブジェクトを取得する
+ (AMoAdLogger *)sharedLogger;

@end
