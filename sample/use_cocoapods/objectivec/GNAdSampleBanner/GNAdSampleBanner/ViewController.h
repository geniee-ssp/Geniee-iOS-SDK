//
//  ViewController.h
//  GNAdSampleBanner
//
//  Created by { Kazunori } on 2018/06/10.
//  Copyright © 2018 Yamamoto Kazunori. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GNAdSDK/GNAdView.h>

@interface ViewController : UIViewController<GNAdViewDelegate>
{
    GNAdView *_adView;
}


@end

