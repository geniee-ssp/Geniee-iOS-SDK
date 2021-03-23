//
//  GNSAdNetworkParam.h
//  GNAdSDK
//

#import <Foundation/Foundation.h>

@interface GNSAdNetworkParam : NSObject

@property (nonatomic, assign) NSInteger zoneid;
@property (nonatomic, assign) NSInteger adsourceid;
@property (nonatomic, copy) NSString *className;
@property (nonatomic, copy) NSString *external_link_id;
@property (nonatomic, copy) NSString *external_link_media_id;
@property (nonatomic, copy) NSString *imp;
@property (strong, retain) NSMutableArray *imps;
@property (nonatomic, assign) NSInteger timeout;
@property(nonatomic, assign) BOOL impsURLFormatFlag;

- (id)initWithZone:(NSInteger)zoneID content:(NSDictionary *)content;

@end
