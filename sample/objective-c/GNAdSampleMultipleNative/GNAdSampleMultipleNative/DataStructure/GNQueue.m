//
//  GNQueue.m
//  GNAdSampleMultipleNative


#import "GNQueue.h"

@implementation GNQueue

- (id)initWithMaxSize:(int)size
{
    self = [super init];
    if (self != nil) {
        queue = [NSMutableArray new];
        maxSize = size;
    }
    return self;
}

- (id)dequeue
{
    id headObject;
    @synchronized (queue) {
        if ([queue count] == 0) return nil;
        headObject = [queue objectAtIndex:0];
        if (headObject != nil) {
            [queue removeObjectAtIndex:0];
        }
    }
    return headObject;
}

- (void)enqueue:(id)anObject
{
    @synchronized (queue) {
        if (anObject == nil) return;
        
        if ([queue count] >= maxSize) {
            [queue removeObjectAtIndex:0];
        }
        [queue addObject:anObject];
    }
}

- (long)count
{
    long queueCount = 0;
    @synchronized (queue) {
        queueCount = [queue count];
    }
    return queueCount;
}

@end
