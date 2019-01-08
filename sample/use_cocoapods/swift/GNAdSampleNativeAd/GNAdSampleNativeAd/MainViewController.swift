//
//  MainViewController.swift
//  GNAdSampleNativeAd
//

import UIKit
import Foundation

class MainViewController: UITableViewController {

    @IBOutlet weak var _zoneidTextView: UITextField!
    


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        _zoneidTextView.delegate = self
    }
    //Table Viewのセクション数を指定
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let CellIdentifier: String = "mainTableCell";
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath)

        let label: UILabel = cell.viewWithTag(1) as! UILabel
        var strItem: String = "No item";
        switch (indexPath.row) {
            case 0:
                strItem = "Native video sample";
                break;
            case 1:
                strItem = "Native image sample";
                break;
            case 2:
                strItem = "Simple native video sample";
                break;
            default:
                break;
        }
        label.text = strItem;
    
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height: CGFloat = 60
        return height
    }

    // MARK: - Table View Click
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let zoneid: String = _zoneidTextView.text!
        if (0 == indexPath.row) {
            let videoVC = self.storyboard?.instantiateViewController(withIdentifier:"VideoTableViewController") as! VideoTableViewController
            videoVC.zoneid = zoneid;
            self.navigationController?.pushViewController(videoVC, animated: false)
        } else if (1 == indexPath.row) {
            let imageVC = self.storyboard?.instantiateViewController(withIdentifier: "ImageTableViewController") as! ImageTableViewController
            imageVC.zoneid = zoneid;
            self.navigationController?.pushViewController(imageVC, animated: false)
        } else if (2 == indexPath.row) {
            let simpleVC = self.storyboard?.instantiateViewController(withIdentifier: "SimpleViewController") as! SimpleViewController
            simpleVC.zoneid = zoneid;
            self.navigationController?.pushViewController(simpleVC, animated: false)
        }
    }
}

// MARK: - UITextFieldDelegate
extension MainViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard when press return key in a UITextField
        textField.resignFirstResponder()
        return true;
    }
}

