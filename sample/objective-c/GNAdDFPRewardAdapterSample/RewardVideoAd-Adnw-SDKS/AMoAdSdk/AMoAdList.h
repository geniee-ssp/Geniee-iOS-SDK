//
//  AMoAdList.h
//  AMoAd
//
//  Created by AMoAd on 2016/02/24.
//
//

#import <Foundation/Foundation.h>
#import "AMoAdItem.h"

/// リストビュー広告オブジェクト
@interface AMoAdList : NSObject

/// 広告オブジェクトの配列
@property (nonatomic,copy) NSArray<AMoAdItem *> *ads;

/// 表示開始位置
@property (nonatomic) NSInteger beginIndex;

/// 表示間隔
@property (nonatomic) NSInteger interval;

+ (AMoAdList *)parseDic:(NSDictionary *)dic;

@end
