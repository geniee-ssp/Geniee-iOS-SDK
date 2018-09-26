//
//  ViewController.swift
//  GNAdDFPRewardedAdapterSample
//

import GoogleMobileAds
import UIKit

class ViewController: UIViewController {

    /// The reward-based video ad.
    var rewardBasedVideo: GADRewardBasedVideoAd?
    
    @IBOutlet weak var unitIdTextField: UITextField!
    @IBOutlet weak var loadButton: UIButton!
    @IBOutlet weak var showButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        unitIdTextField.delegate = self
        rewardBasedVideo = GADRewardBasedVideoAd.sharedInstance()
        rewardBasedVideo?.delegate = self
        loadButton.isHidden = false
        showButton.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Button actions
    @IBAction func touchLoadButton(_ sender: Any) {
        if rewardBasedVideo?.isReady == false {
            rewardBasedVideo?.load(DFPRequest(),
                                   withAdUnitID: unitIdTextField.text!)
            loadButton.isHidden = true;
        }
    }
    
    @IBAction func touchShowButton(_ sender: Any) {
        if rewardBasedVideo?.isReady == true {
            rewardBasedVideo?.present(fromRootViewController: self)
            loadButton.isHidden = false
            showButton.isHidden = true
        }
    }
}
// MARK: GADRewardBasedVideoAdDelegate implementation
extension ViewController : GADRewardBasedVideoAdDelegate {
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            didFailToLoadWithError error: Error) {
        print("Reward based video ad failed to load: \(error.localizedDescription)")
        loadButton.isHidden = false
    }
    
    func rewardBasedVideoAdDidReceive(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad is received.")
        showButton.isHidden = false
    }
    
    func rewardBasedVideoAdDidOpen(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Opened reward based video ad.")
    }
    
    func rewardBasedVideoAdDidStartPlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad started playing. : " + (rewardBasedVideoAd.adNetworkClassName?.description)!)
    }
    
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad is closed.")
    }
    
    func rewardBasedVideoAdWillLeaveApplication(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad will leave application.")
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            didRewardUserWith reward: GADAdReward) {
        print("Reward received with currency: \(reward.type), amount \(reward.amount).")
    }
}
// MARK: UITextFieldDelegate implementation
extension ViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard when press return key in a UITextField
        textField.resignFirstResponder()
        return true;
    }
}

