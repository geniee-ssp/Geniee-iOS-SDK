//
//  GNSdkMediation.h
//  GNAdSDK
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GNSRequest.h"
#import "GNRequest.h"
#import "GNSAdNetworkParam.h"

@protocol GNSAdNetworkDelegate;

typedef enum : NSInteger{
    RewardVideo,
    FullscreenInterstitial,
} ZoneType;

@interface GNSdkMediation : NSObject

@property (nonatomic, weak) id<GNSAdNetworkDelegate> adNetworkDelegate;
@property (nonatomic, retain) NSMutableArray *adNetworks;
@property (nonatomic, retain) NSTimer *timerNextNetwork;
@property (nonatomic, retain) GNRequest* req;

@property (nonatomic, assign) NSInteger zoneid;
@property (nonatomic, assign) ZoneType zoneType;
@property (nonatomic, assign) NSInteger view_limit;
@property (nonatomic, assign) NSInteger view_rate;
@property (nonatomic, assign) NSInteger view_reset;
@property (nonatomic, assign) BOOL preload;
@property (nonatomic, assign) NSInteger timeout;
@property (nonatomic, assign) NSInteger requestFailedCount;

@property (nonatomic) BOOL loading;
@property (nonatomic) BOOL noticed;
@property (nonatomic) BOOL lastAdnwLoading;

/// Initiates the request to fetch the ad.
- (void)loadRequest:(GNSRequest *)request withZoneID:(NSString *)zoneID;

/// Indicates if the receiver is ready to show.
- (BOOL)canShow;

/// Presents the ad with the provided view controller.
- (void)show:(UIViewController *)viewController;

- (NSInteger)updateFrequencyCountWithImp:(BOOL)isAddImp;
- (void)disableAdNetworksDeliveryTarget;
- (BOOL)isFrequencyCapping;
- (void)deleteUnDeliveryTargetAdNetworks;
- (void)sortAdNetworksByDisplayOrder;
- (void)setupAdNetworks;
- (void)requestAdNetworks;
- (void)initAdNetwork:(GNSAdNetworkParam*)adNetworkParam index:(NSInteger)index;
- (BOOL)isRateCapping;
- (NSError *)createError:(NSString *)errorMsg withDomain:(NSString *)domainName;

@end
