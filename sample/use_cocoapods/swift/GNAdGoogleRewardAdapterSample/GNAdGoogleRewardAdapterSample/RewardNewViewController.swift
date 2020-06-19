//
//  RewardNewViewController.swift
//  GNAdGoogleRewardAdapterSample
//

import UIKit
import GoogleMobileAds

class RewardNewViewController: UIViewController {

    var unitId: String!
    var rewardedAd: GADRewardedAd!

    @IBOutlet weak var buttonLoad: UIButton!
    @IBOutlet weak var buttonShow: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        buttonShow.isEnabled = false
    }

    @IBAction func downButtonLoad(_ sender: Any) {
        rewardedAd = GADRewardedAd(adUnitID: unitId)
        let request = GADRequest()
        //request.testDevices = [ Util.admobDeviceID() ]
        rewardedAd.load(request) { error in
            self.buttonLoad.isEnabled = true
            if let error = error {
                print("loadRequest error = \(error.localizedDescription)")
            } else {
                self.buttonShow.isEnabled = true
            }
        }
        buttonLoad.isEnabled = false;
    }
    
    @IBAction func downButtonShow(_ sender: Any) {
        if (rewardedAd.isReady) {
            rewardedAd.present(fromRootViewController: self, delegate: self)
        }
    }
    
}
// MARK: GADRewardedAdDelegate implementation
extension RewardNewViewController : GADRewardedAdDelegate {

    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
        print("rewardedAd:userDidEarn \(reward.type), amount \(reward.amount).")
    }

    func rewardedAdDidPresent(_ rewardedAd: GADRewardedAd) {
        print("rewardedAdDidPresent")
    }

    func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
        print("rewardedAdDidDismiss")
        buttonShow.isEnabled = false
    }

    func rewardedAd(_ rewardedAd: GADRewardedAd, didFailToPresentWithError error: Error) {
        print("rewardedAd:didFailToPresentWithError error = \(error.localizedDescription)")
    }

}
