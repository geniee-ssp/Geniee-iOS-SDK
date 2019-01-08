//
//  SimpleViewController.swift
//  GNAdSampleNativeAd
//
//  Created by Yazaki Hironobu on 2018/12/28.
//  Copyright © 2018 Geniee. All rights reserved.
//

import UIKit
import Foundation

class SimpleViewController: UIViewController, GNNativeAdRequestDelegate, GNSNativeVideoPlayerDelegate {
    // For view position.
    static let SIZE_GAP = 5;
    static let SIZE_TEXT = 25;
    static let SIZE_MEDIA = 350;

    var zoneid: String = ""
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var rootView: UIView!
    
    var nativeAdRequest: GNNativeAdRequest? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create GNNativeAdRequest
        nativeAdRequest = GNNativeAdRequest(id:zoneid)
        Log4GNAd.setPriority(GNLogPriorityInfo)
        nativeAdRequest?.delegate = self;
        if (zoneid.range(of:",") == nil) {
            nativeAdRequest?.loadAds()
        } else {
            nativeAdRequest?.multiLoadAds()
        }
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

    // MARK: - GNNativeAdRequestDelegate
    
    func nativeAdRequestDidReceiveAds(_ nativeAds: [Any]!) {
        print("nativeAdRequestDidReceiveAds")
        scrollView.contentSize = CGSize(width:Int(scrollView.contentSize.width), height:500*nativeAds.count);
        
        var cnt: Int = 0
        for nativeAd in nativeAds as! [GNNativeAd] {
            createView(_:nativeAd, cnt:cnt);
            cnt = cnt + 1
        }
    }
    
    func nativeAdRequest(_ request :GNNativeAdRequest!, didFailToReceiveAdsWithError error: Error!) {
        print("TableViewController: didFailToReceiveAdsWithError : %@.", error.localizedDescription)
    }
    
    func shouldStartExternalBrowser(withClick nativeAd: GNNativeAd!, landingURL: String!) -> Bool {
        print("TableViewController: shouldStartExternalBrowserWithClick : %@.", landingURL)
        return true
    }

    // MARK: - Internal.

    func createView(_ nativeAd:GNNativeAd, cnt:Int)  {
        let width:Int = Int(self.view.frame.size.width)
        var height: Int = 0;

        // CellView.
        var rect: CGRect = CGRect(x:0, y:(500*cnt), width:Int(scrollView.contentSize.width), height:500)
        let cellView: UIView = UIView(frame: rect)
        rootView.addSubview(cellView);
    
        // Title.
        height = 0;
        rect = CGRect(x:0, y:height, width:width, height:SimpleViewController.SIZE_TEXT);
        let titleView: UILabel = UILabel(frame: rect);
        titleView.backgroundColor = UIColor.blue;
        titleView.text = (nativeAd.title != nil) ? nativeAd.title : "No title";
        titleView.textColor = UIColor.white;
        cellView.addSubview(titleView)
        // Media.
        height += SimpleViewController.SIZE_TEXT + SimpleViewController.SIZE_GAP
        rect = CGRect(x:0, y:height, width:width, height:SimpleViewController.SIZE_MEDIA)
        if (nativeAd.hasVideoContent()) {
            let videoView: GNSNativeVideoPlayerView = getVideoView(rect, nativeAd:nativeAd)
            cellView.addSubview(videoView)
        } else {
            let imageView: UIImageView = UIImageView(frame:rect)
            imageView.contentMode = UIView.ContentMode.scaleAspectFit
            let url = URL(string: nativeAd.icon_url)!
            requestImageWithURL(url, completion:{(image: UIImage!, error: Error!)->Void in
                if (error != nil)
                {
                    return
                }
                imageView.image = image
            })
            cellView.addSubview(imageView)
        }
        // Description.
        let lineNum: Int = 3
        height += SimpleViewController.SIZE_MEDIA + SimpleViewController.SIZE_GAP;
        rect = CGRect(x:0, y:height, width:width, height:SimpleViewController.SIZE_TEXT * lineNum)
        let descriptionView: UILabel = UILabel(frame:rect)
        descriptionView.numberOfLines = lineNum
        descriptionView.text = (nativeAd.description != nil) ? nativeAd.description : "No description"
        descriptionView.textColor = UIColor.black
        descriptionView.sizeToFit()
        cellView.addSubview(descriptionView)
        // Button.
        height += SimpleViewController.SIZE_TEXT * lineNum + SimpleViewController.SIZE_GAP
        rect = CGRect(x:0, y:height, width:width, height:SimpleViewController.SIZE_TEXT)
        let buttonView: SimpleUIButton = SimpleUIButton(frame:rect)
        buttonView.setTitle("Click", for:UIControl.State.normal);
        buttonView.setTitleColor(UIColor.blue, for:UIControl.State.normal)
        buttonView.contentMode = UIView.ContentMode.center
        buttonView.addTarget(self, action:#selector(clickButton(_:)), for:UIControl.Event.touchUpInside)
        buttonView.nativeAd = nativeAd;
        // Button frame.
        buttonView.layer.borderColor = UIColor.blue.cgColor
        buttonView.layer.borderWidth = 1
        cellView.addSubview(buttonView)
        nativeAd.trackingImpression(with: cellView)
    }
    
    func getVideoView(_ rect:CGRect, nativeAd:GNNativeAd) -> GNSNativeVideoPlayerView {
        let videoView: GNSNativeVideoPlayerView = nativeAd.getVideoView(_:rect)
        videoView.nativeDelegate = self
        videoView.load()
        return videoView
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

    @objc func clickButton(_ view:SimpleUIButton) {
        if (view.nativeAd != nil) {
            view.nativeAd.trackingClick(view);
        }
    }

}
