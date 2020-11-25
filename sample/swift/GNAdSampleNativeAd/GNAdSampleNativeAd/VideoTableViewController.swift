//
//  VideoTableViewController.swift
//  GNAdSampleNativeAd
//

import UIKit
import Foundation

class VideoTableViewController: UITableViewController, GNNativeAdRequestDelegate, GNSNativeVideoPlayerDelegate {
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var zoneid: String = ""
    var _loading: Bool = false
    var _secondsStart: TimeInterval = 0.0, _secondsEnd: TimeInterval = 0.0
    var _queueAds: GNQueue = GNQueue(aMaxSize: 100)
    var _cellDataList: NSMutableArray = NSMutableArray()
    var _nativeAdRequest: GNNativeAdRequest? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        _secondsStart = NSDate.timeIntervalSinceReferenceDate

        // Create GNNativeAdRequest
        _nativeAdRequest = GNNativeAdRequest(id:zoneid)
        // Load GNNativeAdRequest
        _nativeAdRequest?.delegate = self
        //Log4GNAd.setPriority(GNLogPriorityInfo)
        if (zoneid.range(of:",") == nil) {
            _nativeAdRequest?.loadAds()
        } else {
            _nativeAdRequest?.multiLoadAds()
        }

        requestCellDataListAsync()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - GNNativeAdRequestDelegate
    
    func nativeAdRequestDidReceiveAds(_ nativeAds: [Any]!) {
        _secondsEnd = NSDate.timeIntervalSinceReferenceDate
        print("TableViewController: nativeAdRequestDidReceiveAds in %f seconds.", (Double)(_secondsEnd - _secondsStart))
        for nativeAd in nativeAds as! [GNNativeAd] {
            _queueAds.enqueue(anObject: nativeAd)
        }
    }
    
    func nativeAdRequest(_ request :GNNativeAdRequest!, didFailToReceiveAdsWithError error: Error!) {
        print("TableViewController: didFailToReceiveAdsWithError : %@.", error.localizedDescription)
    }
    
    func shouldStartExternalBrowser(withClick nativeAd: GNNativeAd!, landingURL: String!) -> Bool {
        print("TableViewController: shouldStartExternalBrowserWithClick : %@.", landingURL)
        return true
    }
    
    // MARK: - Get My Cell Data
    
