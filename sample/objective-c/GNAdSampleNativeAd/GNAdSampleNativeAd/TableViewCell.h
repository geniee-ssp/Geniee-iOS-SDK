//
//  TableViewCell.h
//  GNAdSampleNativeAd
//

#import <UIKit/UIKit.h>
#import "GNNativeAd.h"

@interface TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *description;
@property (weak, nonatomic) GNNativeAd *nativeAd;

@end
