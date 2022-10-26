//
//  GNSAdapterVungleFullscreenInterstitialAd.m
//  GNAdSDK
//

#import "GNSAdapterVungleFullscreenInterstitialAd.h"
#import <VungleSDK/VungleSDK.h>
#import <GNAdSDK/GNSAdNetworkConnectorProtocol.h>
#import <GNAdSDK/GNSAdNetworkExtraParams.h>

static NSString *const kGNSAdapterVungleInterstitialAdKeyErrorDomain = @"jp.co.geniee.GNSAdapterVungleInterstitialAd";
static BOOL loggingEnabled = YES;

@interface GNSAdapterVungleFullscreenInterstitialAd () <UIApplicationDelegate, VungleSDKDelegate>

@property(nonatomic, weak) id<GNSAdNetworkConnector> connector;

@property (nonatomic, retain) NSTimer *timer;

@property(nonatomic, weak) VungleSDK *sdk;

@property(nonatomic, assign) BOOL requestingAd;

@end

@implementation GNSExtrasVungle
@end

@implementation GNSAdapterVungleFullscreenInterstitialAd

- (void)ALLog:(NSString *)logMessage {
    if (loggingEnabled) {
        NSLog(@"[INFO]GNSVungleAdapter: %@", logMessage);
    }
}

+ (NSString *)adapterVersion {
    return @"3.1.0";
}

+ (Class<GNSAdNetworkExtras>)networkExtrasClass {
    return [GNSExtrasVungle class];
}

- (id<GNSAdNetworkExtras>)networkExtrasParameter:(GNSAdNetworkExtraParams *) parameter
{
    GNSExtrasVungle * extra = [[GNSExtrasVungle alloc]init];
    extra.app_id = parameter.external_link_id;
    extra.placementReferenceId = parameter.external_link_media_id;
    
    return extra;
}

- (instancetype)initWithAdNetworkConnector:(id<GNSAdNetworkConnector>)connector
{
    self = [super init];
    if (self) {
        self.connector = connector;
    }
    return self;
}

- (void)setUp {
    if (self.sdk == nil) {
        self.sdk = [VungleSDK sharedSDK];
    }
    if (self.sdk == nil) {
        [self ALLog:[NSString stringWithFormat:@"Can not create Vungle instance"]];
        return;
    }

    [self ALLog:[NSString stringWithFormat:@"setUp: %ld", (long)[VungleSDK version]]];

    [self.connector adapterDidSetupAd:self];
}

- (void)setTimerWith:(NSInteger)timeout
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self->_timer = [NSTimer scheduledTimerWithTimeInterval:timeout
                                                  target:self
                                                selector:@selector(sendDidFailToLoadAdWithTimeout)
                                                userInfo:nil
                                                 repeats:NO];

    });
}

- (void)deleteTimer
{
    if (_timer != nil) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)sendDidFailToLoadAdWithTimeout{
    [self deleteTimer];
    
    [self ALLog:@"Interstial Ad loading timeout."];
    NSDictionary *errorInfo = @{ NSLocalizedDescriptionKey : @"Interstial Ad loading timeout." };
    NSError *error = [NSError errorWithDomain: kGNSAdapterVungleInterstitialAdKeyErrorDomain
                                         code: 1
                                     userInfo: errorInfo];
    [self.connector adapter: self didFailToLoadAdwithError: error];
}

- (void)requestAd:(NSInteger)timeout {
    self.requestingAd = YES;
    //Return the result when already loaded
    if ([self isReadyForDisplay]) {
        self.requestingAd = NO;
        [self.connector adapterDidReceiveAd:self];
        return;
    }

    if (self.sdk == nil) {
        return;
    }

    // set Timer
    [self setTimerWith:timeout];

    if (![self.sdk isInitialized]) {
        
        NSError *error = nil;

        GNSExtrasVungle *extras = [self.connector networkExtras];
        [self ALLog:[NSString stringWithFormat:@"AppId=%@", extras.app_id]];
        [self ALLog:[NSString stringWithFormat:@"placementReferenceId=%@", extras.placementReferenceId]];

        [self.sdk setDelegate:self];

        if(![self.sdk startWithAppId:extras.app_id error:&error]) {
            [self.connector adapter:self didFailToSetupAdWithError:error];
        }

    } else {

        GNSExtrasVungle *extras = [self.connector networkExtras];

        NSError *error1 = nil;
        [self.sdk loadPlacementWithID:extras.placementReferenceId error:&error1];

    }
}

- (void)presentAdWithRootViewController:(UIViewController *)viewController {

    GNSExtrasVungle *extras = [self.connector networkExtras];

    if([self isReadyForDisplay]) {
        NSError *error;
        [self.sdk playAd:viewController options:nil placementID:extras.placementReferenceId error:&error];
    }
}

- (void)stopBeingDelegate {
    self.connector = nil;
    if (self.sdk != nil) {
        [self.sdk setDelegate:nil];
    }
}

- (BOOL)isReadyForDisplay
{
    GNSExtrasVungle *extras = [self.connector networkExtras];
    return (self.sdk != nil && [self.sdk isAdCachedForPlacementID:extras.placementReferenceId]);
}

- (void)onErrorWithMessage:(NSString*) message
{
    [self deleteTimer];
    [self ALLog: message];
    NSDictionary *errorInfo = @{ NSLocalizedDescriptionKey : message };
    NSError *error = [NSError errorWithDomain: kGNSAdapterVungleInterstitialAdKeyErrorDomain
                                         code: 1
                                     userInfo: errorInfo];
    [self.connector adapter: self didFailToLoadAdwithError: error];
}

#pragma implement VungleSDKDelegate

- (void)vungleAdPlayabilityUpdate:(BOOL)isAdPlayable placementID:(NSString *)placementID error:(NSError *)error {

    if (self.requestingAd) {
        self.requestingAd = NO;
        if (isAdPlayable) {

            GNSExtrasVungle *extras = [self.connector networkExtras];

            if ([placementID isEqualToString:extras.placementReferenceId]) {

                [self deleteTimer];
                [self.connector adapterDidReceiveAd:self];
            }
        } else {
            [self onErrorWithMessage:@"Vungle There is no Ad"];
        }
    }
}

- (void)vungleWillShowAdForPlacementID:(NSString *)placementID {
    [self.connector adapterWillPresentScreenInterstitialAd:self];
}

- (void)vungleWillCloseAdWithViewInfo:(VungleViewInfo *)info placementID:(NSString *)placementID {

    [self.connector adapterDidCloseAd:self];
}

- (void)vungleSDKDidInitialize {

    GNSExtrasVungle *extras = [self.connector networkExtras];

    NSError *sdkInitError = nil;
    [self.sdk loadPlacementWithID:extras.placementReferenceId error:&sdkInitError];
}

@end
