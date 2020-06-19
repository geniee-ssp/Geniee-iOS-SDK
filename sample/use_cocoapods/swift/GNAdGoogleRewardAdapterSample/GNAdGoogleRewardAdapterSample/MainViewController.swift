//
//  MainViewController.swift
//  GNAdGoogleRewardAdapterSample
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var adUnitIdView: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        adUnitIdView.delegate = self
    }

    @IBAction func downButtonRegacyApi(_ sender: Any) {
        let unitId: String! = adUnitIdView.text
        if (unitId.isEmpty) {
            return
        }
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "RewardRegacyViewController") as! RewardRegacyViewController
        vc.unitId = unitId
        self.navigationController?.pushViewController(vc, animated: false)
    }

    @IBAction func downButtonNewApi(_ sender: Any) {
        let unitId: String! = adUnitIdView.text
        if (unitId.isEmpty) {
            return
        }
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "RewardNewViewController") as! RewardNewViewController
        vc.unitId = unitId
        self.navigationController?.pushViewController(vc, animated: false)
    }

}
// MARK: UITextFieldDelegate implementation
extension MainViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard when press return key in a UITextField
        textField.resignFirstResponder()
        return true
    }

}
