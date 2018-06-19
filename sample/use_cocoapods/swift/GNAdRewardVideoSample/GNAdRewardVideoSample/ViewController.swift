//
//  ViewController.swift
//  GNAdRewardVideoSample

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, GNSRewardVideoAdDelegate {
    // Constant for coin awards
    private let GAME_OVER_REWARD = 1
    private let GAME_LENGTH = 5

    @IBOutlet weak var zoneIdText: UITextField!
    @IBOutlet weak var coinCountLabel: UILabel!
    @IBOutlet weak var gameLabel: UILabel!
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var showVideoButton: UIButton!

    private var rewardBasedVideoRequestLoading = false
    private var coinCount = 0
    private var counter = 0
    private var timer : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        zoneIdText.delegate = self
        GNSRewardVideoAd.sharedInstance().delegate = self;
        self.earnCoins(coins: 0)
        self.startNewGame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reqestRewardVideo() {
        rewardBasedVideoRequestLoading = true
        
        let request = GNSRequest()
        // set log level
        request.gnAdlogPriority = GNLogPriorityInfo
        if let idStr = zoneIdText.text {
            if idStr.isEmpty {
                NSLog("Please input zone id.")
                showAlert(title: "Please input zone id.",
                          message: "Required zone id to request ad.")
            }
            GNSRewardVideoAd.sharedInstance().load(request, withZoneID: idStr)
        }
    }
    
    func startNewGame() {
        self.reqestRewardVideo()
        self.playAgainButton.isHidden = true
        self.showVideoButton.isHidden = true
        self.counter = GAME_LENGTH
        self.gameLabel.text = String(self.counter)
        self.timer = Timer.scheduledTimer(timeInterval: 1,
                           target: self,
                           selector: #selector(ViewController.decrementCounter),
                           userInfo: nil,
                           repeats: true)
        self.timer!.tolerance = Double(GAME_LENGTH) * 0.1
    }
    
    @objc func decrementCounter(timer: Timer) {
        self.counter -= 1
        if (self.counter > 0) {
            self.gameLabel.text = String(format:"game %d", self.counter)
        } else {
            self.endGame()
        }
    }
    
    func endGame() {
        self.timer!.invalidate()
        self.timer = nil
        self.gameLabel.text = "Game over!"
        if (GNSRewardVideoAd.sharedInstance().canShow()) {
            self.showVideoButton.isHidden = false
        }
        self.playAgainButton.isHidden = false
        
        self.earnCoins(coins: GAME_OVER_REWARD)
    }
    
    func earnCoins(coins: NSInteger) {
        self.coinCount += coins;
        self.coinCountLabel.text = String(format:"Coins: %ld", self.coinCount);
    }

    //MARK GNSRewardVideoAdDelegate
    func rewardVideoAdDidReceive(_ rewardVideoAd: GNSRewardVideoAd!) {
        NSLog("ViewController: Reward video ad is received.");
        self.showVideoButton.isHidden = false
    }
    
    func rewardVideoAd(_ rewardVideoAd: GNSRewardVideoAd!, didRewardUserWith reward: GNSAdReward!) {
        NSLog("ViewController: Reward received type=%@, amount=%lf", reward.type, reward.amount.doubleValue)
        earnCoins(coins: reward.amount.intValue)
    }
    
    func rewardVideoAd(_ rewardVideoAd: GNSRewardVideoAd!, didFailToLoadWithError error: Error!) {
        NSLog("ViewController: Reward video ad failed to load. error: %@", error.localizedDescription)
    }
    
    func rewardVideoAdDidStartPlaying(_ rewardVideoAd: GNSRewardVideoAd!) {
        NSLog("ViewController: Reward video ad started playing.")
    }
    
    func rewardVideoAdDidClose(_ rewardVideoAd: GNSRewardVideoAd!) {
        NSLog("ViewController: Reward video ad is closed.")
        self.showVideoButton.isHidden = true
    }
    
    //MARK UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard when press return key in a UITextField
        textField.resignFirstResponder()
        return true;
    }

    //MARK IBAction
    @IBAction func planAgain(_ sender: Any) {
       self.startNewGame()
    }
    
    @IBAction func showVideo(_ sender: Any) {
        if(GNSRewardVideoAd.sharedInstance().canShow()) {
            GNSRewardVideoAd.sharedInstance().show(self)
        } else {
            showAlert(title: "Reward video not ready",
                      message: "The Reward video didn't finish loading or failed to load or need to reload")
        }
    }
    
    func showAlert(title:String, message:String) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK",
                                                style: UIAlertActionStyle.cancel,
                                                handler:nil))
        present(alertController, animated: true, completion: nil)
    }
}

