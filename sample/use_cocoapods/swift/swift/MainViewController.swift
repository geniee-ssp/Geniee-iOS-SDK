import UIKit
import GoogleMobileAds

class MainViewController: UIViewController, UIScrollViewDelegate, GNAdViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [Util.admobDeviceID()]
        
        scrollView.contentSize = CGSizeMake(0, 1000)
        
        createButton(title:"Banner", y:360).addTarget(self, action: #selector(showBanner), for: .touchUpInside)
        createButton(title:"Fullscreen Interstitial", y:270).addTarget(self, action: #selector(showFullscreenInterstitial), for: .touchUpInside)
        createButton(title:"Reward Video", y:180).addTarget(self, action: #selector(showRewardVideo), for: .touchUpInside)
        createButton(title:"Google Banner", y:90).addTarget(self, action: #selector(showGoogleBanner), for: .touchUpInside)
        createButton(title:"Google Fullscreen Interstitial", y:0).addTarget(self, action: #selector(showGoogleFullscreenInterstitial), for: .touchUpInside)
        createButton(title:"Google Reward", y:-90).addTarget(self, action: #selector(showGoogleReward), for: .touchUpInside)
        createButton(title:"Multiple Banner", y:-180).addTarget(self, action: #selector(showMultipleBanner), for: .touchUpInside)
        createButton(title:"Native", y:-270).addTarget(self, action: #selector(showNative), for: .touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createButton(title:String, y:CGFloat) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.frame = CGRectMake(self.view.center.x - 125, self.view.center.y - y, 250, 80)
        button.layer.cornerRadius = 10
        scrollView.addSubview(button)
        return button
    }
    
    func showViewController(_ vc:UIViewController) {
        vc.modalPresentationStyle = .popover
        present(vc, animated: true, completion: nil)
    }

    func showStoryboard(_ nameAndId:String) {
        let storyboard = UIStoryboard(name:nameAndId, bundle:nil)
        let vc = storyboard.instantiateViewController(withIdentifier: nameAndId)
        vc.modalPresentationStyle = .popover
        present(vc, animated: true, completion: nil)
    }

    @objc func showBanner() {
        showStoryboard("Banner")
    }
    
    @objc func showFullscreenInterstitial() {
        showStoryboard("FullscreenInterstitial")
    }
    
    @objc func showRewardVideo() {
        showStoryboard("RewardVideo")
    }
    
    @objc func showGoogleBanner() {
        showStoryboard("GoogleBanner")
    }
    
    @objc func showGoogleFullscreenInterstitial() {
        showStoryboard("GoogleFullscreenInterstitial")
    }
    
    @objc func showGoogleReward() {
        showStoryboard("GoogleReward")
    }
    
    @objc func showMultipleBanner() {
        showStoryboard("MultipleBanner")
    }
    
    @objc func showNative() {
        showStoryboard("Native")
    }
}
