//
//  GNSMediationAdRequest.h
//  GNAdSDK
//

#import <Foundation/Foundation.h>
#import "GNSAdNetworkExtras.h"

/// Provides information which can be used for making ad requests during mediation.
@protocol GNSMediationAdRequest<NSObject>

- (id<GNSAdNetworkExtras>)networkExtras;

@end
