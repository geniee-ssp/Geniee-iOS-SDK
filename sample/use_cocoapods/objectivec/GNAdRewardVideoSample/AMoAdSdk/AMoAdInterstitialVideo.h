//
//  AMoAdInterstitialVideo.h
//  AMoAd
//
//  Created by AMoAd on 08/12/2017.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "AMoAd.h"

@class AMoAdInterstitialVideo;

@protocol AMoAdInterstitialVideoDelegate <NSObject>
@optional
/// 広告のロードが完了した
- (void)amoadInterstitialVideo:(AMoAdInterstitialVideo *)amoadInterstitialVideo didLoadAd:(AMoAdResult)result;
/// 動画の再生を開始した
- (void)amoadInterstitialVideoDidStart:(AMoAdInterstitialVideo *)amoadInterstitialVideo;
/// 動画を最後まで再生完了した
- (void)amoadInterstitialVideoDidComplete:(AMoAdInterstitialVideo *)amoadInterstitialVideo;
/// 動画の再生に失敗した
- (void)amoadInterstitialVideoDidFailToPlay:(AMoAdInterstitialVideo *)amoadInterstitialVideo NS_SWIFT_NAME(amoadInterstitialVideoDidFailToPlay(_:));
/// 広告を表示した
- (void)amoadInterstitialVideoDidShow:(AMoAdInterstitialVideo *)amoadInterstitialVideo;
/// 広告を閉じた
- (void)amoadInterstitialVideoWillDismiss:(AMoAdInterstitialVideo *)amoadInterstitialVideo;
/// 広告をクリックした
- (void)amoadInterstitialVideoDidClickAd:(AMoAdInterstitialVideo *)amoadInterstitialVideo;
@end

/// インタースティシャル動画広告
@interface AMoAdInterstitialVideo: NSObject

@property (nonatomic, weak) id<AMoAdInterstitialVideoDelegate> delegate;

/// 広告のロードが完了していれば YES
@property (nonatomic, readonly, getter=isLoaded) BOOL loaded;
/// 動画の再生中にユーザが×ボタンをタップして広告を閉じることを許可するか
@property (nonatomic, getter=isCancellable) BOOL cancellable;

+ (instancetype)sharedInstanceWithSid:(NSString *)sid tag:(NSString *)tag;
- (instancetype)init NS_UNAVAILABLE;

/// 広告をロードする
- (void)load;
/// 広告を表示する
- (void)show;
/// 広告を閉じる
- (void)dismiss;

@end
