//
//  AMoAd.h
//
//  Created by AMoAd on 2015/08/05.
//
#ifndef AMoAd_AMoAd_h
#define AMoAd_AMoAd_h

#import <Foundation/Foundation.h>

/// 広告受信結果
typedef NS_ENUM(NSInteger, AMoAdResult) {
  /// 成功
  AMoAdResultSuccess,
  /// 失敗
  AMoAdResultFailure,
  /// 配信する広告が無い
  AMoAdResultEmpty
};

#endif
