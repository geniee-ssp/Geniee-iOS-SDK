//
//  ViewController.swift
//  GNAdSampleBanner
//

import UIKit

class ViewController: UIViewController, GNAdViewDelegate {
    
    var _adView : GNAdView = GNAdView(frame: CGRectMake(0, 20, 320, 50),
                                 adSizeType:GNAdSizeTypeSmall,
                                      appID:"YOUR_SSP_APP_ID")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        _adView.delegate = self
        _adView.rootViewController = self
        //_adView.bgColor = YES
        //_adView.geoLocationEnable = YES
        //_adView.GNAdlogPriority = GNLogPriorityInfo
        _adView.center = CGPointMake(self.view.center.x, _adView.center.y);
        
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