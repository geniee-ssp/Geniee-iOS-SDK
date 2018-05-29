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
    
    func dequeue() -> Any? {
        var headObject: Any?
        objc_sync_enter(queue)
        if (queue.count == 0) {
            return nil
        }
        headObject = queue.object(at:0)
        if (headObject != nil) {
            queue.removeObject(at:0)
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
            queue.removeObject(at:0)
        }
        queue.add(anObject!)
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
