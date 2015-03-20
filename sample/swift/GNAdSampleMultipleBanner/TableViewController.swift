//
//  TableViewController.swift
//  GNAdSampleMultipleBanner
//

import UIKit
import Foundation

class TableViewController: UITableViewController, GNAdViewRequestDelegate {
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var _loading: Bool = false
    var _secondsStart: NSTimeInterval = 0.0, _secondsEnd: NSTimeInterval = 0.0
    var _queueAds: GNQueue = GNQueue(aMaxSize: 100)
    var _cellDataList: NSMutableArray = NSMutableArray()
    
    // Create GNAdViewRequest
    var _adViewRequest: GNAdViewRequest  = GNAdViewRequest(ID:"YOUR_SSP_APP_ID");

    override func viewDidLoad() {
        super.viewDidLoad()
        _secondsStart = NSDate.timeIntervalSinceReferenceDate()
        
        // Load GNAdViewRequest
        _adViewRequest.delegate = self;
        //_adViewRequest.GNAdlogPriority = GNLogPriorityInfo;
        //_adViewRequest.geoLocationEnable = true;
        _adViewRequest.loadAds()

        requestCellDataListAsync()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // pragma mark - GNAdViewRequestDelegate
    
    func gnAdViewRequestDidReceiveAds(gnAdViews: [AnyObject]) {
        _secondsEnd = NSDate.timeIntervalSinceReferenceDate()
        NSLog("TableViewController: nativeAdRequestDidReceiveAds in %f seconds.", (Double)(_secondsEnd - _secondsStart));
        for adView in gnAdViews as [GNAdView] {
            // You can identify the GNAdView by using the zoneID field of GNAdView.
            //if (adView.zoneID == "YOUR_SSP_APP_ID") {
            //    _cellDataList.addObject(adView)
            //}
            _queueAds.enqueue(adView)
        }
    }
    
    func gnAdViewRequest(request :GNAdViewRequest, didFailToReceiveAdsWithError error: NSError) {
        NSLog("TableViewController: didFailToReceiveAdsWithError : %@.", error.localizedDescription);
    }
    
    func shouldStartExternalBrowserWithClick(gnAdView: GNAdView, landingURL: NSString) -> Bool {
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
                var ad: AnyObject? = _queueAds.dequeue()
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
        let cell = tableView.dequeueReusableCellWithIdentifier("SampleDataCell", forIndexPath: indexPath) as TableViewCell
        
        if (_cellDataList.objectAtIndex(indexPath.row).isKindOfClass(GNAdView)) {
            var adView: GNAdView = _cellDataList.objectAtIndex(indexPath.row) as GNAdView
            
            // remove old adview from cell
            if (cell.adView != nil) {
                cell.adView.stopAdLoop()
                cell.adView.removeFromSuperview()
                cell.adView = nil
            }
            cell.title.text = nil
            cell.content.text = nil
            cell.icon.image = nil
            
            // add adView to cell
            cell.addSubview(adView)
            // show adView with frame and adsize
            adView.showBannerWithFrame(CGRectMake(0, 0, 320, 50),
                                       adSize:CGSizeMake(320, 50))
            // start auto-refreshing
            adView.startAdLoop()
            
            cell.adView = adView
        } else {
            var myCellData: MyCellData = _cellDataList.objectAtIndex(indexPath.row) as MyCellData
            // remove old adview from cell
            if (cell.adView != nil) {
                cell.adView.stopAdLoop()
                cell.adView.removeFromSuperview()
                cell.adView = nil
            }
            cell.title.text = myCellData.title + " No.\(indexPath.row + 1)"
            cell.content.text = myCellData.content
            cell.icon.image = nil;
            var url: NSURL = myCellData.imgURL
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
        let cell = tableView.cellForRowAtIndexPath(indexPath) as TableViewCell
        if (cell.adView != nil) {
            //The GNAdView can respond to click
        } else {
            self.performSegueWithIdentifier("selectRow", sender: self)
        }
    }
    
    
    // Request and Create Icon Image
    
    func requestImageWithURL(url: NSURL, completion:(image: UIImage!, error: NSError!)->Void)
    {
        var request: NSURLRequest = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(
            request,
            queue:NSOperationQueue.mainQueue(),
            completionHandler:{(response: NSURLResponse!,  data: NSData!, connectionError: NSError!) in
                if (connectionError != nil) {
                    completion(image: nil, error: connectionError)
                    return
                }
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), {
                    var image: UIImage? = UIImage(data:data)
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
        var contentOffsetWidthWindow: CGFloat = self.tableView.contentOffset.y + self.tableView.bounds.size.height
        var heightContent: CGFloat = self.tableView.contentSize.height
        var leachToBottom: Bool = false
        if contentOffsetWidthWindow >= heightContent {leachToBottom = true}
        if (!leachToBottom || _loading) {return}
        indicator.startAnimating()
        
        _secondsStart = NSDate.timeIntervalSinceReferenceDate()
        _adViewRequest.loadAds()
        requestCellDataListAsync()
    }
    
    func createIconImageWithImage(image: UIImage) -> UIImage {
        var img: UIImage! = resizedImageWithImage(image,maxPixel: 100)
        return roundedImageWithImage(img, cornerRadius: 10.0, borderWidth: 1.0);
    }
    
    func resizedImageWithImage(image: UIImage, maxPixel: UInt) -> UIImage! {
        var w: CGFloat = image.size.width
        var h: CGFloat = image.size.height
        if (w == 0 || h == 0) {return nil}
        
        var ratio: CGFloat = w / h
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
        context = UIGraphicsGetCurrentContext()
        CGContextTranslateCTM(context, 0, 0)
        CGContextRotateCTM(context, 0)
        
        CGContextSetInterpolationQuality(context, kCGInterpolationHigh)
        image.drawInRect(CGRectMake(0, 0, w, h))
        var resultImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
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
        var cimage: CGImageRef = image.CGImage
        let pC: UInt = CGImageGetBitsPerComponent(cimage)
        let pR: UInt = pC * 4 * UInt(w)
        var colorSpace: CGColorSpaceRef = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(CGImageAlphaInfo.NoneSkipLast.rawValue)
        var context: CGContextRef = CGBitmapContextCreate(nil, UInt(w), UInt(h), pC, pR, colorSpace, bitmapInfo)
        
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
