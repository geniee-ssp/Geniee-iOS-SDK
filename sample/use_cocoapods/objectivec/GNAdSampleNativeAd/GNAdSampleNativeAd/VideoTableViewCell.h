//
//  VideoTableViewCell.h
//  GNAdSampleNativeAd
//

#import <UIKit/UIKit.h>
#import <GNAdSDK/GNNativeAd.h>
#import <GNAdSDK/GNSNativeVideoPlayerView.h>

@interface VideoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *media;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *description;
@property (weak, nonatomic) GNNativeAd *nativeAd;

@end

