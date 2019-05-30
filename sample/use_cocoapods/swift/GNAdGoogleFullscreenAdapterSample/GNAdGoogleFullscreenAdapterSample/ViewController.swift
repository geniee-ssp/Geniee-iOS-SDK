//
//  ViewController.swift
//  GNAdGoogleFullscreenAdapterSample
//
//  Created by Nguyenthanh Long on 12/17/18.
//  Copyright © 2018 Geniee. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ViewController: UIViewController, UITextFieldDelegate, GADInterstitialDelegate {

    @IBOutlet weak var loadAdButton: UIButton!
    
    @IBOutlet weak var showAdButton: UIButton!
    
    @IBOutlet weak var unitIdTextField: UITextField!
    
    var interstitial: DFPInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        unitIdTextField.delegate = self;
    }
    
    func requestInterstitialAd()  {
        if let idStr = unitIdTextField.text{
            if idStr.isEmpty {
                NSLog("Please input ad unit id.")
                return
            } else {
                interstitial = DFPInterstitial(adUnitID: idStr)
            }
        }
        let request = DFPRequest();
        interstitial.load(request);
        interstitial.delegate = self;
        self.showAdButton.isHidden = true;
        self.loadAdButton.isHidden = true;
    }

    @IBAction func loadInterstitialAd(_ sender: Any) {
        self.requestInterstitialAd()
    }
    
    @IBAction func showInterstitialAd(_ sender: Any) {
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {
            NSLog("Ad wasn't ready.");
        }
    }
    
    //MARK UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard when press return key in a UITextField
        unitIdTextField.resignFirstResponder()
        return true;
    }
    
    //MARK GADInterstitialDelegate
    /// Tells the delegate an ad request succeeded.
    private func interstitialDidReceiveAd(_ ad: DFPInterstitial) {
        print("interstitialDidReceiveAd")
    }
    
    /// Tells the delegate an ad request failed.
    private func interstitial(_ ad: DFPInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that an interstitial will be presented.
    private func interstitialWillPresentScreen(_ ad: DFPInterstitial) {
        print("interstitialWillPresentScreen")
    }
    
    /// Tells the delegate the interstitial is to be animated off the screen.
    private func interstitialWillDismissScreen(_ ad: DFPInterstitial) {
        print("interstitialWillDismissScreen")
    }
    
    /// Tells the delegate the interstitial had been animated off the screen.
    private func interstitialDidDismissScreen(_ ad: DFPInterstitial) {
        print("interstitialDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app
    /// (such as the App Store), backgrounding the current app.
    private func interstitialWillLeaveApplication(_ ad: DFPInterstitial) {
        print("interstitialWillLeaveApplication")
    }
}

