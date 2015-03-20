//
//  TableViewController.h
//  GNAdSampleMultipleBanner
//

#import <UIKit/UIKit.h>
#import "GNAdViewRequest.h"
#import "GNAdView.h"


@interface TableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, GNAdViewRequestDelegate>
{
    GNAdViewRequest *_adViewRequest;
}

@end
