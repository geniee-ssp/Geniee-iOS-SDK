//
//  ViewController.swift
//  GNAdSampleBanner
//
//  Created by { Kazunori } on 2018/06/10.
//  Copyright © 2018 Yamamoto Kazunori. All rights reserved.
//

import UIKit

class ViewController: UIViewController,GNAdViewDelegate {

    var adView: GNAdView = GNAdView(frame: CGRect(x: 0, y: 20, width: 320, height: 50)
        , adSizeType: GNAdSizeTypeSmall
        , appID: "YOUR_APP_ID")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adView.delegate = self
        adView.rootViewController = self
        adView.center = CGPoint(x: self.view.center.x
            , y: adView.center.y)
        self.view.addSubview(adView)
        adView.startAdLoop()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func shouldStartExternalBrowser(withClick adView: GNAdView!, landingURL: String!) -> Bool {
        return true
    }

}

