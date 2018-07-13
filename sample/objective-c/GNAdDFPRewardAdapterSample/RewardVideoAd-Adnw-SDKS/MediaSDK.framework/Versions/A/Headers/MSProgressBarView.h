//
//  MSProgressBarView.h
//  MediaSDK
//
//  Created by 市村 有貴江 on 2016/04/07.
//  Copyright © 2016年 市村 有貴江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSProgressBarView : UIView

@property UIImageView* imageView;
@property UILabel *label;
@property UIImage* image;

- (void)setProgressPercentage:(NSInteger)percent;
- (void)destroy;

@end
