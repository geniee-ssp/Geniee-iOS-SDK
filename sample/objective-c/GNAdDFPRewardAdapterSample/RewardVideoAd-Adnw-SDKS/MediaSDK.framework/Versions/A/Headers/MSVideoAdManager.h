//
//  MSVideoAd.h
//  MediaSDK
//
//  Created by 市村 有貴江 on 2017/08/22.
//  Copyright © 2017年 市村 有貴江. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSVideoAdView.h"

@class DownloadManager;
@class MSVideoAdManager;
@class MSVideoAdInfo;

@protocol MSVideoAdDelegate <NSObject>

@optional

- (void) onReadyToPlayAd:(MSVideoAdManager*)msVideoAdManager;
- (void) onFailedToReceiveAd:(MSVideoAdManager*)msVideoAdManager;
- (void) onPlayStart:(MSVideoAdManager*)msVideoAdManager;
- (void) onPlayEnd:(MSVideoAdManager*)msVideoAdManager;
- (void) onAdClick:(MSVideoAdManager*)msVideoAdManager;
- (void) onFailedToPlay:(MSVideoAdManager*)msVideoAdManager;

@end

@interface MSVideoAdManager : UIView<MSVideoAdViewDelegate> {
    NSMutableArray<MSVideoAdInfo*>* videoAdArray;
    int videoAdInfoIndex;
    DownloadManager* downloadManager;
    NSHashTable *delegates;
}

@property MSVideoAdView* videoAdView;
@property NSString* m_id;
@property NSString* media_user_id;
@property NSString* placement;
@property NSString* sdk_token;
@property bool mute;
@property bool volumeButtonVisiblity;
@property NSString* identifier;
@property NSString* c_id;
@property NSMutableArray* exclude_c_id_array;
- (void) addDelegate:(id<MSVideoAdDelegate>)d;
- (void) removeDelegate:(id<MSVideoAdDelegate>)d;
- (void) loadRequest;
- (void) showAdForView:(UIView*)view;
- (bool) isReady;
- (void) stop;

@end
