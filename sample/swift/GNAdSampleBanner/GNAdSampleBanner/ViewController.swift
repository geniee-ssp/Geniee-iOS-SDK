//
//  ViewController.swift
//  GNAdSampleBanner
//

import UIKit

class ViewController: UIViewController, GNAdViewDelegate {
    
    var _adView : GNAdView = GNAdView(adSizeType:GNAdSizeTypeSmall, appID:"YOUR_ZONE_ID")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        _adView.delegate = self
        _adView.rootViewController = self
        //_adView.bgColor = YES
        //_adView.geoLocationEnable = YES
        //_adView.gnAdlogPriority = GNLogPriorityInfo
        _adView.center = CGPoint(x: self.view.center.x, y: self.view.center.y);
        
        self.view.addSubview(_adView)
        _adView.startAdLoop()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func shouldStartExternalBrowserWithClick(nativeAd: GNAdView, landingURL: String) -> Bool {
        NSLog("ViewController: shouldStartExternalBrowserWithClick : %@.", landingURL);
        return true;
    }

}
