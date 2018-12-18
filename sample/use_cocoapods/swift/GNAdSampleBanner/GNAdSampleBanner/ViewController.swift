//
//  ViewController.swift
//  GNAdSampleBanner

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, GNAdViewDelegate {
    
    @IBOutlet weak var zoneIdText: UITextField!

    var adView: GNAdView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        zoneIdText.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setAdView(_ zoneId: String) {
        adView = GNAdView( adSizeType: GNAdSizeTypeTall, appID: zoneId)
        guard let adView = self.adView else { return }
        adView.delegate = self
        adView.rootViewController = self
        // set log priority
        adView.gnAdlogPriority = GNLogPriorityInfo
        
        self.view.addSubview(adView)
        adView.center = CGPoint(x: self.view.center.x, y: self.view.center.y)
        adView.startAdLoop()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func shouldStartExternalBrowser(withClick adView: GNAdView!, landingURL: String!) -> Bool {
        NSLog("ViewController: shouldStartExternalBrowserWithClick : %@.", landingURL)
        return true
    }
    
    func adViewDidReceiveAd(_ adView: GNAdView!) {
        NSLog("ViewController: Ad View Recieved.")
    }
    
    func adView(_ adView: GNAdView!, didFailReceiveAdWithError error: Error!) {
        adView.stopAdLoop()
        
        NSLog("ViewController: Load Failed. %@", error.localizedDescription)
        let alertController = UIAlertController(title: "Load failed.",
                                                message: String(format:"Detail: %@", error.localizedDescription),
                                                preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK",
                                                style: UIAlertActionStyle.cancel,
                                                handler:nil))
        present(alertController, animated: true, completion: nil)
    }

    @IBAction func showAd(_ sender: Any) {
        adView = nil
        guard let zoneIdStr = zoneIdText.text, !zoneIdStr.isEmpty else {return}
        setAdView(zoneIdStr)
    }
}

