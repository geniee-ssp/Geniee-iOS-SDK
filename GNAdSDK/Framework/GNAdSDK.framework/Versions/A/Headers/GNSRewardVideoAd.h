//
//  GNSRewardVideoAd.h
//  GNAdSDK
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GNSRequest.h"
#import "GNSdkMediation.h"

@protocol GNSRewardVideoAdDelegate;

/// The GNSRewardVideoAd class is used for requesting and presenting a reward video ad.
@interface GNSRewardVideoAd : GNSdkMediation

/// Delegate for receiving video notifications.
@property(nonatomic, weak) id<GNSRewardVideoAdDelegate> delegate;

/// Returns the shared GNSRewardVideoAd instance.
+ (GNSRewardVideoAd *)sharedInstance;

/// Initiates the request to fetch the reward video ad.
- (void)loadRequest:(GNSRequest *)request withZoneID:(NSString *)zoneID;

/// Initiates the request to fetch the reward video ad with RTB.
- (void)loadRequest:(GNSRequest *)request withZoneID:(NSString *)zoneID isRTB: (BOOL) isRTB;

/// Indicates if the receiver is ready to show.
- (BOOL)canShow;

/// Presents the reward video ad with the provided view controller.
- (void)show:(UIViewController *)viewController;

@end
