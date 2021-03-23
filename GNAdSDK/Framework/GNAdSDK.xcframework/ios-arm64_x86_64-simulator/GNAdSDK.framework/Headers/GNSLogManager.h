//
//  GNSLogManager
//
//  Copyright © 2019 Geniee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const kGNSBanner;
extern NSString * const kGNSInterstitial;
extern NSString * const kGNSNative;
extern NSString * const kGNSVideo;
extern NSString * const kGNSRewardedVideo;
extern NSString * const kGNSFullscreenInterstitial;


@interface GNSLogManager : NSObject

@property NSMutableDictionary * eventLogs;

+ (instancetype)sharedInstance;

- (void) appendLog:(NSString *) zoneType zoneId:(NSString *)zoneId className:(NSString *)className methodName:(NSString *)methodName;

- (void) deleteEvent:(NSString *)zoneId;

- (NSMutableDictionary *) getAllLogEvents;
- (NSString *) convertAllLogEventsToString;

@end

NS_ASSUME_NONNULL_END
