//
//  ViewController.swift
//  GNAdGoogleBannerAdapterSample
//

import UIKit
import GoogleMobileAds

class ViewController: UIViewController {

    @IBOutlet weak var unitIdView: UITextField!
    @IBOutlet weak var adSizeView: UIPickerView!
    
    private var adSizeList: [String] = []
    private var adSizeIndex = 0
    private var bannerView: GAMBannerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        adSizeView.delegate = self
        adSizeView.dataSource = self
        unitIdView.delegate = self
        setAdSizeArray()

        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [Util.admobDeviceID()]
    }

    private func setAdSizeArray() {
        adSizeList.append("Select AdSizeType")
        adSizeList.append("Banner")             // 320x50
        adSizeList.append("MediumRectangle")    // 300x250
    }

    private func getAdSizeType(_ index: Int) -> GADAdSize {
        var adSizeType: GADAdSize = kGADAdSizeInvalid
        switch (index) {
            case 1:
                adSizeType = kGADAdSizeBanner
                break
            case 2:
                adSizeType = kGADAdSizeMediumRectangle
                break
            default:
                adSizeType = kGADAdSizeInvalid
                break
        }
        return adSizeType
    }

    @IBAction func loadDownButton(_ sender: Any) {
        if (unitIdView.text?.count == 0) {
            return
        }
        if (adSizeIndex == 0) {
            return
        }
        if (self.bannerView != nil) {
            self.bannerView.removeFromSuperview()
            self.bannerView.delegate = nil
            self.bannerView = nil
        }

        // Instantiate the banner view with your desired banner size.
        self.bannerView = GAMBannerView.init(adSize: getAdSizeType(adSizeIndex))
        self.addBannerViewToView(self.bannerView)
        self.bannerView.adUnitID = unitIdView.text
        self.bannerView.delegate = self
        self.bannerView.rootViewController = self
        let request: GAMRequest = GAMRequest.init()
        self.bannerView.load(request)
    }
    

    func addBannerViewToView(_ bannerView: UIView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)

        view.addConstraint(NSLayoutConstraint(item: bannerView,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .centerX,
                                              multiplier: 1,
                                              constant: 0))
        view.addConstraint(NSLayoutConstraint(item: bannerView,
                                              attribute: .bottom,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .bottom,
                                              multiplier: 1,
                                              constant: -20))
    }

}
// MARK: - GADBannerViewDelegate
extension ViewController: GADBannerViewDelegate {
    /// Tells the delegate an ad request loaded an ad.
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("ViewController: bannerViewDidReceiveAd")
    }

    /// Tells the delegate an ad request failed.
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("ViewController: didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

}
// MARK: - UIPickerViewDataSource
extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return adSizeList.count
    }

}
// MARK: - UIPickerViewDelegate
extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return adSizeList[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        adSizeIndex = pickerView.selectedRow(inComponent: 0)
    }

}
// MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard when press return key in a UITextField
        textField.resignFirstResponder()
        return true
    }

}
