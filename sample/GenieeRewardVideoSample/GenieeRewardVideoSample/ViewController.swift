//
//  ViewController.swift
//  GenieeRewardVideoSample
//
//  Created by Nguyen Duy Long on 18/10/24.
//

import UIKit

class ViewController: UIViewController, GNSRewardVideoAdDelegate {
    
    @IBOutlet weak var loadRewardBt: UIButton!
    @IBOutlet weak var showRewardBt: UIButton!
    
    @IBOutlet weak var userRewardLabel: UILabel!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadRewardBt.isEnabled = true
        showRewardBt.isEnabled = false
        
        userRewardLabel.text = ""
        errorLabel.text = ""
        
        Log4GNAd.setPriority(GNLogPriorityInfo)
        
    }
    
    //MARK GNSRewardVideoAdDelegate
    func rewardVideoAdDidReceive(_ rewardVideoAd: GNSRewardVideoAd!) {
        //            NSLog("ViewController: LongUni Reward video ad is received.%s", GNSRewardVideoAd.sharedInstance().canShow());
        print("ViewController: LongUni Reward video ad is received. ", GNSRewardVideoAd.sharedInstance().canShow())
        loadRewardBt.isEnabled = false
        showRewardBt.isEnabled = true
        
    }
    
    func rewardVideoAd(_ rewardVideoAd: GNSRewardVideoAd!, didRewardUserWith reward: GNSAdReward!) {
        print("ViewController: Reward received type=%@, amount=%lf", reward.type, reward.amount.doubleValue)
        
        userRewardLabel.text = String(format: "Reward received type=%@, amount=%lf", reward.type, reward.amount.doubleValue)
        errorLabel.text = ""
    }
    
    func rewardVideoAd(_ rewardVideoAd: GNSRewardVideoAd!, didFailToLoadWithError error: Error!) {
        print("ViewController: Reward video ad failed to load. error: %@", error.localizedDescription)
        
        loadRewardBt.isEnabled = true
        showRewardBt.isEnabled = false
        
        userRewardLabel.text = ""
        errorLabel.text = error.localizedDescription
    }
    
    func rewardVideoAdDidStartPlaying(_ rewardVideoAd: GNSRewardVideoAd!) {
        print("ViewController: Reward video ad started playing.")
    }
    
    func rewardVideoAdDidClose(_ rewardVideoAd: GNSRewardVideoAd!) {
        print("ViewController: Reward video ad is closed.")
        loadRewardBt.isEnabled = true
        showRewardBt.isEnabled = false
    }
    
    @IBAction func onLoadRewardClicked(_ sender: Any) {
        
        let request = GNSRequest()
        
        GNSRewardVideoAd.sharedInstance()?.load(request, withZoneID: "1246726", isRTB: false)
        
        GNSRewardVideoAd.sharedInstance().delegate = self
        
        loadRewardBt.isEnabled = false
        showRewardBt.isEnabled = false
        
        userRewardLabel.text = ""
        errorLabel.text = ""
    }
    
    
    @IBAction func onShowRewardClicked(_ sender: Any) {
        GNSRewardVideoAd.sharedInstance().show(self)
    }
    
}


