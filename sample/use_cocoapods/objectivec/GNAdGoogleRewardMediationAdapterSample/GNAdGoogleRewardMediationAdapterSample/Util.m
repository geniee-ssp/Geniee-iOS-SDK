//
//  Util.m
//  GNAdGoogleRewardAdapterSample
//

#include "Util.h"
#import <AdSupport/ASIdentifierManager.h>
#include <CommonCrypto/CommonDigest.h>

@implementation Util

+ (NSString *) admobDeviceID
{
    NSUUID* adid = [[ASIdentifierManager sharedManager] advertisingIdentifier];
    const char *cStr = [adid.UUIDString UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest );

    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];

    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];

    return  output;
}

@end
