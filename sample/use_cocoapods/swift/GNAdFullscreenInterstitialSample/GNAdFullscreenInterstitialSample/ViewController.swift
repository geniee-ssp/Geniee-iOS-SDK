//
//  ViewController.swift
//  GNAdFullscreenInterstitialSample
//
//  Created by Nguyenthanh Long on 12/17/18.
//  Copyright © 2018 Geniee. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, GNSFullscreenInterstitialAdDelegate {
    @IBOutlet weak var loadAdButton: UIButton!
    
    @IBOutlet weak var showAdButton: UIButton!
    
    @IBOutlet weak var zoneIdText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        zoneIdText.delegate = self;
        GNSFullscreenInterstitialAd.sharedInstance().delegate = self;
    }
    
    func requestInterstitialAd() {
        let request = GNSRequest()
        // set log level
        request.gnAdlogPriority = GNLogPriorityInfo
        if let idStr = zoneIdText.text {
            if idStr.isEmpty {
                NSLog("Please input zone id.")
                showAlert(title: "Please input zone id.",
                          message: "Required zone id to request ad.")
            }
            GNSFullscreenInterstitialAd.sharedInstance().load(request, withZoneID: idStr)
        }
        self.showAdButton.isHidden = true;
        self.loadAdButton.isHidden = true;
    }

    @IBAction func loadInterstitialAd(_ sender: Any) {
        self.requestInterstitialAd();
    }
    
    @IBAction func showInterstitialAd(_ sender: Any) {
        if(GNSFullscreenInterstitialAd.sharedInstance().canShow()) {
            GNSFullscreenInterstitialAd.sharedInstance().show(self)
        } else {
            showAlert(title: "Fullscreen interstitial not ready",
                      message: "The Fullscreen interstitial didn't finish loading or failed to load or need to reload")
        }
    }
    
    // MARK GNSFullscreenInterstitialAdDelegate
    func fullscreenInterstitialDidReceive(_ fullscreenInterstitial: GNSFullscreenInterstitialAd!) {
        NSLog("ViewController: Fullscreen ad is received.")
        self.showAdButton.isHidden = false;
        self.loadAdButton.isHidden = false;
    }
    
    func fullscreenInterstitial(_ fullscreenInterstitial: GNSFullscreenInterstitialAd!, didFailToLoadWithError error: Error!) {
        NSLog("ViewController: Fullscreen ad failed to load. error: %@", error.localizedDescription)

    }
    
    func fullscreenInterstitialAdDidClose(_ fullscreenInterstitial: GNSFullscreenInterstitialAd!) {
        NSLog("ViewController: Fullscreen ad is closed.")
    }
    
    func fullscreenInterstitialAdDidClick(_ fullscreenInterstitial: GNSFullscreenInterstitialAd!) {
        NSLog("ViewController: Fullscreen ad click.")
    }
    
    func fullscreenInterstitialWillPresentScreen(_ fullscreenInterstitial: GNSFullscreenInterstitialAd!) {
        NSLog("ViewController: Fullscreen ad showing.")
    }
    
    
    //MARK UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard when press return key in a UITextField
        textField.resignFirstResponder()
        return true;
    }
    
    func showAlert(title:String, message:String) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK",
                                                style: UIAlertAction.Style.cancel,
                                                handler:nil))
        present(alertController, animated: true, completion: nil)
    }
}

