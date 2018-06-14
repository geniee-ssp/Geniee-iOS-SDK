//
//  MSPVA.h
//  MediaSDK
//
//  Created by 市村 有貴江 on 2016/09/28.
//  Copyright © 2016年 市村 有貴江. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSPVAViewController.h"

@interface MSPVA : NSObject

+ (bool)execute;
+ (bool)send:(NSString *)key;
+ (bool)send:(NSString *)val forEvent:(NSString *)key;
+ (bool)sendInt:(int)val forEvent:(NSString *)key;
+ (bool)sendBool:(bool)val forEvent:(NSString *)key;
+ (bool)sendNSDictionary:(NSDictionary *)val forEvent:(NSString *)key;
+ (bool)sendNSArray:(NSArray *)val forEvent:(NSString *)key;
+ (void)setDelegate:(id<MSPVAViewControllerDelegate>)d;
+ (id<MSPVAViewControllerDelegate>)delegate;
+ (void)requestAd;
+ (void)requestViewLimit;
+ (NSString*)createMediaUserId;
+ (NSDictionary*)getQueryDictionary:(NSString*)query;
+ (bool)stringEmpty:(NSString*)str;

@end
