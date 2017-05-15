//
//  TableViewCell.h
//  GNAdSampleMultipleNative


#import <UIKit/UIKit.h>
#import <GNAdSDK/GNNativeAd.h>

@interface TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) GNNativeAd *nativeAd;

@end
