//
//  GNSAdapterMaioFullscreenInterstitialAd.m
//  GNAdFullscreenInterstitialSample
//
//  Created by Nguyenthanh Long on 11/26/18.
//  Copyright © 2018 Geniee. All rights reserved.
//

#import "GNSAdapterMaioFullscreenInterstitialAd.h"
#import <Maio/Maio.h>

static NSString *const kGNSAdapterMaioInterstitialAdKeyErrorDomain = @"jp.co.geniee.GNSAdapterMaioInterstitialAd";
static BOOL loggingEnable = YES;

@interface GNSAdapterMaioFullscreenInterstitialAd() <MaioDelegate>
@property(nonatomic, retain) NSTimer *timer;
@property(nonatomic, assign) NSInteger timeout;
@property(nonatomic, weak)id<GNSAdNetworkConnector> connector;

@end

@implementation GNSExtrasFullscreenMaio
@end

@implementation GNSAdapterMaioFullscreenInterstitialAd

- (void)AllLog:(NSString *)logMessage
{
    if (loggingEnable) {
        NSLog(@"[INFO]GNSInterstitialMaioAdapter: %@", logMessage);
    }
}

#pragma mark - GNSAdNetworkAdapter
+ (NSString *)adapterVersion {
    return @"3.1.1";
}

- (instancetype)initWithAdNetworkConnector:(id<GNSAdNetworkConnector>)connector {
    self = [super init];
    if (self) {
        self.connector = connector;
    }
    return self;
}

- (BOOL)isReadyForDisplay {
    return [Maio canShow];
}

+ (Class<GNSAdNetworkExtras>)networkExtrasClass {
    return [GNSExtrasFullscreenMaio class];
}

- (id<GNSAdNetworkExtras>)networkExtrasParameter:(GNSAdNetworkExtraParams *)parameter {
    GNSExtrasFullscreenMaio *extra = [[GNSExtrasFullscreenMaio alloc] init];
    extra.media_id = parameter.external_link_id;
    extra.zoneId = parameter.external_link_media_id;
    return extra;
}

- (void)presentAdWithRootViewController:(UIViewController *)viewController {
    if ([self isReadyForDisplay]) {
        [Maio showWithViewController:viewController];
    }
}

- (void)requestAd:(NSInteger)timeOut {
    if ([self isReadyForDisplay]) {
        [self.connector adapterDidReceiveAd:self];
        return;
    }
    [self setTimerWith:timeOut];
    GNSExtrasFullscreenMaio *extras = [self.connector networkExtras];
    [self AllLog:[NSString stringWithFormat:@"MediaId=%@", extras.media_id]];
    [Maio startWithMediaId:extras.media_id delegate:self];
}

- (void)setUp {
    [self AllLog:@"setup"];
    [self.connector adapterDidSetupAd:self];
}

- (void)stopBeingDelegate {
    self.connector = nil;
}

- (void)setTimerWith:(NSInteger)timeout
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.timer = [NSTimer scheduledTimerWithTimeInterval:timeout target:self selector:@selector(sendDidFailToLoadAdWithTimeout) userInfo:nil repeats:NO];
    });
}

- (void)deleteTimer
{
    if (_timer != nil) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)sendDidFailToLoadAdWithTimeout
{
    [self deleteTimer];
    [self AllLog:@"Interstial Ad loading timeout."];
    NSDictionary *errorInfo = @{NSLocalizedDescriptionKey: @"Interstitial ad loading timeout."};
    NSError *error = [NSError errorWithDomain:kGNSAdapterMaioInterstitialAdKeyErrorDomain code:1 userInfo:errorInfo];
    [self.connector adapter:self didFailToLoadAdwithError:error];
}

#pragma mark - MaioDelegate
- (void)maioDidInitialize
{
    // Called when Ads first loaded
//    [self.connector adapterDidReceiveAd:self];
}

- (void)maioDidFail:(NSString *)zoneId reason:(MaioFailReason)reason
{
    [self deleteTimer];
    NSDictionary *errorInfo = @{ NSLocalizedDescriptionKey : @"No ad to show." };
    NSError *error = [NSError errorWithDomain: kGNSAdapterMaioInterstitialAdKeyErrorDomain
                                         code: reason
                                     userInfo: errorInfo];
    [self.connector adapter:self didFailToLoadAdwithError:error];
}

- (void)maioDidChangeCanShow:(NSString *)zoneId newValue:(BOOL)newValue
{
    // Called when Ads second loaded or later
    [self AllLog:[NSString stringWithFormat:@"load change: zoneId=%@, value=%ld", zoneId, (long)newValue]];
    // Received Ad
    GNSExtrasFullscreenMaio *extras = [self.connector networkExtras];
    if (newValue && [zoneId isEqualToString:extras.zoneId]){
        [self deleteTimer];
        [self.connector adapterDidReceiveAd:self];
    }
}

- (void)maioDidClickAd:(NSString *)zoneId
{
    [self.connector adapterDidClickAd:self];
}

- (void)maioWillStartAd:(NSString *)zoneId
{
    [self.connector adapterWillPresentScreenInterstitialAd:self];
}

- (void)maioDidCloseAd:(NSString *)zoneId
{
    [self.connector adapterDidCloseAd:self];
}

@end
