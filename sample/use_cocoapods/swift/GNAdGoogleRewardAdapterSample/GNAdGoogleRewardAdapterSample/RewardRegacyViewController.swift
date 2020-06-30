//
//  RewardRegacyViewController.swift
//  GNAdGoogleRewardAdapterSample
//

import UIKit
import GoogleMobileAds

class RewardRegacyViewController: UIViewController {

    var unitId: String!

    @IBOutlet weak var buttonLoad: UIButton!
    @IBOutlet weak var buttonShow: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        buttonShow.isEnabled = false

        GADRewardBasedVideoAd.sharedInstance().delegate = self
    }

    @IBAction func downButtonLoad(_ sender: Any) {
        buttonLoad.isEnabled = false
        buttonShow.isEnabled = false

        let request = DFPRequest()
        //request.testDevices = [ Util.admobDeviceID() ]
        GADRewardBasedVideoAd.sharedInstance().load(request, withAdUnitID: unitId)
    }
    
    @IBAction func downButtonShow(_ sender: Any) {
        if (GADRewardBasedVideoAd.sharedInstance().isReady) {
            GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: self)
        }
    }

}
// MARK: GADRewardBasedVideoAdDelegate implementation
extension RewardRegacyViewController : GADRewardBasedVideoAdDelegate {
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            didRewardUserWith reward: GADAdReward) {
        print("rewardBasedVideoAd:didRewardUserWith \(reward.type), amount \(reward.amount).")
    }

    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            didFailToLoadWithError error: Error) {
        print("rewardBasedVideoAd:didFailToLoadWithError error =  \(error.localizedDescription)")
        buttonLoad.isEnabled = true
        buttonShow.isEnabled = false
    }

    func rewardBasedVideoAdDidReceive(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("rewardBasedVideoAdDidReceive")
        buttonLoad.isEnabled = true
        buttonShow.isEnabled = true
    }

    func rewardBasedVideoAdDidOpen(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("rewardBasedVideoAdDidOpen")
    }

    func rewardBasedVideoAdDidStartPlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("rewardBasedVideoAdDidStartPlaying : " + (rewardBasedVideoAd.adNetworkClassName?.description)!)
    }

    func rewardBasedVideoAdDidCompletePlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("rewardBasedVideoAdDidCompletePlaying")
    }

    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("rewardBasedVideoAdDidClose")
    }

    func rewardBasedVideoAdWillLeaveApplication(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("rewardBasedVideoAdWillLeaveApplication")
    }

}
