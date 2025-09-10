#import <UIKit/UIKit.h>
#import <GNAdSDK/GNNativeAd.h>

@interface ImageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *description;
@property (weak, nonatomic) GNNativeAd *nativeAd;

@end

