//
//  GNSNativeVideoPlayerView.h
//  GNAdSDK
//

#import <UIKit/UIKit.h>
@class GNNativeAd;

// Delegate for receiving state change messages from a GNSVideoPlayerView such as
// video ad requests succeeding/failing.
@protocol GNSNativeVideoPlayerDelegate <NSObject>
@required
// Sent when an video ad request succeeded.
- (void)onVideoReceiveSetting:(GNSNativeVideoPlayerView*)view;
@optional
// Sent when an video ad request failed.
- (void)onVideoFailWithError:(GNSNativeVideoPlayerView*)view error:(NSError *)error;

// Sent when an video ad play started.
- (void)onVideoStartPlaying:(GNSNativeVideoPlayerView*)view;

// Sent when an video ad okay completed.
- (void)onVideoPlayComplete:(GNSNativeVideoPlayerView*)view;
@end


@interface GNSNativeVideoPlayerView : UIView

// Delegate object that receives state change notifications.
// Remember to nil the delegate before deallocating this object.
@property(nonatomic, weak) id<GNSNativeVideoPlayerDelegate> nativeDelegate;

#pragma mark Controller(Basic).
// Release processing.
- (void)remove;
// Set the vastXml.
- (void)setVastXml:(NSString*)vastxml;
// Request the load.
- (void)load;
// Request the load(format of the GNNativeAd).
- (void)load:(GNNativeAd*)nativeAd;
// Get whether it is ready to display.
- (BOOL)isReady;
// Request the show.
- (BOOL)show;
#pragma mark UI(Controller).
// Get the mute state.
- (BOOL)getMuted;
// Set the mute state.
- (void)setMuted:(BOOL)isMuted;
#pragma mark UI(Show).
// Get the showing state of the mute button.
- (BOOL)getVisibilityMuteButton;
// Get the showing state of the progressbar.
- (BOOL)getVisibilityProgressbar;
// Set the showing state of the mute button.
- (void)setVisibilityMuteButton:(BOOL)isShow;
// Set the showing state of the progressbar.
- (void)setVisibilityProgressbar:(BOOL)isShow;
#pragma mark media info.
- (int)getMediaFileWidth;
- (int)getMediaFileHeight;
- (float)getMediaFileAspect;
- (float)getDuration;
- (float)getCurrentposition;

@end
