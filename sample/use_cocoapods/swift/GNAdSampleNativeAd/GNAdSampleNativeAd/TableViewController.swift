//  TableViewController.swift
//  GNAdSampleNativeAd

import UIKit

class TableViewController: UITableViewController, GNNativeAdRequestDelegate {
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var _loading = false
    var _secondsStart: TimeInterval = 0.0, _secondsEnd: TimeInterval = 0.0
    var _queueAds = GNQueue(aMaxSize: 100)
    var _cellDataList = NSMutableArray()
    // Create GNNativeAdRequest
    var _nativeAdRequest: GNNativeAdRequest  = GNNativeAdRequest(id:"YOUR APP ID");

    override func viewDidLoad() {
        super.viewDidLoad()
        _secondsStart = NSDate.timeIntervalSinceReferenceDate
        // Load GNNativeAdRequest
        _nativeAdRequest.delegate = self;
        _nativeAdRequest.loadAds()
        
        // Uncomment the following line to preserve selection between presentations
//         self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: GNNativeAdRequestDelegate
    func nativeAdRequestDidReceiveAds(_ nativeAds: [Any]!) {
        _secondsEnd = NSDate.timeIntervalSinceReferenceDate
        NSLog("TableViewController: nativeAdRequestDidReceiveAds in %f seconds.", (Double)(_secondsEnd - _secondsStart));
        for nativeAd in nativeAds as! [GNNativeAd] {
            _queueAds.enqueue(nativeAd)
        }
    }
    
    func nativeAdRequest(_ request: GNNativeAdRequest!, didFailToReceiveAdsWithError error: Error!) {
        NSLog("AdRequest Failed: %@", error.localizedDescription)
    }
    
    func shouldStartExternalBrowser(withClick nativeAd: GNNativeAd!, landingURL: String!) -> Bool {
        NSLog("TableViewController: shouldStartExternalBrowserWithClick : %@.", landingURL)
        return true
    }
    

    // MARK: UITableViewController
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _cellDataList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SampleDataCell", for: indexPath) as! TableViewCell
        
        if let nativeAd = _cellDataList.object(at: indexPath.row) as? GNNativeAd {
            cell.nativeAd = nativeAd;
            cell.title.text = nativeAd.title;
            cell.content.text = nativeAd.description
            cell.icon.image = nil;
            let url = URL(string: nativeAd.icon_url)!
            requestImageWithURL(url, completion:{(image: UIImage!, error: Error!)->Void in
                if (error != nil) {
                    NSLog("Load Image Failed: %@", error.localizedDescription)
                    return
                }
                cell.icon.image = image
            })
            nativeAd.trackingImpression(with: cell)
        } else {
            let myCellData: MyCellData = _cellDataList.object(at: indexPath.row) as! MyCellData
            cell.nativeAd = nil
            cell.title.text = (myCellData.title as String) + " No.\(indexPath.row + 1)"
            cell.content.text = myCellData.content as String
            cell.icon.image = nil;
            let url = myCellData.imgURL
            requestImageWithURL(url, completion:{(image: UIImage!, error: Error!)->Void in
                if (error != nil) {
                    
                    return
                }
                cell.icon.image = image
            })
        }
        return cell
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetWidthWindow: CGFloat = self.tableView.contentOffset.y + self.tableView.bounds.size.height
        let heightContent: CGFloat = self.tableView.contentSize.height
        var leachToBottom = false
        if contentOffsetWidthWindow >= heightContent {leachToBottom = true}
        if (!leachToBottom || _loading) {return}
        indicator.startAnimating()
        _secondsStart = NSDate.timeIntervalSinceReferenceDate
        _nativeAdRequest.loadAds()
        requestCellDataListAsync()
    }

    func requestImageWithURL(_ url: URL, completion:@escaping (_ image: UIImage?, _ error: Error?)->Void)
    {
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with:request) {(data, response, error) in
            if error != nil {completion(nil, error)}
            guard let data = data else { return }
            let image = UIImage(data: data)
            let icon = self.createIconImageWithImage(image: image!)
            DispatchQueue.main.async {
                completion(icon, nil)
            }
        }.resume()
    }
    
    func createIconImageWithImage(image: UIImage) -> UIImage {
        let img: UIImage! = resizedImageWithImage(image: image,maxPixel: 100)
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
        UIGraphicsBeginImageContext(CGSize(width:w, height:h))
        context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: 0, y:0)
        context.rotate(by: 0)
        
        context.interpolationQuality = CGInterpolationQuality.high
        image.draw(in: CGRect(x:0, y:0, width:w, height:h))
        let resultImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return resultImage
    }

    func roundedImageWithImage(
        image: UIImage,
        cornerRadius: CGFloat,
            borderWidth: CGFloat) -> UIImage {
        let maxCornerSize = min(image.size.width, image.size.height) * 0.5;
        let radius = min(maxCornerSize, cornerRadius)
        let h: CGFloat = image.size.height
        let w: CGFloat = image.size.width
        let cimage = image.cgImage!
        let pC = cimage.bitsPerComponent;
        let pR = pC * 4 * Int(w)
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.noneSkipLast.rawValue
        let context: CGContext = CGContext(data: nil, width: Int(w), height: Int(h), bitsPerComponent: pC, bytesPerRow: pR, space: colorSpace, bitmapInfo: bitmapInfo)!
        
        context.setFillColor(red:1.0, green:1.0, blue:1.0, alpha:1.0)
        context.fill(CGRect(x:0, y:0, width:w, height:h))

        addRoundedCornerPathWithContext(context, width:w, height:h, cornerRadius:radius)
        context.clip()
        context.draw(cimage, in:CGRect(x:0, y:0, width:w, height:h))

        addRoundedCornerPathWithContext(context, width:w, height:h, cornerRadius:radius)
        context.setStrokeColor(red:0, green:0, blue:0, alpha:1.0)
        context.setLineWidth(borderWidth)
        context.strokePath()

        let clippedImage: CGImage! = context.makeImage()
        let roundedImage: UIImage! = UIImage(cgImage: clippedImage)
        return roundedImage
    }
    
    func addRoundedCornerPathWithContext(_ context: CGContext, width w: CGFloat, height h: CGFloat, cornerRadius r: CGFloat) {
        context.beginPath()
        context.move(to: CGPoint(x:0, y:r))
        context.addArc(tangent1End: CGPoint(x:0, y:h), tangent2End: CGPoint(x:r, y:h), radius: r)
        context.addArc(tangent1End: CGPoint(x:w, y:h), tangent2End: CGPoint(x:w, y:h-r), radius: r)
        context.addArc(tangent1End: CGPoint(x:w, y:0), tangent2End: CGPoint(x:w-r, y:0), radius: r)
        context.addArc(tangent1End: CGPoint(x:0, y:0), tangent2End: CGPoint(x:0, y:r), radius: r)
        context.closePath()
    }

    // MARK get My Cell Data
    func requestCellDataListAsync()
    {
        _loading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.createCellDataList()
        }
    }
    
    func createCellDataList() {
        for _ in 0..<20 {
            if let ad = _queueAds.dequeue() as Any?  {
                _cellDataList.add(ad)
            } else {
                _cellDataList.add(MyCellData())
            }
        }
        indicator.stopAnimating()
        self.tableView.reloadData()
        _loading = false
    }
}
