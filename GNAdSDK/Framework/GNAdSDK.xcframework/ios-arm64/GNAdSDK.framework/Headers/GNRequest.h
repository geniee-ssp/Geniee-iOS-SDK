//
//  GNRequest.h
//  GNAdSDK
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface GNRequest : NSObject<CLLocationManagerDelegate>

@property(nonatomic, copy) NSString *zoneid;
@property(nonatomic, strong)NSMutableArray *zoneIds;
@property(nonatomic, retain) NSMutableDictionary* params;
@property(nonatomic, retain) NSMutableDictionary* device_params;
@property(nonatomic, retain) NSMutableDictionary* reward_extra_params;

@property(nonatomic, copy) NSString *uaString;
@property(nonatomic, retain) CLLocationManager *locationManager;
@property(nonatomic, assign) BOOL testMode;
@property(nonatomic, copy) NSString *sdk_base_url;
@property(nonatomic, copy) NSString *sdk_base_url_test;
@property(nonatomic, copy) NSString *vastAdTagURL;

@property(nonatomic, copy) NSString *encodeApName;
@property(nonatomic, copy) NSString *encodeApId;
@property(nonatomic, assign) BOOL usingMediation;


- (id)init;
- (id)initWithID:(NSString *)appID;
- (void)setIntersCapping:(BOOL)isCapping;
- (void)setIosFlag:(BOOL)isIos;
- (NSString *)getIntersAdTagRequestURL;
- (NSString *)BASE_URL;
- (void)setAppInfo;
- (void)setIntersCnt:(NSInteger)nCnt;
- (void)setIntersRan:(NSInteger)nRan;
- (void)setRewardCnt:(NSInteger)nCnt;
- (void)setRewardRan:(NSInteger)nRan;
- (void)setRewardImpsURLFormat:(BOOL)flag;
- (void)setGeoLocationEnable:(BOOL)flag;
- (void)usingMediation:(BOOL)usingMediation;

- (NSString *)getVastAdTagRequestURL;
- (void)setVastAdTagRequestURL;
- (void) setAdBlank:(BOOL) adBlank;
- (NSArray *)requestAd;
- (NSData *)requestAd:(NSString *)url;
- (NSDictionary *)requestNativeAd;
- (NSArray *)requestAdMediation;

/// Acquire ad with zoneId passed as argument
/// @param zoneId Get the advertisement zoneId
/// @return Parsing response (json) to NSDictionary
- (NSDictionary *)requestNativeAdWithZoneId:(NSString *)zoneId;

- (NSArray *)requestRewardVideoAdZones;
- (NSString *)getRewardVideoAdRequestURL;

@end
