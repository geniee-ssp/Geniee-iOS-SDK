//
//  ViewController.swift
//  GNAdGoogleFullscreenAdapterSample
//
//  Created by Nguyenthanh Long on 12/17/18.
//  Copyright © 2018 Geniee. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var loadAdButton: UIButton!
    
    @IBOutlet weak var showAdButton: UIButton!
    
    @IBOutlet weak var unitIdTextField: UITextField!
    
    var interstitial: DFPInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        unitIdTextField.delegate = self;
        self.showAdButton.isHidden = true;
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
        interstitial.delegate = self;
        interstitial.load(request);
    }

    @IBAction func loadInterstitialAd(_ sender: Any) {
        self.requestInterstitialAd()
    }
    
    @IBAction func showInterstitialAd(_ sender: Any) {
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
            self.showAdButton.isHidden = true;
        } else {
            print("Ad wasn't ready.");
        }
    }
    
    //MARK UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard when press return key in a UITextField
        unitIdTextField.resignFirstResponder()
        return true;
    }
    
}
//MARK GADInterstitialDelegate
extension ViewController : GADInterstitialDelegate {
    /// Tells the delegate an ad request succeeded.
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("interstitialDidReceiveAd")
        self.showAdButton.isHidden = false;
    }
    
    /// Tells the delegate an ad request failed.
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that an interstitial will be presented.
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        print("interstitialWillPresentScreen")
    }
    
    /// Tells the delegate the interstitial is to be animated off the screen.
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        print("interstitialWillDismissScreen")
    }
    
    /// Tells the delegate the interstitial had been animated off the screen.
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        print("interstitialDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app
    /// (such as the App Store), backgrounding the current app.
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        print("interstitialWillLeaveApplication")
    }
}

