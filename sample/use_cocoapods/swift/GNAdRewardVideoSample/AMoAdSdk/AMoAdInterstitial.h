//
//  AMoAdInterstitial.h
//
//  Created by AMoAd on 2015/07/23.
//
#import <UIKit/UIKit.h>
#import "AMoAd.h"

/// インタースティシャル広告完了状態
typedef NS_ENUM(NSInteger, AMoAdInterstitialResult) {
  /// クリックされた
  AMoAdInterstitialResultClick,
  /// 閉じるボタンが押された
  AMoAdInterstitialResultClose,
  /// インタースティシャル広告が表示中（重複して開かない）
  AMoAdInterstitialResultDuplicated,
  /// アプリから閉じられた
  AMoAdInterstitialResultCloseFromApp,
  /// 受信に失敗した
  AMoAdInterstitialResultFailure
};


/// インタースティシャル広告I/F
@interface AMoAdInterstitial : NSObject

/// インタースティシャル広告の登録を行なう
/// @param sid 管理画面から取得した64文字の英数字
+ (void)registerAdWithSid:(NSString *)sid;


/// タイムアウト時間（ミリ秒）を設定する：デフォルトは30,000ミリ秒
/// @param sid 管理画面から取得した64文字の英数字
/// @param millis タイムアウト時間（ミリ秒）
+ (void)setNetworkTimeoutWithSid:(NSString *)sid millis:(NSInteger)millis;

/// 広告面をクリックできるかどうかを設定する：デフォルトはYES -> 変更できません
/// @param sid 管理画面から取得した64文字の英数字
/// @param clickable 広告面をクリックできるかどうか
+ (void)setDisplayWithSid:(NSString *)sid clickable:(BOOL)clickable DEPRECATED_ATTRIBUTE;

/// 確認ダイアログを表示するかどうかを設定する：デフォルトはYES -> 変更できません
/// @param sid 管理画面から取得した64文字の英数字
/// @param shown 確認ダイアログを表示するかどうか
+ (void)setDialogWithSid:(NSString *)sid shown:(BOOL)shown DEPRECATED_ATTRIBUTE;

/// Portraitパネル画像（310x380で表示される）を設定する
/// @param sid 管理画面から取得した64文字の英数字
/// @param image パネル画像
+ (void)setPortraitPanelWithSid:(NSString *)sid image:(UIImage *)image;

/// Landscapeパネル画像（380x310で表示される）を設定する
/// @param sid 管理画面から取得した64文字の英数字
/// @param image パネル画像
+ (void)setLandscapePanelWithSid:(NSString *)sid image:(UIImage *)image;

/// リンクボタン画像（280x50で表示される）を設定する
/// @param sid 管理画面から取得した64文字の英数字
/// @param image リンクボタン画像
/// @param highlighted リンクボタン画像（押下時）
+ (void)setLinkButtonWithSid:(NSString *)sid image:(UIImage *)image highlighted:(UIImage *)highlighted;

/// 閉じるボタン画像（40x40で表示される）を設定する
/// @param sid 管理画面から取得した64文字の英数字
/// @param image 閉じるボタン画像
/// @param highlighted 閉じるボタン画像（押下時）
+ (void)setCloseButtonWithSid:(NSString *)sid image:(UIImage *)image highlighted:(UIImage *)highlighted;

/// showAdを呼んだ後、自動で次の広告をロード（loadAd）するかどうか：デフォルトはYES
/// @param sid 管理画面から取得した64文字の英数字
/// @param autoReload showAdを呼んだ後、自動で次の広告をロード（loadAd）するかどうか
+ (void)setAutoReloadWithSid:(NSString *)sid autoReload:(BOOL)autoReload;


/// インタースティシャル広告のロードを行なう
/// @param sid 管理画面から取得した64文字の英数字
/// @param completion 広告受信完了Block
+ (void)loadAdWithSid:(NSString *)sid completion:(void (^)(NSString *sid, AMoAdResult result, NSError *err))completion;

/// インタースティシャル広告がプリロードされているかどうかを返す
/// @param sid 管理画面から取得した64文字の英数字
/// @return インタースティシャル広告がプリロードされているかどうか
+ (BOOL)isLoadedAdWithSid:(NSString *)sid;

/// インタースティシャル広告を表示する
/// @param sid 管理画面から取得した64文字の英数字
/// @param completion インタースティシャル終了Block
+ (void)showAdWithSid:(NSString *)sid completion:(void (^)(NSString *sid, AMoAdInterstitialResult result, NSError *err))completion;

/// インタースティシャル広告を閉じる
/// @param sid 管理画面から取得した64文字の英数字
+ (void)closeAdWithSid:(NSString *)sid;

@end
