//
//  GNSRewardVideoAd.h
//  GNAdSDK
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GNSRequest.h"

@protocol GNSRewardVideoAdDelegate;

/// The GNSRewardVideoAd class is used for requesting and presenting a reward video ad.
@interface GNSRewardVideoAd : NSObject

/// Delegate for receiving video notifications.
@property(nonatomic, weak) id<GNSRewardVideoAdDelegate> delegate;

/// Returns the shared GNSRewardVideoAd instance.
+ (GNSRewardVideoAd *)sharedInstance;

/// unavailable method.
- (instancetype) init __attribute__((unavailable("init not available. use sharedInstance")));

/// Initiates the request to fetch the reward video ad.
- (void)loadRequest:(GNSRequest *)request withZoneID:(NSString *)zoneID;

/// Indicates if the receiver is ready to show.
- (BOOL)canShow;

/// Presents the reward video ad with the provided view controller.
- (void)show:(UIViewController *)viewController;

@end
