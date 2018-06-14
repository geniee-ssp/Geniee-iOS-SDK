//
//  MSPVAViewController.h
//  MediaSDK
//
//  Created by 市村 有貴江 on 2016/09/16.
//  Copyright © 2016年 市村 有貴江. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "MSAVPlayerView.h"
#import "MSProgressBarView.h"
#import "MSActivityIndicatorView.h"
#import "MSPVAEndCard.h"
#import "MSPVAWKWebViewController.h"


static NSString* const kMSMSPVAViewControllerCloseNotificationName =
@"kMSMSPVAViewControllerCloseNotificationName";

typedef void (^CloseDialogCompletionBlock)(void);
typedef void (^AdRequestCompletionBlock)(NSString*);
typedef void (^ViewLimitRequestCompletionBlock)(NSString*);

@class MSPVAViewController;

@protocol MSPVAViewControllerDelegate <NSObject>

- (void)pvaViewController:(MSPVAViewController *)viewController onPVAMessage:(NSString *)message;

@end

@interface MSPVAViewController : UIViewController
{
    MSActivityIndicatorView* activityIndicator;
    Float64 current;
    Float64 duration;
    BOOL videoPlaying;
    BOOL checkVideoStatusFlg;
    id timeObserver;
    long progressTrackingTime;
    NSString* progressTrackingUrl;
    int playCount;
    int progressTrackingIndex;
}

@property (nonatomic, strong) MSAVPlayerView *playerView;
@property (nonatomic, strong) AVPlayer *player;
@property NSString *videoUrl;
@property UIButton *closeButton;
@property UIImage *closeImage;
@property UIButton *videoEndCloseButton;
@property UIImage *videoEndCloseImage;
@property UIButton *volumeButton;
@property UIImage *volumeImage;
//@property UIButton *repeatButton;
//@property UIImage *repeatImage;
@property UIImage *backgroundImage;
@property UIImageView *backgroundImageView;
@property MSProgressBarView* progressView;
@property MSPVAEndCard* msPVAEndCard;
@property UIImage *thumbnailImage;
@property UIImageView *thumbnailImageView;
@property UIButton *detailButton;
@property UIButton *backVideoButton;
@property UIView *webViewNavigation;
@property MSPVAWKWebViewController* vc;

+ (bool)execute;
+ (MSPVAViewController *)sharedInstance;
+ (bool)isVideoOnly;
+ (bool)isVC_C;
+ (bool)isWebView;
+ (bool)isVisibleRepeatButton;
+ (NSString*)closeButtonPosition;
+ (NSString*)videoEndCloseButtonPosition;

- (void)close;
- (void)clickCloseButton;

+ (bool)send:(NSString *)key;
+ (bool)send:(NSString *)val forEvent:(NSString *)key;
+ (bool)sendInt:(int)val forEvent:(NSString *)key;
+ (bool)sendBool:(bool)val forEvent:(NSString *)key;
+ (bool)sendNSDictionary:(NSDictionary *)val forEvent:(NSString *)key;
+ (bool)sendNSArray:(NSArray *)val forEvent:(NSString *)key;
+ (void)setDelegate:(id<MSPVAViewControllerDelegate>)d;
+ (id<MSPVAViewControllerDelegate>)delegate;
+ (NSMutableDictionary *) getAll;

- (bool)notifyPVAMessageClose;
- (bool)notifyPVAMessageStart;
- (bool)notifyPVAMessageEnd;
- (bool)notifyPVAMessageError;
- (bool)notifyPVAMessageAdOpen;
- (bool)notifyPVAMessageAdClick;
- (bool)notifyPVAMessageLeaveApplication;

+ (void)notifyPVAMessageAdRequest:(NSString*) ret;

+ (void)applicationDidEnterBackground;
+ (void)applicationWillEnterForeground;
+ (void)requestAd;
+ (void)requestViewLimit;

+ (NSString*)getCrypt : (NSString*) media_user_id timestamp:(NSString*)timestamp;

- (void)startActivityIndicator;
- (void)stopActivityIndicator;

+ (NSString*)createMediaUserId;
+ (NSString*)getWebViewUrl;

@end
