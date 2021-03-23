//
//  GNSRequest.h
//  GNAdSDK
//

#import <Foundation/Foundation.h>
#import "Log4GNAd.h"

@interface GNSRequest : NSObject

/// Returns a default request.
+ (instancetype)request;

@property(nonatomic) GNLogPriority GNAdlogPriority;
@property(nonatomic, assign) BOOL geoLocationEnable;
@property(nonatomic, assign) BOOL testMode;
@property(nonatomic, copy) NSString *sdk_base_url_test;

@end