    func requestCellDataListAsync()
    {
        _loading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.createCellDataList()
        }
    }
    
    func createCellDataList() {
        let totalCnt = 20
        let adCnt = _queueAds.count()
        for i in 0..<totalCnt {
            if (_queueAds.count() > 0 &&  adCnt > 0 && totalCnt / adCnt > 0 && i % (totalCnt / adCnt) == 0) {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "SampleDataCell", for: indexPath) as! VideoTableViewCell
        // Since the cell is reused, initialize it.
        if (cell.media.subviews.count == 0) {
            // add the tap event.
            setTaqEvent(cell)
        }
        for view in cell.media.subviews {
            if (view.isKind(of: GNSNativeVideoPlayerView.self)) {
                let playerView: GNSNativeVideoPlayerView = view as! GNSNativeVideoPlayerView
                playerView.remove()
            }
            view.removeFromSuperview()
        }

        let rect: CGRect = CGRect(x:0, y:0, width:cell.media.frame.size.width, height:cell.media.frame.size.height)
        if let nativeAd = _cellDataList.object(at: indexPath.row) as? GNNativeAd {
            cell.nativeAd = nativeAd
            cell.title.text = (nativeAd.title != nil) ? nativeAd.title : "No title"
            cell.content.text = (nativeAd.description != nil) ? nativeAd.description : "No description"
            if (nativeAd.hasVideoContent()) {
                // For video.
                let videoView: GNSNativeVideoPlayerView = getVideoView(rect, nativeAd:nativeAd)
                cell.media.addSubview(videoView)
            } else {
                // For image.
                if (nativeAd.icon_url != nil) {
                    let url = URL(string: nativeAd.icon_url)!
                    let imageView: UIImageView = getImageView(_:rect, url:url)
                    cell.media.addSubview(imageView)
                }
            }
            nativeAd.trackingImpression(with: cell)
        } else {
            let myCellData: MyCellData = _cellDataList.object(at:indexPath.row) as! MyCellData
            cell.nativeAd = nil
            cell.title.text = (myCellData.title as String) + " No.\(indexPath.row + 1)"
            cell.content.text = myCellData.content as String
            let url = myCellData.imgURL as URL
            let imageView: UIImageView = getImageView(_:rect, url:url)
            cell.media.addSubview(imageView)
        }
        return cell
    }
    
    func setTaqEvent(_ view:UIView) {
        // Single tap
        let tapSingle: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(tapSingle(_:)))
        tapSingle.numberOfTapsRequired = 1
        tapSingle.numberOfTouchesRequired = 1
        view.addGestureRecognizer(tapSingle)
    }
    
    @objc func tapSingle(_ sender: UITapGestureRecognizer) {
        if (sender.numberOfTouches == 1) {
            let view: VideoTableViewCell = sender.view as! VideoTableViewCell
            if (view.nativeAd != nil) {
                view.nativeAd.trackingClick(view)
            } else {
                self.performSegue(withIdentifier: "selectRow", sender: self)
            }
        }
    }
    
    // MARK: - Scroll view delegate
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetWidthWindow: CGFloat = self.tableView.contentOffset.y + self.tableView.bounds.size.height
        let heightContent: CGFloat = self.tableView.contentSize.height
        var leachToBottom: Bool = false
        if contentOffsetWidthWindow >= heightContent {leachToBottom = true}
        if (!leachToBottom || _loading) {return}
        indicator.startAnimating()
        
        _secondsStart = NSDate.timeIntervalSinceReferenceDate
        if (zoneid.range(of:",") == nil) {
            _nativeAdRequest?.loadAds()
        } else {
            _nativeAdRequest?.multiLoadAds()
        }
        requestCellDataListAsync()
    }
    
    // MARK: - Request and Create Icon Image/video
    
    func getVideoView(_ rect:CGRect, nativeAd:GNNativeAd) -> GNSNativeVideoPlayerView {
        let videoView: GNSNativeVideoPlayerView = nativeAd.getVideoView(_:rect)
        videoView.nativeDelegate = self
        videoView.load()
        return videoView
    }
    
    func getImageView(_ rect:CGRect, url:URL) -> UIImageView {
        let imageView: UIImageView = UIImageView(frame: rect)
        
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        requestImageWithURL(url, completion:{(image: UIImage!, error: Error!)->Void in
            if (error != nil)
            {
                return
            }
            imageView.image = image
        })
        return imageView
    }

    func requestImageWithURL(_ url: URL, completion:@escaping (_ image: UIImage?, _ error: Error?)->Void)
    {
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with:request) {(data, response, error) in
            if error != nil {
                completion(nil, error)
                return
            }
            let image = UIImage(data: data!)
            DispatchQueue.main.async {
                completion(image, nil)
                return
            }
        }.resume()
    }
    
    // MARK: GNSNativeVideoPlayerDelegate Notifications
    
    func onVideoReceiveSetting(_ view:GNSNativeVideoPlayerView) {
        print("onVideoReceiveSetting")
        view.show()
    }
    
    func onVideoFailWithError(_ view:GNSNativeVideoPlayerView, error:Error) {
        print("onVideoFailWithError = %@", error.localizedDescription)
    }

    func onVideoStartPlaying(_ view:GNSNativeVideoPlayerView) {
        print("onVideoStartPlaying")
    }
    
    func onVideoPlayComplete(_ view:GNSNativeVideoPlayerView) {
        print("onVideoPlayComplete")
    }

}
