//
//  GNSVideoPlayerView.h
//  GNAdSDK
//

#import <UIKit/UIKit.h>

@class GNSVideoPlayerView;

// Delegate for receiving state change messages from a GNSVideoPlayerView such as
// video ad requests succeeding/failing.
@protocol GNSVideoPlayerDelegate <NSObject>
@required
// Sent when an video ad request succeeded.
- (void)onVideoReceiveSetting:(GNSVideoPlayerView*)view;
@optional
// Sent when an video ad request failed.
- (void)onVideoFailWithError:(GNSVideoPlayerView*)view error:(NSError *)error;

// Sent when an video ad play started.
- (void)onVideoStartPlaying:(GNSVideoPlayerView*)view;

// Sent when an video ad okay completed.
- (void)onVideoPlayComplete:(GNSVideoPlayerView*)view;
@end


@interface GNSVideoPlayerView : UIView

// Delegate object that receives state change notifications.
// Remember to nil the delegate before deallocating this object.
@property(nonatomic, weak) id<GNSVideoPlayerDelegate> delegate;

#pragma mark Controller(Basic).
// Release processing.
- (void)remove;
// Set the vastXml.
- (void)setVastXml:(NSString*)vastxml;
// Request the load.
- (void)load;
// Request the load(format of the url).
- (void)loadUrl:(NSString*)urlString;
// Request the load(format of the VAST string).
- (void)loadVast:(NSString*)vastString;
// Get whether it is ready to display.
- (BOOL)isReady;
// Request the show.
- (BOOL)show;
- (void)clearCache;
#pragma mark UI(Controller).
// Get the mute state.
- (BOOL)getMuted;
// Get the auto loop state.
- (BOOL)getAutoLoop;
// Set the mute state.
- (void)setMuted:(BOOL)isMuted;
// Set the auto loop state.
- (void)setAutoLoop:(BOOL)isLoop;
#pragma mark UI(Show).
// Get the showing state of the mute button.
- (BOOL)getVisibilityMuteButton;
// Get the showing state of the progressbar.
- (BOOL)getVisibilityProgressbar;
// Get the showing state of the current time label.
- (BOOL)getVisibilityCurrentTimeLabel;
// Get the showing state of the replay button.
- (BOOL)getVisibilityReplayButton;
// Set the showing state of the mute button.
- (void)setVisibilityMuteButton:(BOOL)isShow;
// Set the showing state of the progressbar.
- (void)setVisibilityProgressbar:(BOOL)isShow;
// Set the showing state of the current time label.
- (void)setVisibilityCurrentTimeLabel:(BOOL)isShow;
// Set the showing state of the replay button.
- (void)setVisibilityReplayButton:(BOOL)isShow;
#pragma mark media info.
- (int)getMediaFileWidth;
- (int)getMediaFileHeight;
- (float)getMediaFileAspect;
- (float)getDuration;
- (float)getCurrentposition;
- (bool)isPlaying;

@end
