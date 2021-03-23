//
//  GNSAdConstants.h
//  GNAdSDK
//

#import <Foundation/Foundation.h>

#pragma mark - Error code.
#ifndef __GNERRORCODE__
#define __GNERRORCODE__
typedef enum {
    ERR_NETWORK_ERROR = 1001,
    ERR_OTHER = 9001,
    ERR_AD_SHOW_CANNOT = 10511,
    ERR_AD_SHOW_PLAYING = 10521,
    ERR_VAST_REQUEST = 20001,
    ERR_VAST_INVALID_XML = 20011,
    ERR_MEDIA_FILE_REQUEST = 21001,
    ERR_MEDIA_FILE_MAX_SIZE = 21011,
    ERR_BANNER_INVALID_BANNER_DATA = 30002,
    ERR_BANNER_EMPTY = 30003,
} GNErrorCode;
#endif

@interface GNSAdConstants : NSObject

+ (NSString*)getSdkVersion;

@end
