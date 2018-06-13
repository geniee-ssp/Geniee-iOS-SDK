//
//  TableViewController.swift
//  GNAdSampleNativeAd
//

import UIKit
import Foundation

class TableViewController: UITableViewController, GNNativeAdRequestDelegate {
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var _loading: Bool = false
    var _secondsStart: TimeInterval = 0.0, _secondsEnd: TimeInterval = 0.0
    var _queueAds: GNQueue = GNQueue(aMaxSize: 100)
    var _cellDataList: NSMutableArray = NSMutableArray()
    
    // Create GNNativeAdRequest
    var _nativeAdRequest: GNNativeAdRequest  = GNNativeAdRequest(id:"YOUR_SSP_APP_ID")

    override func viewDidLoad() {
        super.viewDidLoad()
        _secondsStart = NSDate.timeIntervalSinceReferenceDate()
        
        // Load GNNativeAdRequest
        _nativeAdRequest.delegate = self;
        //_nativeAdRequest.GNAdlogPriority = GNLogPriorityInfo;
        //_nativeAdRequest.geoLocationEnable = true;
        _nativeAdRequest.loadAds()

        requestCellDataListAsync()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // pragma mark - GNNativeAdRequestDelegate
    
    func nativeAdRequestDidReceiveAds(nativeAds: [AnyObject]) {
        _secondsEnd = NSDate.timeIntervalSinceReferenceDate()
        NSLog("TableViewController: nativeAdRequestDidReceiveAds in %f seconds.", (Double)(_secondsEnd - _secondsStart));
        for nativeAd in nativeAds as! [GNNativeAd] {
            // You can identify the GNNativeAd by using the zoneID field of GNNativeAd.
            //if (nativeAd.zoneID == "YOUR_SSP_APP_ID") {
            //    _cellDataList.addObject(nativeAd)
            //}
            _queueAds.enqueue(nativeAd)
        }
    }
    
    func nativeAdRequest(request :GNNativeAdRequest, didFailToReceiveAdsWithError error: NSError) {
        NSLog("TableViewController: didFailToReceiveAdsWithError : %@.", error.localizedDescription);
    }
    
    func shouldStartExternalBrowserWithClick(nativeAd: GNNativeAd, landingURL: String) -> Bool {
        NSLog("TableViewController: shouldStartExternalBrowserWithClick : %@.", landingURL);
        return true;
    }
    
    
    // pragma mark - Get My Cell Data
    
    func requestCellDataListAsync()
    {
        _loading = true
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(0.5 * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(),
            {self.createCellDataList()})
    }
    
    func createCellDataList() {
        for (var i:Int = 0; i < 20; i++) {
            if (_queueAds.count() > 0) {
                let ad: AnyObject? = _queueAds.dequeue()
                if (ad != nil) {
                    _cellDataList.addObject(ad!)
                }
            } else {
                _cellDataList.addObject(MyCellData())
            }
        }
        indicator.stopAnimating()
        self.tableView.reloadData()
        _loading = false
    }

    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _cellDataList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SampleDataCell", forIndexPath: indexPath) as! TableViewCell
        
        if (_cellDataList.objectAtIndex(indexPath.row).isKindOfClass(GNNativeAd)) {
            let nativeAd: GNNativeAd = _cellDataList.objectAtIndex(indexPath.row) as! GNNativeAd
            cell.nativeAd = nativeAd;
            cell.title.text = nativeAd.title;
            cell.content.text = nativeAd.description
            cell.icon.image = nil;
            let url: NSURL = NSURL(string: nativeAd.icon_url)!
            requestImageWithURL(url, completion:{(image: UIImage!, error: NSError!)->Void in
                if (error != nil)
                {
                    return
                }
                cell.icon.image = image
            })
            nativeAd.trackingImpressionWithView(cell)
        } else {
            let myCellData: MyCellData = _cellDataList.objectAtIndex(indexPath.row) as! MyCellData
            cell.nativeAd = nil
            cell.title.text = (myCellData.title as String) + " No.\(indexPath.row + 1)"
            cell.content.text = myCellData.content as String
            cell.icon.image = nil;
            let url: NSURL = myCellData.imgURL
            requestImageWithURL(url, completion:{(image: UIImage!, error: NSError!)->Void in
                if (error != nil || !(url.isEqual(myCellData.imgURL)))
                {
                    return
                }
                cell.icon.image = image
            })
        }
        return cell;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! TableViewCell
        if (cell.nativeAd != nil) {
            cell.nativeAd.trackingClick(cell)
        } else {
            self.performSegueWithIdentifier("selectRow", sender: self)
        }
    }
    
    
    // Request and Create Icon Image
    
