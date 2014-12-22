//
//  GNNativeAdRequest.h
//  Copyright (c) 2014 Geniee. All rights reserved.
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

@protocol GNNativeAdRequestDelegate <NSObject>

#pragma mark Ad Request Lifecycle Notifications

@required

/**
 * Called when GNNativeAdRequest native ads request succeeded.
 *
 * @param nativeAds The Array of GNNativeAd received from Ad server.
 * @return void
 */
- (void)nativeAdRequestDidReceiveAds:(NSArray*)nativeAds;

/**
 * Called when GNNativeAdRequest native ads request failed.
 *
 * @param request The instance of GNNativeAdRequest
 * @param error The error Message for request
 * @return void
 */
- (void)nativeAdRequest:(GNNativeAdRequest *)request didFailToReceiveAdsWithError:(NSError *)error;

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

/**
 * Initializes a request object.
 *
 * @param appID The ad identifier for this request. The appID is a defined placement in
 * your application set aside for advertising. The appID is created on the Admin website.
 */
- (id)initWithID:(NSString *)appID;

/**
 * Makes native ads request.
 *
 * When the native ads has been successfully received, the delegate's
 * nativeAdRequestDidReceiveAds will be called. Otherwise didFailToReceiveAdsWithError will be called.
 */
- (void)loadAds;

@end
