//
//  GNAdView.h
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

@class GNAdView;

// Delegate for receiving state change messages from a GNAdView such as ad
// requests succeeding/failing or when an ad has been clicked.
@protocol GNAdViewDelegate <NSObject>

@optional

#pragma mark Ad Request Lifecycle Notifications

// Sent when an ad request loaded an ad.  This is a good opportunity to add this
// view to the hierarchy if it has not yet been added.
- (void)adViewDidReceiveAd:(GNAdView *)adView;

// Sent when an ad request failed.  Normally this is because no network
// connection was available or no ads were available (i.e. no fill).
- (void)adView:(GNAdView *)adView didFailReceiveAdWithError:(NSError *)error;

#pragma mark Click-Time Lifecycle Notifications

// Sent just before presenting the user a browser,
// in response to clicking on an ad.
- (void)adViewWillShowInDefaultBrowser:(GNAdView *)adView;

// Sent just before presenting the user a in-app browser,
// in response to clicking on an ad.
- (void)adViewWillShowInInternalBrowser:(GNAdView *)adView;

// Sent just before close the in-app browser and to lauch device browser.
- (void)adViewWillShiftToDefaultBrowser:(GNAdView *)adView;

// Sent just before dismissing the in-app browser.
- (void)adViewWillTerminateInternalBrowser:(GNAdView *)adView;

@end

// The view that displays banner ads.
@interface GNAdView : UIView

// Ad size type definition
typedef enum {
    GNAdSizeTypeNone = 0, // No definition
    GNAdSizeTypeXSmall,   // 320x48
    GNAdSizeTypeSmall,    // 320x50
    GNAdSizeTypeTall,     // 300x250
    GNAdSizeTypeLarge,    // 728x90
    GNAdSizeTypeW468H60,  //468x60
	GNAdSizeTypeW120H600, //120x600
    GNAdSizeTypeW160H600, //160x600
    GNAdSizeTypeW320H100, //320x100
    GNAdSizeTypeW57H57,   //57x57
    GNAdSizeTypeW76H76,   //76x76
    GNAdSizeTypeW480H32,  //480x32
    GNAdSizeTypeW768H66,  //768x66
    GNAdSizeTypeW1024H66, //1024x66
} GNAdSizeType;

#pragma mark Initialization

// Initializes a GNAdView and sets it to the specified frame, and geniee app ID (with default ad size 320x50)
- (id)initWithFrame:(CGRect)frame appID:(NSString *)appID;

// Initializes a GNAdView and sets it to the specified frame, size type, and geniee app ID
- (id)initWithFrame:(CGRect)frame adSizeType:(GNAdSizeType)adSizeType appID:(NSString *)appID;

// Set view controller displays in-app browser (rootViewController setting is necessary  when using the in-app browser.)
@property(nonatomic, retain) UIViewController* rootViewController;

// Optional delegate object that receives state change notifications from this GNAdView.
// (delegate setting is not necessary  when not using state change notifications)
@property(nonatomic, weak) id<GNAdViewDelegate> delegate;

#pragma mark Start/Stop refreshing Ads

// Start automatically refreshing banner ads.
- (void)startAdLoop;

// End automatically refreshing banner ads.
- (void)stopAdLoop;

#pragma mark set/get Ad backgroud color
// Optional
// Set Ad backgroud color.
@property(nonatomic, getter=isBgColor) BOOL bgColor;

#pragma mark Ad location optimization
// Optional
// YES, If you prefer to use location optimization.
// NO (default), not to use location optimization.
@property(nonatomic, assign, setter=setGeoLocationEnable:) BOOL geoLocationEnable;

#pragma mark Ad Debug
// Optional setting log level
@property(nonatomic) GNLogPriority GNAdlogPriority;
// Optional checking banner background
@property(nonatomic, weak) UIImageView* imageViewDebug;
// Optional connecting to the debug Server.
@property(nonatomic, assign, setter=setTestMode:) BOOL testMode;

#pragma mark Ad request additional parameters
@property(nonatomic, copy) NSDictionary *requestExtra;

#pragma mark Mediation function
+ (GNAdSizeType)adSizeTypeWithAdSize:(CGSize)adSize;
- (void)releaseAdViews;

@end
