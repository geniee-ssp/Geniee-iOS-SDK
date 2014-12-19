//
//  Log4GNAd.h
//  GNAdSDK
//
//  Created by shingo.nakanishi on 13/03/04.
//
//

#import <Foundation/Foundation.h>

#ifndef __GNLOGPRIORITY__
#define __GNLOGPRIORITY__
typedef enum {
    GNLogPriorityNone,
    GNLogPriorityInfo,
    GNLogPriorityWarn,
    GNLogPriorityError,
} GNLogPriority;
#endif

#define GN_VLOG 0

#if defined GN_VLOG
#define GNVLog(fmt, ...)      NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define GNVLogC()             VLog(@"");
#define GNVLogV(var)          NSLog(@"%s [Line %d] <%p> " #var ": %@", __PRETTY_FUNCTION__, __LINE__, self, var)
#define GNVLogR(rect)         VLogV(NSStringFromRect(rect))
#define GNVLogS(size)         VLogV(NSStringFromSize(size))
#define GNVLogI(var)          NSLog(@"%s [Line %d] " #var ": %d", __PRETTY_FUNCTION__, __LINE__, var)
#define GNVLogF(var)          NSLog(@"%s [Line %d] " #var ": %f", __PRETTY_FUNCTION__, __LINE__, var)
#define GNVLogB(var)          NSLog(@"%s [Line %d] " #var ": %@", __PRETTY_FUNCTION__, __LINE__, var ? @"YES" : @"NO")
#else
#define GNVLog(...)
#define GNVLogC()
#define GNVLogV(var)
#define GNVLogR(rect)
#define GNVLogS(size)
#define GNVLogI(var)
#define GNVLogF(var)
#define GNVLogB(var)
#endif


@interface Log4GNAd : NSObject

+ (void)setPriority:(GNLogPriority)priority;
+ (GNLogPriority)priority;

+ (void)logWithPriority:(GNLogPriority)priority
                message:(NSString *)logMessage
              errorCode:(NSString *)errorCode;

+ (void)logWithPriority:(GNLogPriority)priority
                message:(NSString *)logMessage;

+ (BOOL)logWithPriority:(GNLogPriority)priority;

@end
