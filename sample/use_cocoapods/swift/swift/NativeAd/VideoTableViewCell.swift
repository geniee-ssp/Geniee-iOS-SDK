import UIKit

class VideoTableViewCell: UITableViewCell {

    @IBOutlet weak var media: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UILabel!
    weak var nativeAd: GNNativeAd!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
