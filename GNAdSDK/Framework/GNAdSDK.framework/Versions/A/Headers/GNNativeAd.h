//
//  GNNativeAd.h
//  GNAdSDK
//

#import <Foundation/Foundation.h>
#import "GNNativeAdRequest.h"
#import <UIKit/UIKit.h>
@class GNSNativeVideoPlayerView;

/**
 * The `GNNativeAd` class is used to manage native ad.
 */

@interface GNNativeAd : NSObject

@property(nonatomic, readonly, copy) NSString *zoneID;
@property(nonatomic, readonly, copy) NSString *advertiser;
@property(nonatomic, readonly, copy) NSString *title;
@property(nonatomic, readonly, copy) NSString *description;
@property(nonatomic, readonly, copy) NSString *cta;
@property(nonatomic, readonly, assign) double icon_aspectRatio;
@property(nonatomic, readonly, copy) NSString *icon_url;
@property(nonatomic, readonly, assign) int    icon_height;
@property(nonatomic, readonly, assign) int    icon_width;
@property(nonatomic, readonly, assign) double screenshots_aspectRatio;
@property(nonatomic, readonly, copy) NSString *screenshots_url;
@property(nonatomic, readonly, assign) int    screenshots_height;
@property(nonatomic, readonly, assign) int    screenshots_width;
@property(nonatomic, readonly, copy) NSString *app_appName;
@property(nonatomic, readonly, copy) NSString *app_appid;
@property(nonatomic, readonly, assign) double app_rating;
@property(nonatomic, readonly, copy) NSString *app_storeURL;
@property(nonatomic, readonly, copy) NSString *app_targetAge;
@property(nonatomic, readonly, copy) NSString *optout_text;
@property(nonatomic, readonly, copy) NSString *optout_image_url;
@property(nonatomic, readonly, copy) NSString *optout_url;
@property(nonatomic, readonly, copy) NSString *vast_xml;

/**
 * Initializes a GNNativeAd.
 *
 * @param zoneID The identifier for this GNNativeAd.
 * @param nativeContent The json content for GNNativeAd.
 * @param request The instance of GNNativeAdRequest
 */
- (id)initWithZone:(NSString *)zoneID content:(NSDictionary *)nativeContent request:(GNNativeAdRequest *)request;

/**
 * Tracking Ad Impression
 * When the Ad content is rendered, report this Impression to Ad server.
 *
 * @param uiView the view for rendering Impression beacon tag
 */
- (void)trackingImpressionWithView:(UIView *)uiView;

/**
 * Tracking Ad Click
 *
 * When you detect that the user has tapped on an Ad (e.g. via gesture recognizer),
 * Call this function to open landingURL in external application.
 *
 * @param uiView the view for tracking click beacon tag
 */
- (void)trackingClick:(UIView *)uiView;

/**
 * Get the GNSNativeVideoPlayerView.
 */
- (GNSNativeVideoPlayerView*)getVideoView:(CGRect)frame;

/**
 * Get the existence of video advertisement.
 */
- (BOOL)hasVideoContent;

@end
