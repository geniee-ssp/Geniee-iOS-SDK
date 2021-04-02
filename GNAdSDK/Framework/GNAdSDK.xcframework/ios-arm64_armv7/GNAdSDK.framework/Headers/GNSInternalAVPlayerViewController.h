//
//  GNSInternalAVPlayerViewController.h
//  GNAdSDK
//

#import <UIKit/UIKit.h>
#import "GNSInternalAVPlayerView.h"
#import "GNSInternalVASTPlayer.h"

#define DEFAULT_LOOP NO
#define DEFAULT_MUTE YES
#define DEFAULT_HIDDEN_PLAY_BUTTON YES
#define DEFAULT_HIDDEN_MUTE_BUTTON NO
#define DEFAULT_HIDDEN_PROGRESSBAR NO
#define DEFAULT_HIDDEN_CURRENT_TIME_LABEL YES
#define DEFAULT_HIDDEN_REPLAY_BUTTON NO
#define DEFAULT_HIDDEN_CLOSE_BUTTON YES

@protocol GNSInternalAVPlayerViewControllerDelegate <NSObject>
- (CGFloat)getCurrentInviewSizeRatio:(BOOL)isCurrent;
@optional
- (void)notifyPlay;
- (void)notifyPause;
- (void)onPlayStarted;
- (void)onPlayCompleted;
- (void)onPlayError;
- (void)onClosed;
@end

/**
 * This is a screen to test video playback by AVPlayer.
 */
@interface GNSInternalAVPlayerViewController : UIViewController

@property(nonatomic, weak) id<GNSInternalAVPlayerViewControllerDelegate> delegate;
@property(nonatomic, readonly) BOOL isAdPlayStart;  // Video ad playback start flag
@property(nonatomic, retain) UIColor *viewBackgroundColor; // Background color.

@property (nonatomic, retain) IBOutlet GNSInternalAVPlayerView* videoPlayerView;
@property (nonatomic, retain) IBOutlet UIButton*     muteButton;
@property (nonatomic, retain) IBOutlet UIButton*     closeButton;
@property (nonatomic, retain) IBOutlet UIButton*     replayButton;
@property (nonatomic, retain) IBOutlet UIProgressView * progressBar;
@property (nonatomic, retain) IBOutlet UILabel*      currentTimeLabel;
@property (nonatomic, retain) IBOutlet UIButton*     playButton;    // Future?
@property (nonatomic, retain) IBOutlet UIImageView*  finishView;

- (id)initWithPlayer:(GNSInternalVASTPlayer *)player;
- (void)closeViewController;

- (void)play;
- (void)pause;
- (void)resume;
- (void)replay;
- (BOOL)getMuted;
- (void)setMuted:(BOOL)isMuted;
- (BOOL)getLoop;
- (void)setLoop:(BOOL)isLoop;
- (void)notifyInView:(BOOL)isInView;
- (void)setEndcardUrl:(NSString*)url;
- (void)finishViewDidPush:(UITapGestureRecognizer *)recognizer;

- (BOOL)getHiddenPlayButton;
- (BOOL)getHiddenMuteButton;
- (BOOL)getHiddenProgressbar;
- (BOOL)getHiddenCurrentTimeLabel;
- (BOOL)getHiddenReplayButton;
- (void)setHiddenPlayButton:(BOOL)isHidden;
- (void)setHiddenMuteButton:(BOOL)isHidden;
- (void)setHiddenProgressbar:(BOOL)isHidden;
- (void)setHiddenCurrentTimeLabel:(BOOL)isHidden;
- (void)setHiddenReplayButton:(BOOL)isHidden;
- (BOOL)getHiddenCloseButton;
- (void)setHiddenCloseButton:(BOOL)isHidden;

@end
