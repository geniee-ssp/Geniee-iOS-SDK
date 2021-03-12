//
//  ViewController.swift
//  GNAdGoogleRewardAdapterSample
//

import UIKit
import GoogleMobileAds

class ViewController: UIViewController {

    var unitId: String!
    var rewardedAd: GADRewardedAd!

    @IBOutlet weak var unitIdView: UITextField!
    @IBOutlet weak var buttonLoad: UIButton!
    @IBOutlet weak var buttonShow: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        buttonShow.isEnabled = false

        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ Util.admobDeviceID() ]
    }

    @IBAction func downButtonLoad(_ sender: Any) {
        let unitId = unitIdView.text
        if (unitId!.isEmpty) {
            return
        }

        let request = GAMRequest()
        GADRewardedAd.load(withAdUnitID: unitId!, request: request, completionHandler: { (ad, error) in
            self.buttonLoad.isEnabled = true
            if let error = error {
                print("ViewController: downButtonLoad error = \(error.localizedDescription)")
                return
            }
            print("ViewController: downButtonLoad ad loaded.")
            self.buttonShow.isEnabled = true
            self.rewardedAd = ad
            self.rewardedAd?.fullScreenContentDelegate = self
        })

        buttonLoad.isEnabled = false
    }
    
    @IBAction func downButtonShow(_ sender: Any) {
        if let ad = rewardedAd {
            print("ViewController: downButtonShow show.")
            ad.present(fromRootViewController: self, userDidEarnRewardHandler: {
                let reward = ad.adReward
                print("ViewController: rewardedAd:userDidEarnRewardHandler type = \(reward.type), amount = \(reward.amount).")
            })
        } else {
            print("ViewController: downButtonShow not show.")
        }
    }
    
}
// MARK: GADFullScreenContentDelegate implementation
extension ViewController : GADFullScreenContentDelegate {
    /// Tells the delegate that the rewarded ad was presented.
    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("ViewController: adDidPresentFullScreenContent")
    }

    /// Tells the delegate that the rewarded ad was dismissed.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("ViewController: adDidDismissFullScreenContent")
        buttonShow.isEnabled = false
        rewardedAd = nil
    }

    /// Tells the delegate that the rewarded ad failed to present.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("ViewController: didFailToPresentFullScreenContentWithError error = \(error.localizedDescription)")
    }

}

