//
//  TableViewController.swift
//  GNAdSampleMultipleBanner
//

import UIKit
import Foundation

class TableViewController: UITableViewController, GNAdViewRequestDelegate {
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var _loading: Bool = false
    var _secondsStart: TimeInterval = 0.0, _secondsEnd: TimeInterval = 0.0
    var _queueAds: GNQueue = GNQueue(aMaxSize: 100)
    var _cellDataList: NSMutableArray = NSMutableArray()
    
    // Create GNAdViewRequest
    var _adViewRequest: GNAdViewRequest  = GNAdViewRequest(id:"APPID1,APPID2,APPID3,...,APPID10");

    override func viewDidLoad() {
        super.viewDidLoad()
        _secondsStart = NSDate.timeIntervalSinceReferenceDate
        
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
    
    func gnAdViewRequestDidReceiveAds(_ gnAdViews: [Any]) {
        _secondsEnd = NSDate.timeIntervalSinceReferenceDate
        NSLog("TableViewController: nativeAdRequestDidReceiveAds in %f seconds.", (Double)(_secondsEnd - _secondsStart));
        for adView in gnAdViews as! [GNAdView] {
            // You can identify the GNAdView by using the zoneID field of GNAdView.
            //if (adView.zoneID == "YOUR_SSP_APP_ID") {
            //    _cellDataList.add(adView)
            //}
            _queueAds.enqueue(anObject: adView)
        }
    }
    
    func gnAdViewRequest(_ request :GNAdViewRequest, didFailToReceiveAdsWithError error: Error) {
        NSLog("TableViewController: didFailToReceiveAdsWithError : %@.", error.localizedDescription);
    }
    
    func shouldStartExternalBrowser(withClick gnAdView: GNAdView, landingURL: String) -> Bool {
        NSLog("TableViewController: shouldStartExternalBrowserWithClick : %@.", landingURL);
        return true;
    }
    
    
    // pragma mark - Get My Cell Data
    
    func requestCellDataListAsync()
    {
        _loading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.createCellDataList()
        }
    }
    
    func createCellDataList() {
        for _ in 0..<20 {
            if (_queueAds.count() > 0) {
                let ad: AnyObject? = _queueAds.dequeue()
                if (ad != nil) {
                    _cellDataList.add(ad!)
                }
            } else {
                _cellDataList.add(MyCellData())
            }
        }
        indicator.stopAnimating()
        self.tableView.reloadData()
        _loading = false
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _cellDataList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SampleDataCell", for: indexPath) as! TableViewCell
        
        if let adView = _cellDataList.object(at: indexPath.row) as? GNAdView {
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
            adView.showBanner(withFrame: CGRect(x:0, y:0, width:320, height:50),
                                       adSize:CGSize(width:320, height:50))
            // start auto-refreshing
            adView.startAdLoop()
            
            cell.adView = adView
        } else {
            let myCellData: MyCellData = _cellDataList.object(at: indexPath.row) as! MyCellData
            // remove old adview from cell
            if (cell.adView != nil) {
                cell.adView.stopAdLoop()
                cell.adView.removeFromSuperview()
                cell.adView = nil
            }
            cell.title.text = (myCellData.title as String) + " No.\(indexPath.row + 1)"
            cell.content.text = myCellData.content as String
            cell.icon.image = nil;
            
            let url = myCellData.imgURL as URL
            requestImageWithURL(url, completion:{(image: UIImage!, error: Error!)->Void in
                if (error != nil)
                {
                    return
                }
                cell.icon.image = image
            })
        }
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TableViewCell
        if (cell.adView != nil) {
            //The GNAdView can respond to click
        } else {
            self.performSegue(withIdentifier: "selectRow", sender: self)
        }
    }

    
    // Request and Create Icon Image
    
