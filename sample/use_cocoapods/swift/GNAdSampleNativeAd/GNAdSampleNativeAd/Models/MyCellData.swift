//
//  MyCellData.swift
//  GNAdSampleNativeAd
//

class MyCellData: NSObject {
    var imgURL: URL
    var title: NSString
    var content: NSString
    override init() {
        let random:UInt32 = arc4random() % 2
        if (random == 0) {
            imgURL = URL(string: "https://media.gssp.asia/img/bf0/8f2/bf08f28d19c98e2b603a21519a0948f6.png")!
            title = "title"
            content = "description sample : ios"
        } else {
            imgURL = URL(string: "https://media.gssp.asia/img/bae/bbb/baebbb357d7011d4b1a8fee309dbfe56.jpg")!
            title = "title"
            content = "description sample : android"
        }
    }
}

