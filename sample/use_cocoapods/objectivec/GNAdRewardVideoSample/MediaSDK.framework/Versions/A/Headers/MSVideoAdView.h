//
//  MSVideoAdView.h
//  MediaSDK
//
//  Created by 市村 有貴江 on 2017/08/22.
//  Copyright © 2017年 市村 有貴江. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVPlayer.h>
#import <AVFoundation/AVFoundation.h>

@class MSButton;
@class MSView;

@protocol MSVideoAdViewDelegate <NSObject>

@required

- (void) onPlayStart;
- (void) onPlayEnd;
- (void) onFailedToPlay;
- (void) onAdClick;

@end


@class MSTimerUtil;
@class MSAVPlayerView;
@class MSVideoAdInfo;

@interface MSVideoAdView : UIView
{
    Float64 current;
    Float64 duration;
    id timeObserver;
    bool videoPlaying;
    UIButton *volumeButton;
    UIImage *volumeImage;
    __weak id<MSVideoAdViewDelegate> delegate;
    int progressTrackingIndex;
    UIImageView *endcardImageView;
    UIImage *endcardImage;
    MSTimerUtil* timerUtil;
    AVPlayerItem* playerItem;
    UITapGestureRecognizer *tapGesture;
}

@property (nonatomic, strong) MSAVPlayerView *playerView;
@property (nonatomic, strong) AVPlayer *player;
@property MSVideoAdInfo* videoAdInfo;
@property bool mute;
@property bool volumeButtonVisiblity;
@property MSView* progressBarBase;
@property MSView* progressBar;
@property UILabel *progressText;
@property MSButton *playingInstallButton;
@property MSButton *playedInstallButton;

- (void)destroy ;
- (void)videoPlay;
- (void)showVideoContents;
- (bool)getVideoPlaying;
- (void)setDelegate:(id<MSVideoAdViewDelegate>)d;
- (void)resetPlayerSize:(CGRect)rect;


@end
