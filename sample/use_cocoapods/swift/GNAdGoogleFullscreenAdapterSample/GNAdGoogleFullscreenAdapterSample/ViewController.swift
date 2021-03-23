//
//  ViewController.swift
//  GNAdGoogleFullscreenAdapterSample
//

import UIKit
import GoogleMobileAds

class ViewController: UIViewController {

    @IBOutlet weak var unitIdView: UITextField!
    @IBOutlet weak var buttonLoad: UIButton!
    @IBOutlet weak var buttonShow: UIButton!

    var interstitial: GAMInterstitialAd!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        unitIdView.delegate = self
        buttonShow.isEnabled = false

        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [Util.admobDeviceID()]
    }
    
    @IBAction func downButtonLoad(_ sender: Any) {
        let unitId = unitIdView.text!
        if unitId.isEmpty {
            return
        }

        let request = GAMRequest()
        GAMInterstitialAd.load(withAdManagerAdUnitID: unitId, request: request, completionHandler: { (ad, error) in
            self.buttonLoad.isEnabled = true
            if let error = error {
                print("ViewController: downButtonLoad error = \(error.localizedDescription)")
                return
            }
            print("ViewController: downButtonLoad ad loaded.")
            self.buttonShow.isEnabled = true
            self.interstitial = ad
            self.interstitial.fullScreenContentDelegate = self
        })

        buttonLoad.isEnabled = false
    }
    
    @IBAction func downButtonShow(_ sender: Any) {
        if let ad = interstitial {
            print("ViewController: downButtonShow show.")
            ad.present(fromRootViewController: self)
        } else {
            print("ViewController: downButtonShow not show.")
        }
    }

}
//MARK GADInterstitialDelegate
extension ViewController : GADFullScreenContentDelegate {
    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("ViewController: adDidPresentFullScreenContent")
    }

    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
      print("ViewController: didFailToPresentFullScreenContentWithError error = \(error.localizedDescription).")
    }

    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("ViewController: adDidDismissFullScreenContent")
        buttonShow.isEnabled = false
        interstitial = nil
    }

}
//MARK GADInterstitialDelegate
extension ViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard when press return key in a UITextField
        unitIdView.resignFirstResponder()
        return true;
    }

}

