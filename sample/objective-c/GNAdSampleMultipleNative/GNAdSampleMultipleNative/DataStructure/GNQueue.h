//
//  GNQueue.h
//  GNAdSampleMultipleNative


#import <Foundation/Foundation.h>

@interface GNQueue : NSObject
{
    NSMutableArray *queue;
    int maxSize;
}

///
- (id)initWithMaxSize:(int)size;

- (id)dequeue;

- (void)enqueue:(id)anObject;

- (long)count;

@end
