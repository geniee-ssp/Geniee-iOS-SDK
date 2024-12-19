//
//  GNSInternalVASTPlayer.h
//  GNAdSDK
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "GNSInternalVASTXmlParser.h"

extern NSString *const GNSVASTPlayerErrorDomain;

@class GNSInternalVASTPlayer;

@protocol GNSInternalVASTPlayerControllerDelegate <NSObject>
- (CGFloat)getInViewSizeRatio:(BOOL)isCurrent;
@optional
- (void)itemDidReadyToPlay:(AVPlayerItem *)playerItem;
- (void)itemDidPlayToEndTime:(AVPlayerItem *)playerItem;
- (void)itemDidPlayToError;
@end


@interface GNSInternalVASTPlayer : AVPlayer

@property (nonatomic, weak) id<GNSInternalVASTPlayerControllerDelegate> delegateController;
@property (nonatomic, strong) AVPlayerItem *currentInlineAdPlayerItem;
@property (nonatomic, strong) NSDictionary *httpHeaders;

@property (nonatomic, copy) NSString *mediaFilePath;
@property (nonatomic, copy) NSURL *mediaFileURL;
@property (nonatomic, copy) NSArray *impressionURLs;
@property (nonatomic, copy) NSString *clickThroughURL;
@property (nonatomic, copy) NSArray *clickTrackingURLs;
@property (nonatomic, copy, setter=setTrackingEvents:) NSDictionary *trackingEvents;

- (void)startPlayVastAd;
- (void)removeObservers:(AVPlayerItem *)playerItem;
- (void)click;
- (double)getDurationTime;
- (double)getPlayingTime;
- (bool)isPlaying;
- (void)onOrientationLandscape;

- (void)initTrackingEventCheckFlag;

@end
