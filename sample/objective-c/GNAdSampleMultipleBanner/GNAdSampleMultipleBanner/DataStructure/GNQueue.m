//
//  GNQueue.m
//  GNAdSampleMultipleBanner
//

#import "GNQueue.h"

@implementation GNQueue

- (id)initWithSize:(int)aMaxSize
{
    self = [super init];
    if (self != nil) {
        queue = [[NSMutableArray alloc] init];
        maxSize = aMaxSize;
    }
    return self;
}

- (id)dequeue
{
    id headObject;
    @synchronized(queue) {
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
    @synchronized(queue){
        if (anObject == nil) {
            return;
        }
        if ([queue count] >= maxSize) {
            [queue removeObjectAtIndex:0];
        }
        [queue addObject:anObject];
    }
}

- (int)count
{
    int c = 0;
    @synchronized(queue) {
        c = [queue count];
    }
    return c;
}

@end
