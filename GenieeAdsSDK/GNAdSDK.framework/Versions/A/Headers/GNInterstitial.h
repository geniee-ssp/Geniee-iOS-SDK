//
//  GNInterstitial.h
//  GNAdSDK
//

#import <UIKit/UIKit.h>

#if defined(__cplusplus)
#define GNAD_EXTERN extern "C"
#else
#define GNAD_EXTERN extern
#endif

#ifndef __GNLOGPRIORITY__
#define __GNLOGPRIORITY__
typedef enum {
    GNLogPriorityNone,
    GNLogPriorityInfo,
    GNLogPriorityWarn,
    GNLogPriorityError,
} GNLogPriority;
#endif

@class GNInterstitial;

// Delegate for receiving state change messages from a GNInterstitial such as
// interstitial ad requests succeeding/failing.
@protocol GNInterstitialDelegate <NSObject>

#pragma mark Ad Request Lifecycle Notifications

@required

// Sent when an interstitial ad request succeeded.  Show it at the next
// transition point in your application such as when transitioning between view
// controllers.
- (void)onReceiveSetting;

@optional

// Sent when an interstitial ad request failed.
- (void)onFailedToReceiveSetting;

#pragma mark Display-Time Lifecycle Notifications

// Sent just after closing interstitial ad because the
// user clicked close button in an ad.
- (void)onClose;

// Sent just after closing interstitial ad because the
// user clicked the button configured through server-side.
- (void)onButtonClick:(NSUInteger)nButtonIndex;

@end

// An interstitial ad.  This is a full-screen advertisement shown at natural
// transition points in your application such as between game levels or news
// stories.
@interface GNInterstitial : NSObject

#pragma mark Pre-Request

// Initializes a GNInterstitial and sets it to the specified geniee app ID.
- (id)initWithID:(NSString *)appID;

// Delegate object that receives state change notifications from this
// GNInterstitial.  Remember to nil the delegate before deallocating this
// object.
@property(nonatomic, weak) id<GNInterstitialDelegate> delegate;

// The rootViewController for presents the interstitial ad.
@property(nonatomic, retain) UIViewController* rootViewController;

// Optional default html which will be displayed when internet connection is not abailable.
@property(nonatomic, copy) NSString *defaultHtml;

// Optional
// YES, If you prefer to use location optimization.
// NO (default), not to use location optimization.
@property(nonatomic, assign, setter=setGeoLocationEnable:) BOOL geoLocationEnable;

// Optional setting log level.
@property(nonatomic) GNLogPriority GNAdlogPriority;

// Optional connecting to the debug Server.
@property(nonatomic, assign, setter=setTestMode:) BOOL testMode;

#pragma mark Making an Ad Request

// Makes an interstitial ad request.
// When the interstitial ad has been successfully received, the delegate's
// onReceiveSetting will be called. Otherwise onFailedToReceiveSetting will be called.
- (void)load;

// Check if an ad is ready before attempting to show an ad.
- (BOOL)isReady;

#pragma mark Post-Request

// Presents the interstitial ad which takes over the entire screen until the
// user dismisses it. This has no effect unless delegate's onReceiveSetting
// has been received.
// Set rootViewController to the rootViewController property configured.
- (BOOL)show;

// Presents the interstitial ad which takes over the entire screen until the
// user dismisses it. This has no effect unless delegate's onReceiveSetting
// has been received.
// Set currentViewController to the current view controller at the time this method
// is called.
- (BOOL)show:(UIViewController *)currentViewController;

@end
