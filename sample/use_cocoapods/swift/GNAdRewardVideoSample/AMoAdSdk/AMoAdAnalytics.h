//
//  AMoAdAnalytics.h
//
//  Created by AMoAd on 2015/07/17.
//
#import <Foundation/Foundation.h>

@interface AMoAdAnalytics : NSObject
@property (nonatomic,copy) NSDictionary *publisherParam;
- (instancetype)initWithReportId:(NSString *)reportId NS_DESIGNATED_INITIALIZER;

- (instancetype)init __attribute__((unavailable("init is not available")));
@end

@interface NSString(AMoAdAnalytics)
- (NSString *)stringByAppendingAnalytics:(AMoAdAnalytics *)analytics tag:(NSString *)tag;
@end
