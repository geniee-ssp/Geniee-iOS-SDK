//
//  SimpleUIButton.swift
//  GNAdSampleNativeAd
//

import UIKit
import Foundation

class SimpleUIButton: UIButton {
    var nativeAd: GNNativeAd!

//    override init(type:UIButton.ButtonType) {
//        super.init(type: type)
//        self.nativeAd = nil
//    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.nativeAd = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.nativeAd = nil
    }
}
