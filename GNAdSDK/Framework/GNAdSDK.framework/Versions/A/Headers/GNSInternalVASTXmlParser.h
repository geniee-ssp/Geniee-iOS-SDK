//
//  GNSInternalVASTXmlParser.h
//  GNAdSDK
//

#import <UIKit/UIKit.h>

// http://www.iab.net/media/file/VASTv3.0.pdf

@interface GNSInternalVASTXmlParser : NSObject

@property (nonatomic, copy) NSURL *mediaFileURL;
@property (nonatomic, copy) NSArray *impressionURLs;
@property (nonatomic, copy) NSString *clickThroughURL;
@property (nonatomic, copy) NSArray *clickTrackingURLs;
@property (nonatomic, copy) NSDictionary *trackingEvents;
@property (nonatomic, copy) NSArray* errorURLs;
@property (nonatomic, copy) NSString* endcardUrl;
@property (nonatomic, copy) NSString *duration;
@property (nonatomic, assign) int mediaWidth;
@property (nonatomic, assign) int mediaHeight;

@property (nonatomic, retain) GNSInternalVASTXmlParser* wrappedVASTXml;
@property (nonatomic, assign) NSInteger levelWrap;

+ (NSData *)requestVast:(NSString*)url userAgent:(NSString*)userAgent;

- (id)initWithData:(NSData *)data levelWrap:(NSInteger)levelWrap error:(NSError **)error userAgent:(NSString*)userAgent;
- (id)initWithXMLString:(NSString *)data levelWrap:(NSInteger)levelWrap error:(NSError **)error userAgent:(NSString*)userAgent;

- (NSURL *)getXmlMediaFileURL;
- (NSArray *)getXmlImpressionURLs;
- (NSDictionary *)getXmlTrackingURLs;
- (NSArray *)getXmlClickTrackingURLs;
- (NSString *)getXmlClickThroughURL;
- (NSArray*)getXmlErrorURLs;
- (NSString*)getXmlEndcardUrl;
- (int)getXmlMediaWidth;
- (int)getXmlMediaHeight;
- (float)getXmlDuration;
- (CGFloat)getInviewRatio;
- (CGFloat)getOutviewRatio;

@end
