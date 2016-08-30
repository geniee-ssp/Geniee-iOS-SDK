//
//  GNQueue.swift
//  GNAdSampleNativeAd
//

import UIKit

class GNQueue: NSObject {
    var queue: NSMutableArray = []
    var maxSize: Int = 0
    
    init(aMaxSize: Int) {
        super.init()
        maxSize = aMaxSize;
    }
    
    func dequeue() -> AnyObject? {
        var headObject: AnyObject?
        objc_sync_enter(queue)
        if (queue.count == 0) {
            return nil
        }
        headObject = queue.objectAtIndex(0)
        if (headObject != nil) {
            queue.removeObjectAtIndex(0)
        }
        objc_sync_exit(queue)
        return headObject;
    }
    
    func enqueue(anObject: AnyObject?) {
        objc_sync_enter(queue)
        if (anObject == nil) {
            return;
        }
        if (queue.count >= maxSize) {
            queue.removeObjectAtIndex(0)
        }
        queue.addObject(anObject!)
        objc_sync_exit(queue)
    }
    
    func count()->Int {
        var c:Int = 0;
        objc_sync_enter(queue)
        c = queue.count
        objc_sync_exit(queue)
        return c
    }
}
