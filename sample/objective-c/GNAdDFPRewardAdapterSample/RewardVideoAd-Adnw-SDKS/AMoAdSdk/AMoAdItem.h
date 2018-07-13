//
//  AMoAdItem.h
//  AMoAd
//
//  Created by AMoAd on 2016/02/24.
//
//

#import <Foundation/Foundation.h>

/// 広告オブジェクト
@interface AMoAdItem : NSObject

/// アイコン画像URL
@property (nonatomic,copy) NSString *iconUrl;

/// メイン画像URL
@property (nonatomic,copy) NSString *imageUrl;

/// ショートテキスト
@property (nonatomic,copy) NSString *titleShort;

/// ロングテキスト
@property (nonatomic,copy) NSString *titleLong;

/// サービス名
@property (nonatomic,copy) NSString *serviceName;

/// 遷移先URL
@property (nonatomic,copy) NSString *link;

/// ユニット番号（広告取得数x4、キャッシュ数x2の場合、0, 1, 2, 3, 0, 1, 2, 3）
@property (nonatomic) NSInteger unitNo;

/// 広告表示時に呼び出す
/// Deprecated: VIMPが送信できないため代わりにAMoAdInfeed.setViewabilityTrackingCell:adItem:を呼ぶ
- (void)sendImpression DEPRECATED_ATTRIBUTE;

/// クリック時に呼び出す
- (void)onClick;

/// クリック時に呼び出す（カスタムURLスキームをハンドリングする）
- (void)onClickWithCustomScheme:(NSString *)scheme
                        handler:(void (^)(NSString *url))handler;

/// クリック時に呼び出す（複数のカスタムURLスキームをハンドリングする）
- (void)onClickWithCustomSchemes:(NSArray<NSString *> *)schemes
                         handler:(void (^)(NSString *url))handler;

/// クリック時に呼び出す（全てのLPへの遷移をハンドリングする）
/// Safari view controller を使う場合以外は、openURLでSafariを起動すること
- (void)onClickWithHandler:(void (^)(NSString *url))handler;


/// 開発用
+ (AMoAdItem *)parseDic:(NSDictionary *)dic;

@end
