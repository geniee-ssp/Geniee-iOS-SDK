//
//  GNQueue.h
//  GNAdSampleMultipleBanner
//

#import <Foundation/Foundation.h>

@interface GNQueue : NSObject
{
    NSMutableArray *queue;
    int maxSize;
}

- (id)initWithSize:(int)maxSize;
- (id)dequeue;
- (void)enqueue:(id)anObject ;
- (int)count;

@end
