//
//  GNSAdNetworkExtraParams.h
//  GNAdSDK
//

#import <Foundation/Foundation.h>
#import "GNSAdNetworkExtras.h"


@interface GNSAdNetworkExtraParams : NSObject<GNSAdNetworkExtras>

@property (nonatomic, copy) NSString *external_link_id;
@property (nonatomic, copy) NSString *external_link_media_id;
@property(nonatomic, copy) NSString *type;
@property(nonatomic, copy) NSDecimalNumber *amount;

@end
