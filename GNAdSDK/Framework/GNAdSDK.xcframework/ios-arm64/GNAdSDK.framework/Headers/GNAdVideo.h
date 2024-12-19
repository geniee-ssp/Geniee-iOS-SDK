//
//  GNAdVideo.h
//  GNMASDK
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef __GNLOGPRIORITY__
#define __GNLOGPRIORITY__
typedef enum {
    GNLogPriorityNone,
    GNLogPriorityInfo,
    GNLogPriorityWarn,
    GNLogPriorityError,
} GNLogPriority;
#endif

@class GNAdVideo;

// Delegate for receiving state change messages from a GNAdVideo such as
// video ad requests succeeding/failing.
@protocol GNAdVideoDelegate <NSObject>

#pragma mark Ad Request Lifecycle Notifications

@required

// Sent when an video ad request succeeded.  Show it at the next
// transition point in your application such as when transitioning between view
// controllers.
- (void)onGNAdVideoReceiveSetting;

@optional

// Sent when an video ad request failed.
- (void)onGNAdVideoFailedToReceiveSetting;

#pragma mark Display-Time Lifecycle Notifications

// Sent just after closing ad because the
// user clicked skip button in video ad or
// close button in alternative interstitial ad.
- (void)onGNAdVideoClose;

// Sent just after closing alternative interstitial ad because the
// user clicked the button configured through server-side.
- (void)onGNAdVideoButtonClick:(NSUInteger)nButtonIndex;

@end

// An video ad.  This is a full-screen advertisement shown at natural
// transition points in your application such as between game levels or news
// stories.
@interface GNAdVideo : NSObject

#pragma mark Pre-Request

// Initializes a GNAdVideo and sets it to the specified geniee app ID.
- (id)initWithID:(NSString *)videoAppID;

// Optional sets a alternative interstitial and sets it to the specified geniee app ID.
// The alternative interstitial will be shown when no video ad.
- (void)setAlternativeInterstitialAppID:(NSString *)intersAppID;

// Delegate object that receives state change notifications from this
// GNInterstitial.  Remember to nil the delegate before deallocating this
// object.
@property(nonatomic, weak) id<GNAdVideoDelegate> delegate;

// The rootViewController for presents the video ad.
@property(nonatomic, retain) UIViewController* rootViewController;

// Optional mode to automatically close after playing a video ad.
// Default setting is Yes.
@property BOOL autoCloseMode;

// Optional Setting the background color and transparency.
// Default setting is translucent.
@property(nonatomic, retain) UIColor *viewBackgroundColor;

// Optional
// YES, If you prefer to use location optimization.
// NO (default), not to use location optimization.
@property(nonatomic, assign, setter=setGeoLocationEnable:) BOOL geoLocationEnable;

// Optional
// Ad display frequency. (percentage)：Set the number between 0-100 (%).
// Default setting is 100.
@property(nonatomic, assign) NSInteger show_rate;

// Optional
// The maximum ad display numbers per app use. : Set the number 0 or higher.
// Default setting is 0 (No limited).
@property(nonatomic, assign) NSInteger show_limit;

// Optional
// The maximum reset fraction number of ad display per app use： Set the number 0 or higher.
// Default setting is 0 (invaild).
@property(nonatomic, assign) NSInteger show_reset;

// Optional setting log level.
@property(nonatomic) GNLogPriority GNAdlogPriority;

// Optional connecting to the debug Server.
@property(nonatomic) BOOL testMode;

#pragma mark Making an Ad Request

// Makes an video ad request.
// When the video ad has been successfully received, the delegate's
// onGNAdVideoReceiveSetting will be called. Otherwise onGNAdVideoFailedToReceiveSetting will be called.
- (void)load;

// Check if an ad is ready before attempting to show an ad.
- (BOOL)isReady;

#pragma mark Post-Request

// Presents the video ad which takes over the entire screen until the
// user dismisses it. This has no effect unless delegate's onGNAdVideoReceiveSetting
// has been received.
// Set rootViewController to the rootViewController property configured.
- (BOOL)show;

// Presents the video ad which takes over the entire screen until the
// user dismisses it. This has no effect unless delegate's onGNAdVideoReceiveSetting
// has been received.
// Set currentViewController to the current view controller at the time this method
// is called.
- (BOOL)show:(UIViewController *)currentViewController;
@end