    func requestImageWithURL(_ url: URL, completion:@escaping(_ image: UIImage?, _ error: Error?)->Void)
    {
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with:request) {(data, response, error) in
            if error != nil {
                completion(nil, error)
                return
            }
            let image = UIImage(data: data!)
            let icon = self.createIconImageWithImage(image: image!)
            DispatchQueue.main.async {
                completion(icon, nil)
                return
            }
        }.resume()
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetWidthWindow: CGFloat = self.tableView.contentOffset.y + self.tableView.bounds.size.height
        let heightContent: CGFloat = self.tableView.contentSize.height
        var leachToBottom: Bool = false
        if contentOffsetWidthWindow >= heightContent {leachToBottom = true}
        if (!leachToBottom || _loading) {return}
        indicator.startAnimating()
        
        _secondsStart = NSDate.timeIntervalSinceReferenceDate
        _adViewRequest.loadAds()
        requestCellDataListAsync()
    }
    
    func createIconImageWithImage(image: UIImage) -> UIImage {
        let img: UIImage! = resizedImageWithImage(image: image, maxPixel: 100)
        return roundedImageWithImage(image: img, cornerRadius: 10.0, borderWidth: 1.0);
    }
    
    func resizedImageWithImage(image: UIImage, maxPixel: UInt) -> UIImage! {
        var w: CGFloat = image.size.width
        var h: CGFloat = image.size.height
        if (w == 0 || h == 0) {return nil}
        
        let ratio: CGFloat = w / h
        if (1 < ratio) {
            if (CGFloat(maxPixel) < w) {
                w = CGFloat(maxPixel)
                h = w / ratio
            }
        } else {
            if (CGFloat(maxPixel) < h) {
                h = CGFloat(maxPixel)
                w = h * ratio
            }
        }
        
        var context: CGContext
        
        UIGraphicsBeginImageContext(CGSize(width: w, height: h))

        context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: 0, y: 0)
        context.rotate(by: 0)
        
        context.interpolationQuality = .high
        image.draw(in: CGRect(x: 0, y: 0, width: w, height: h))
        let resultImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return resultImage
    }
    
    func roundedImageWithImage(
        image: UIImage,
        cornerRadius: CGFloat,
        borderWidth: CGFloat) -> UIImage {
        let maxCornerSize: CGFloat = min(image.size.width, image.size.height) * 0.5;
        let radius = min(maxCornerSize, cornerRadius)
        let h: CGFloat = image.size.height
        let w: CGFloat = image.size.width
        let cimage: CGImage = image.cgImage!
        let pC: Int = cimage.bitsPerComponent
        let pR: Int = pC * 4 * Int(w)
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.noneSkipLast.rawValue
        let context: CGContext = CGContext(data: nil, width: Int(w), height: Int(h), bitsPerComponent: pC, bytesPerRow: pR, space: colorSpace, bitmapInfo: bitmapInfo)!

        context.setFillColor(red:1.0, green:1.0, blue:1.0, alpha:1.0)
        context.fill(CGRect(x:0, y:0, width:w, height:h))

        addRoundedCornerPathWithContext(context: context, width:w, height:h, cornerRadius:radius)
        context.clip()
        context.draw(cimage, in:CGRect(x:0, y:0, width:w, height:h))

        addRoundedCornerPathWithContext(context: context, width:w, height:h, cornerRadius:radius)
        context.setStrokeColor(red:0, green:0, blue:0, alpha:1.0)
        context.setLineWidth(borderWidth)
        context.strokePath()

        let clippedImage: CGImage! = context.makeImage()
        let roundedImage: UIImage! = UIImage(cgImage: clippedImage)
        return roundedImage
    }

    func addRoundedCornerPathWithContext(context: CGContext, width w: CGFloat, height h: CGFloat, cornerRadius r: CGFloat) {
        context.beginPath()
        context.move(to: CGPoint(x:0, y:r))
        context.addArc(tangent1End: CGPoint(x:0, y:h), tangent2End: CGPoint(x:r, y:h), radius: r)
        context.addArc(tangent1End: CGPoint(x:w, y:h), tangent2End: CGPoint(x:w, y:h-r), radius: r)
        context.addArc(tangent1End: CGPoint(x:w, y:0), tangent2End: CGPoint(x:w-r, y:0), radius: r)
        context.addArc(tangent1End: CGPoint(x:0, y:0), tangent2End: CGPoint(x:0, y:r), radius: r)
        context.closePath()
    }
}
