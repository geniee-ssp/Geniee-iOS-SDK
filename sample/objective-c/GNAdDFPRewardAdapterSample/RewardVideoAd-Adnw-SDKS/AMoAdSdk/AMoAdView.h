//
//  AMoAdView.h (ARC)
//  AMoAd
//
#import <UIKit/UIKit.h>
@class AMoAdView;

/// 広告サイズ
typedef NS_ENUM(NSInteger, AMoAdBannerSize) {
  AMoAdBannerSizeB320x50 = 0,
  AMoAdBannerSizeB320x100 = 1,
  AMoAdBannerSizeB300x250 = 2,
  AMoAdBannerSizeB728x90 = 3,
  AMoAdBannerSizeB300x100 = 4,
};

/// 水平方向の広告表示位置
typedef NS_ENUM(NSInteger, AMoAdHorizontalAlign) {
  AMoAdHorizontalAlignNone = 0,
  AMoAdHorizontalAlignLeft = 1,
  AMoAdHorizontalAlignCenter = 2,
  AMoAdHorizontalAlignRight = 3,
};

/// 垂直方向の広告表示位置
typedef NS_ENUM(NSInteger, AMoAdVerticalAlign) {
  AMoAdVerticalAlignNone = 0,
  AMoAdVerticalAlignTop = 1,
  AMoAdVerticalAlignMiddle = 2,
  AMoAdVerticalAlignBottom = 3,
};

/// 広告サイズの調整
typedef NS_ENUM(NSInteger, AMoAdAdjustMode) {
  AMoAdAdjustModeFixed = 0,
  AMoAdAdjustModeResponsive = 1,
};

/// ローテーション時トランジション
typedef NS_ENUM(NSInteger, AMoAdRotateTransition) {
  /// トランジション「なし」
  AMoAdRotateTransitionNone = UIViewAnimationTransitionNone,
  /// トランジション「左フリップ」
  AMoAdRotateTransitionFlipFromLeft = UIViewAnimationTransitionFlipFromLeft,
  /// トランジション「右フリップ」
  AMoAdRotateTransitionFlipFromRight = UIViewAnimationTransitionFlipFromRight,
  /// トランジション「巻き上げ」
  AMoAdRotateTransitionCurlUp = UIViewAnimationTransitionCurlUp,
  /// トランジション「巻き下げ」
  AMoAdRotateTransitionCurlDown = UIViewAnimationTransitionCurlDown,
};

/// クリック時トランジション
typedef NS_ENUM(NSInteger, AMoAdClickTransition) {
  /// トランジション「なし」
  AMoAdClickTransitionNone = 0,
  /// トランジション「ジャンプ」
  AMoAdClickTransitionJump = 1,
};


/// AMoAdViewデリゲートプロトコル
@protocol AMoAdViewDelegate
@optional
/// 正常に広告を受信した
- (void)AMoAdViewDidReceiveAd:(AMoAdView *)amoadView;
/// 広告の取得に失敗した
- (void)AMoAdViewDidFailToReceiveAd:(AMoAdView *)amoadView error:(NSError *)error;
/// 空の広告を受信した
- (void)AMoAdViewDidReceiveEmptyAd:(AMoAdView *)amoadView;
/// 広告がクリックされた
- (void)AMoAdViewDidClick:(AMoAdView *)amoadView;
/// 広告がクリックされた後、戻ってくる
- (void)AMoAdViewWillClickBack:(AMoAdView *)amoadView;
/// 広告がクリックされた後、戻ってきた
- (void)AMoAdViewDidClickBack:(AMoAdView *)amoadView;
@end


/// 広告を表示するViewクラス
@interface AMoAdView : UIImageView

/// AMoAd Webサイトで発行されるID（必須）
@property (nonatomic,copy) NSString *sid;

/// デリゲート
@property (nonatomic,weak) id delegate;

/// ローテーション時トランジション
@property (nonatomic) AMoAdRotateTransition rotateTransition;

/// クリック時トランジション
@property (nonatomic) AMoAdClickTransition clickTransition;

/// 水平方向の広告表示位置
@property (nonatomic) AMoAdHorizontalAlign horizontalAlign;

