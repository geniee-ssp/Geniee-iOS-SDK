//
//  GNSAdapterMaioFullscreenInterstitialAd.h
//  GNAdFullscreenInterstitialSample
//
//  Created by Nguyenthanh Long on 11/26/18.
//  Copyright © 2018 Geniee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GNAdSDK/GNSAdNetworkConnectorProtocol.h>
#import <GNAdSDK/GNSAdNetworkExtras.h>

@interface GNSAdapterMaioFullscreenInterstitialAd : NSObject<GNSAdNetworkAdapter>

@end

@interface GNSExtrasFullscreenMaio : NSObject<GNSAdNetworkExtras>
@property(nonatomic,copy) NSString *media_id;
@end
