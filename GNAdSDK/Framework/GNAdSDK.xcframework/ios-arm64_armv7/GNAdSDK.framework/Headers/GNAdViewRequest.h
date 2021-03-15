//
//  GNAdViewRequest.h
//  GNAdSDK
//

#import <Foundation/Foundation.h>

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

@class GNAdViewRequest;
@class GNAdView;

@protocol GNAdViewRequestDelegate <NSObject>

#pragma mark Ad Request Lifecycle Notifications

@required

/**
 * Called when GNAdViewRequest GNAdView ads request succeeded.
 *
 * @param gnAdViews The Array of GNAdView received from Ad server.
 * @return void
 */
- (void)gnAdViewRequestDidReceiveAds:(NSArray*)gnAdViews;

/**
 * Called when GNAdViewRequest GNAdView ads request failed.
 *
 * @param request The instance of GNAdViewRequest
 * @param error The error Message for request
 * @return void
 */
- (void)gnAdViewRequest:(GNAdViewRequest *)request didFailToReceiveAdsWithError:(NSError *)error;

@optional

/**
 * Sent before ad begins open landingURL in External Browser.
 *
 * @param gnAdView The GNAdView Ad.
 * @param landingURL The URL of the landing page.
 * @return BOOL YES if the ad should begin start External Browser; otherwise, NO .
 */
- (BOOL)shouldStartExternalBrowserWithClick:(GNAdView *)gnAdView landingURL:(NSString *)landingURL;

@end

/**
 * The `GNAdViewRequest` class is used to manage individual requests to the ad server for
 * GNAdView ads.
 */
 
@interface GNAdViewRequest : NSObject

/** @name Property Information */

/**
 * Delegate object that receives state change notifications from this
 * GNAdViewRequest.  Remember to nil the delegate before deallocating this object.
 */
@property(nonatomic, weak) id<GNAdViewRequestDelegate> delegate;

/**
 * Optional
 * YES, If you prefer to use location optimization.
 * NO (default), not to use location optimization.
 */
@property(nonatomic, assign, setter=setGeoLocationEnable:) BOOL geoLocationEnable;

/**
 * Optional 
 * setting log level.
 */
@property(nonatomic) GNLogPriority GNAdlogPriority;

/**
 * Optional
 * connecting to the debug Server.
 */
@property(nonatomic, assign, setter=setTestMode:) BOOL testMode;

@property (nonatomic) BOOL loading;

/** @name Initializing and Starting an Ad Request */

/**
 * Initializes a request object.
 *
 * @param appID The ad identifier for this request. The appID is a defined placement in
 * your application set aside for advertising. The appID is created on the Admin website.
 */
- (id)initWithID:(NSString *)appID;

/**
 * Makes GNAdView ads request.
 *
 * When the GNAdView ads has been successfully received, the delegate's
 * gnAdViewRequestDidReceiveAds will be called. Otherwise didFailToReceiveAdsWithError will be called.
 */
- (void)loadAds;

@end