/// 垂直方向の広告表示位置
@property (nonatomic) AMoAdVerticalAlign verticalAlign;

/// 広告サイズの調整
@property (nonatomic) AMoAdAdjustMode adjustMode;

/// タイムアウト時間（ミリ秒）を設定する：デフォルトは30,000ミリ秒
@property (nonatomic) NSInteger networkTimeoutMillis;


/// フレームを指定して初期化する
- (instancetype)initWithFrame:(CGRect)frame NS_DESIGNATED_INITIALIZER;

/// 初期表示画像・ハイライト画像を指定して初期化する
- (instancetype)initWithImage:(UIImage *)image
             highlightedImage:(UIImage *)highlightedImage
                   adjustMode:(AMoAdAdjustMode)adjustMode NS_DESIGNATED_INITIALIZER;

/// Xib/storyboardから初期化時に呼ばれる
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;

/// CGRectZeroで初期化する
- (instancetype)init;

/// 初期表示画像を指定して初期化する
- (instancetype)initWithImage:(UIImage *)image
                   adjustMode:(AMoAdAdjustMode)adjustMode;

/// 初期表示画像を指定して初期化する（広告サイズ調整：固定）
- (instancetype)initWithImage:(UIImage *)image;

/// 初期表示画像・ハイライト画像を指定して初期化する（広告サイズ調整：固定）
- (instancetype)initWithImage:(UIImage *)image
             highlightedImage:(UIImage *)highlightedImage;


/// 広告を表示する
- (void)show;

/// 広告を非表示にする
- (void)hide;


/// クリック時にカスタムURLスキームをハンドリングする
- (void)setClickCustomScheme:(NSString *)scheme
                     handler:(void (^)(NSString *url))handler;

/// クリック時に複数のカスタムURLスキームをハンドリングする
- (void)setClickCustomSchemes:(NSArray<NSString *> *)schemes
                      handler:(void (^)(NSString *url))handler;

/// クリック時に全てのLPへの遷移をハンドリングする
/// Safari view controller を使う場合以外は、openURLでSafariを起動すること
- (void)setClickCustomHandler:(void (^)(NSString *url))handler;


+ (CGSize)sizeWithBannerSize:(AMoAdBannerSize)bannerSize;
+ (CGSize)sizeWithBannerSize:(AMoAdBannerSize)bannerSize adjustMode:(AMoAdAdjustMode)adjustMode;

/// 開発用
+ (void)setEnvStaging:(BOOL)staging;

// 非推奨のメソッド
- (instancetype)initWithSid:(NSString *)sid bannerSize:(AMoAdBannerSize)bannerSize hAlign:(AMoAdHorizontalAlign)hAlign vAlign:(AMoAdVerticalAlign)vAlign adjustMode:(AMoAdAdjustMode)adjustMode delegate:(id)delegate DEPRECATED_ATTRIBUTE;
- (instancetype)initWithSid:(NSString *)sid bannerSize:(AMoAdBannerSize)bannerSize hAlign:(AMoAdHorizontalAlign)hAlign vAlign:(AMoAdVerticalAlign)vAlign adjustMode:(AMoAdAdjustMode)adjustMode x:(CGFloat)x y:(CGFloat)y delegate:(id)delegate DEPRECATED_ATTRIBUTE;

/// サポート外のメソッド
- (instancetype)initWithSid:(NSString *)sid bannerSize:(AMoAdBannerSize)bannerSize hAlign:(AMoAdHorizontalAlign)hAlign vAlign:(AMoAdVerticalAlign)vAlign adjustMode:(AMoAdAdjustMode)adjustMode __attribute__((unavailable("This method is not available.")));
- (instancetype)initWithSid:(NSString *)sid bannerSize:(AMoAdBannerSize)bannerSize hAlign:(AMoAdHorizontalAlign)hAlign vAlign:(AMoAdVerticalAlign)vAlign adjustMode:(AMoAdAdjustMode)adjustMode x:(CGFloat)x y:(CGFloat)y __attribute__((unavailable("This method is not available.")));

@end
