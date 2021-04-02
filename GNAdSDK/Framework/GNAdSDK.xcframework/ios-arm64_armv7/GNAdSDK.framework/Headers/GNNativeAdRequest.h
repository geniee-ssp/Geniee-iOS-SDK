//
//  GNNativeAdRequest.h
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

@class GNNativeAdRequest;
@class GNNativeAd;

@protocol GNNativeAdRequestDelegate <NSObject>

#pragma mark Ad Request Lifecycle Notifications

@required

/**
 * Called when GNNativeAdRequest native ads request succeeded.
 *
 * @param nativeAds The Array of GNNativeAd received from Ad server.
 */
- (void)nativeAdRequestDidReceiveAds:(NSArray*)nativeAds;

/**
 * Called when GNNativeAdRequest native ads request failed.
 *
 * @param request The instance of GNNativeAdRequest
 * @param error The error Message for request
 */
- (void)nativeAdRequest:(GNNativeAdRequest *)request didFailToReceiveAdsWithError:(NSError *)error;

@optional

/**
 * Sent before ad begins open landingURL in External Browser.
 *
 * @param nativeAd The Native Ad.
 * @param landingURL The URL of the landing page.
 * @return BOOL YES if the ad should begin start External Browser; otherwise, NO .
 */
- (BOOL)shouldStartExternalBrowserWithClick:(GNNativeAd *)nativeAd landingURL:(NSString *)landingURL;

@end

/**
 * The `GNNativeAdRequest` class is used to manage individual requests to the ad server for
 * native ads.
 */
 
@interface GNNativeAdRequest : NSObject

/** @name Property Information */

/**
 * Delegate object that receives state change notifications from this
 * GNNativeAdRequest.  Remember to nil the delegate before deallocating this object.
 */
@property(nonatomic, weak) id<GNNativeAdRequestDelegate> delegate;

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

/// Returns the shared GNNativeAdRequest instance.
+ (GNNativeAdRequest *)sharedMenager;

/**
 * Initializes a request object.
 *
 * @param appID The ad identifier for this request. The appID is a defined placement in
 * your application set aside for advertising. The appID is created on the Admin website.
 */
- (instancetype)initWithID:(NSString *)appID;

/**
 * Makes native ads request.
 *
 * When the native ads has been successfully received, the delegate's
 * nativeAdRequestDidReceiveAds will be called. Otherwise didFailToReceiveAdsWithError will be called.
 */
- (void)loadAds;

/**
 * Makes native ads request With zoneIds.
 *
 * When the native ads has been successfully received, the delegate's
 * nativeAdRequestDidReceiveAds will be called. Otherwise didFailToReceiveAdsWithError will be called.
 */
- (void)multiLoadAds;


@end
