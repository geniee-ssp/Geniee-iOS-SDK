//
//  ViewController.swift
//  GenieeFullscreenInterstitialSample
//
//  Created by Nguyen Duy Long on 18/10/24.
//

import UIKit

class ViewController: UIViewController, GNSFullscreenInterstitialAdDelegate {
    
    @IBOutlet weak var loadRewardBt: UIButton!
    @IBOutlet weak var showRewardBt: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadRewardBt.isEnabled = true
        showRewardBt.isEnabled = false
        
        errorLabel.text = ""
        
        GNSFullscreenInterstitialAd.sharedInstance().delegate = self
        
        Log4GNAd.setPriority(GNLogPriorityInfo)
        
    }
    
    // MARK GNSFullscreenInterstitialAdDelegate
    func fullscreenInterstitialDidReceive(_ fullscreenInterstitial: GNSFullscreenInterstitialAd!) {
        NSLog("ViewController: Fullscreen ad is received.")
        loadRewardBt.isEnabled = false
        showRewardBt.isEnabled = true
    }
    
    func fullscreenInterstitial(_ fullscreenInterstitial: GNSFullscreenInterstitialAd!, didFailToLoadWithError error: Error!) {
        NSLog("ViewController: Fullscreen ad failed to load. error: %@", error.localizedDescription)
        
        loadRewardBt.isEnabled = true
        showRewardBt.isEnabled = false
        
        errorLabel.text = error.localizedDescription
        
    }
    
    func fullscreenInterstitialAdDidClose(_ fullscreenInterstitial: GNSFullscreenInterstitialAd!) {
        NSLog("ViewController: Fullscreen ad is closed.")
        loadRewardBt.isEnabled = true
        showRewardBt.isEnabled = false
    }
    
    func fullscreenInterstitialAdDidClick(_ fullscreenInterstitial: GNSFullscreenInterstitialAd!) {
        NSLog("ViewController: Fullscreen ad click.")
    }
    
    func fullscreenInterstitialWillPresentScreen(_ fullscreenInterstitial: GNSFullscreenInterstitialAd!) {
        NSLog("ViewController: Fullscreen ad showing.")
    }
    
    
    @IBAction func onLoadRewardClicked(_ sender: Any) {
        
        let request = GNSRequest()
        
        GNSFullscreenInterstitialAd.sharedInstance().load(request, withZoneID: "1577099")
        
        loadRewardBt.isEnabled = false
        showRewardBt.isEnabled = false
        
        errorLabel.text = ""
    }
    
    
    @IBAction func onShowRewardClicked(_ sender: Any) {
        GNSFullscreenInterstitialAd.sharedInstance().show(self)
    }
    
}
