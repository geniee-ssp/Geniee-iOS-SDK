//
//  TableViewController.swift
//  GNAdSampleMultipleNative

import UIKit
import Foundation

class TableViewController: UITableViewController {
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var loading: Bool = false
    var secondsStart: TimeInterval = 0.0, secondsEnd: TimeInterval = 0.0
    var queueAds: GNQueue = GNQueue(aMaxSize: 50)
    var cellDataList: NSMutableArray = NSMutableArray()
    
    var nativeAdRequest: GNNativeAdRequest = GNNativeAdRequest(id: "YOUR_APP_SSP_ID")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        secondsStart = Date.timeIntervalSinceReferenceDate
        
        // Load GNNativeAdRequest
        nativeAdRequest.delegate = self
        nativeAdRequest.gnAdlogPriority = GNLogPriorityInfo
        nativeAdRequest.geoLocationEnable = true
        loading = true

        nativeAdRequest.multiLoadAds()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Get My Cell Data
    
    func createCellDataList() {
        for _ in 0 ..< 10 {
            if queueAds.count() > 0 {
                let ad: AnyObject? = queueAds.dequeue()
                if ad != nil {
                    cellDataList.add(ad!)
                }
            } else {
                cellDataList.add(MyCellData())
            }
        }
        indicator.stopAnimating()
        self.tableView.reloadData()
        loading = false
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cellDataList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SampleDataCell", for: indexPath) as! TableViewCell
        let isAdCell = cellDataList.object(at: indexPath.row) is GNNativeAd
        
        cell.icon.layer.borderColor = UIColor.black.cgColor
        cell.icon.layer.borderWidth = 1
        cell.icon.layer.cornerRadius = 10
        cell.icon.layer.masksToBounds = true
        
        if isAdCell {
            let nativeAd: GNNativeAd = cellDataList.object(at: indexPath.row) as! GNNativeAd
            cell.nativeAd = nativeAd
            cell.title.text = nativeAd.title
            cell.content.text = nativeAd.description
            cell.icon.image = nil
            let url: URL = URL(string: nativeAd.icon_url)!
            requestImageWithURL(url: url, completion: {(image: UIImage!, error: NSError?) -> Void in
                if error != nil {
                    return
                }
                cell.icon.image = image
            })
            nativeAd.trackingImpression(with: cell)
        } else {
            let myCellData: MyCellData = cellDataList.object(at: indexPath.row) as! MyCellData
            cell.nativeAd = nil
            cell.title.text = (myCellData.title as String) + " No.\(indexPath.row + 1)"
            cell.content.text = myCellData.content as String
            cell.icon.image = nil
            let url: URL = myCellData.imgURL as URL
            requestImageWithURL(url: url, completion: {(image: UIImage!, error: NSError?) -> Void in
                if error != nil {
                    return
                }
                cell.icon.image = image
            })
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TableViewCell
        if cell.nativeAd != nil {
            cell.nativeAd.trackingClick(cell)
        } else {
            self.performSegue(withIdentifier: "selectRow", sender: self)
        }
    }
    
    // MARK: - UIScrollViewDelegate
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetWidthWindow: CGFloat = self.tableView.contentOffset.y + self.tableView.bounds.size.height
        let heightContent: CGFloat = self.tableView.contentSize.height
        var leachToBottom: Bool = false
        if contentOffsetWidthWindow >= heightContent { leachToBottom = true }
        if (!leachToBottom || loading) { return }
        indicator.startAnimating()
        
        secondsStart = Date.timeIntervalSinceReferenceDate
        loading = true
        nativeAdRequest.multiLoadAds()
    }
    
    
    func requestImageWithURL(url: URL, completion:@escaping (_ image: UIImage?, _ error: NSError?)->Void) {
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let response = response {
                print(response)
                let image: UIImage? = UIImage(data: data)
                DispatchQueue.main.async {
                    completion(image, error as NSError?)
                    return
                }
            } else {
                print(error ?? "Error")
            }
        }
        task.resume()
    }
}


// MARK: - GNNativeAdRequestDelegate

extension TableViewController: GNNativeAdRequestDelegate {
    
    func nativeAdRequestDidReceiveAds(_ nativeAds: [Any]!) {
        secondsEnd = Date.timeIntervalSinceReferenceDate
        NSLog("TableViewController: nativeAdRequestDidReceiveAds in %f seconds.", (Double)(secondsEnd - secondsStart));
        for nativeAd in nativeAds as! [GNNativeAd] {
            queueAds.enqueue(anObject: nativeAd)
        }
        createCellDataList()
    }
    
    func nativeAdRequest(_ request: GNNativeAdRequest!, didFailToReceiveAdsWithError error: Error!)
    {
        NSLog("TableViewController: didFailToReceiveAdsWithError : %@.", error.localizedDescription);
        createCellDataList()
    }
    
    func shouldStartExternalBrowser(withClick nativeAd: GNNativeAd!, landingURL: String!) -> Bool {
        NSLog("TableViewController: shouldStartExternalBrowserWithClick : %@.", landingURL);
        return true;
    }
}

