//
//  TableViewCell.h
//  GNAdSampleMultipleBanner
//

#import <UIKit/UIKit.h>
#import "GNAdView.h"

@interface TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *description;
@property (weak, nonatomic) GNAdView *adView;

@end
