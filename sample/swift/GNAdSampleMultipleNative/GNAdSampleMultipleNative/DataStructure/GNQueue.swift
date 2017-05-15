//
//  GNQueue.swift
//  GNAdSampleMultipleNative

import UIKit

class GNQueue: NSObject {
    var queue: NSMutableArray = []
    var maxSize: Int = 0
    
    init(aMaxSize: Int) {
        super.init()
        maxSize = aMaxSize
    }
    
    func dequeue() -> AnyObject? {
        var headObject: AnyObject?
        objc_sync_enter(queue)
        if queue.count == 0 {
            return nil
        }
        headObject = queue.object(at: 0) as AnyObject
        if headObject != nil {
            queue.removeObject(at: 0)
        }
        objc_sync_exit(queue)
        return headObject
    }
    
    func enqueue(anObject: AnyObject?) {
        objc_sync_enter(queue)
        if anObject == nil {
            return
        }
        if queue.count >= maxSize {
            queue.removeObject(at: 0)
        }
        queue.add(anObject!)
        objc_sync_exit(queue)
    }
    
    func count() -> Int {
        return queue.count
    }

}
