//
//  TableViewController.h
//  GNAdSampleMultipleBanner
//

#import <UIKit/UIKit.h>
#import <GNAdSDK/GNAdViewRequest.h>
#import <GNAdSDK/GNAdView.h>


@interface TableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, GNAdViewRequestDelegate>
{
    GNAdViewRequest *_adViewRequest;
}

@end
