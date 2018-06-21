//
//  MSPVAEndCard.h
//  MediaSDK
//
//  Created by 市村 有貴江 on 2016/10/07.
//  Copyright © 2016年 市村 有貴江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSPVAEndCard : UIView

@property UIImage *repeatImage;
@property UIButton* repeatButton;
@property UIButton* installButton;
@property UIImage* installImage;
@property UIImageView* appIconView;
@property UILabel* titleText;
@property UIView* backgroundView;

- (void) destroy;
- (void) setCotentsFrame;

@end
