//
//  MediaSDK.h
//  MediaSDK
//
//  Created by 市村 有貴江 on 2016/03/23.
//  Copyright © 2016年 市村 有貴江. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MediaSDK : NSObject

+ (void) setObject:(NSString *)val forKey:(NSString *)key;
+ (void) setNSDictionary:(NSDictionary *)val forKey:(NSString *)key;

// デバックモードに設定します。
+ (void) setDebugOn;

@end