    func requestImageWithURL(_ url: NSURL, completion:(image: UIImage!, error: NSError!)->Void)
    {
        var request: NSURLRequest = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(
            request,
            queue:NSOperationQueue.mainQueue(),
            completionHandler:{(response: NSURLResponse?,  data: NSData?, connectionError: NSError?) in
                if (connectionError != nil) {
                    completion(image: nil, error: connectionError)
                    return
                }
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), {
                    var image: UIImage? = UIImage(data:data!)
                    image = self.createIconImageWithImage(image!)
                    dispatch_async(dispatch_get_main_queue(), {
                        completion(image: image, error: nil)
                        return
                    })
                })
            }
        )
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let contentOffsetWidthWindow: CGFloat = self.tableView.contentOffset.y + self.tableView.bounds.size.height
        let heightContent: CGFloat = self.tableView.contentSize.height
        var leachToBottom: Bool = false
        if contentOffsetWidthWindow >= heightContent {leachToBottom = true}
        if (!leachToBottom || _loading) {return}
        indicator.startAnimating()
        
        _secondsStart = NSDate.timeIntervalSinceReferenceDate()
        _nativeAdRequest.loadAds()
        requestCellDataListAsync()
    }
    
    func createIconImageWithImage(image: UIImage) -> UIImage {
        let img: UIImage! = resizedImageWithImage(image,maxPixel: 100)
        return roundedImageWithImage(img, cornerRadius: 10.0, borderWidth: 1.0);
    }
    
    func resizedImageWithImage(image: UIImage, maxPixel: UInt) -> UIImage! {
        var w: CGFloat = image.size.width
        var h: CGFloat = image.size.height
        if (w == 0 || h == 0) {return nil}
        
        let ratio: CGFloat = w / h
        var resized: Bool = false
        
        if (1 < ratio) {
            if (CGFloat(maxPixel) < w) {
                w = CGFloat(maxPixel)
                h = w / ratio
                resized = true
            }
        } else {
            if (CGFloat(maxPixel) < h) {
                h = CGFloat(maxPixel)
                w = h * ratio
                resized = true
            }
        }
        
        var context: CGContextRef
        
        UIGraphicsBeginImageContext(CGSizeMake(w, h))
        context = UIGraphicsGetCurrentContext()!
        CGContextTranslateCTM(context, 0, 0)
        CGContextRotateCTM(context, 0)
        
        CGContextSetInterpolationQuality(context, CGInterpolationQuality.High)
        image.drawInRect(CGRectMake(0, 0, w, h))
        let resultImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return resultImage
    }
    
    func roundedImageWithImage(
        image: UIImage,
        var cornerRadius: CGFloat,
        borderWidth: CGFloat) -> UIImage {
        let maxCornerSize: CGFloat = min(image.size.width, image.size.height) * 0.5;
        if (cornerRadius > maxCornerSize) {
            cornerRadius = maxCornerSize
        }
        
        let h: CGFloat = image.size.height
        let w: CGFloat = image.size.width
        var cimage: CGImageRef = image.CGImage!
        let pC: Int = CGImageGetBitsPerComponent(cimage)
        let pR: Int = pC * 4 * Int(w)
        var colorSpace: CGColorSpaceRef = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.NoneSkipLast.rawValue
        var context: CGContextRef = CGBitmapContextCreate(nil, Int(w), Int(h), pC, pR, colorSpace, bitmapInfo)!
        
        CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0)
        CGContextFillRect(context, CGRectMake(0, 0, w, h))
        
        self.addRoundedCornerPathWithContext(context, width:w, height:h, cornerRadius:cornerRadius)
        CGContextClip(context);
        
        CGContextDrawImage(context, CGRectMake(0, 0, w, h), cimage);
        
        self.addRoundedCornerPathWithContext(context, width:w, height:h, cornerRadius:cornerRadius)
        CGContextSetRGBStrokeColor(context, 0, 0, 0, 1.0)
        CGContextSetLineWidth(context, borderWidth)
        CGContextStrokePath(context)
        
        var clippedImage: CGImage! = CGBitmapContextCreateImage(context)
        var roundedImage: UIImage! = UIImage(CGImage: clippedImage)
        return roundedImage
    }
    
    func addRoundedCornerPathWithContext(context: CGContextRef, width w: CGFloat, height h: CGFloat, cornerRadius r: CGFloat) {
        CGContextBeginPath(context)
        CGContextMoveToPoint(context, 0, r)
        CGContextAddArcToPoint(context, 0, h, r, h, r)
        CGContextAddArcToPoint(context, w, h, w, h-r, r)
        CGContextAddArcToPoint(context, w, 0, w-r, 0, r)
        CGContextAddArcToPoint(context, 0, 0, 0, r, r)
        CGContextClosePath(context)
    }
}
