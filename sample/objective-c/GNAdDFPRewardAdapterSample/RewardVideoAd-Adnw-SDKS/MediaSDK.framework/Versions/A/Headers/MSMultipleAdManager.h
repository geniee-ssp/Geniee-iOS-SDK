//
//  MSMultipleAdManager.h
//  MediaSDK
//
//  Created by 市村 有貴江 on 2017/09/01.
//  Copyright © 2017年 市村 有貴江. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSVideoAdManager.h"

@interface MSMultipleAdManager : NSObject<MSVideoAdDelegate>
{
    NSMutableArray<MSVideoAdManager*>* adManagerArray;
}

- (void) loadRequest;
- (void) addAdMangerObject: (MSVideoAdManager*)adManager;
- (void) stop;

@end
