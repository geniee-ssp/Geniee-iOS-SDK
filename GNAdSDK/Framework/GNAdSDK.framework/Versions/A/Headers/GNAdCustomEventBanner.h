//
//  GNAdCustomEventBanner.h
//

#import <UIKit/UIKit.h>
#import "GNAdCustomEventBannerDelegate.h"

/// The protocol for a Custom Event of the banner type. Your Custom Event handler object for banners
/// must implement this protocol. The requestBannerAd method will be called when mediation schedules
/// your Custom Event to be executed.
@protocol GNAdCustomEventBanner<NSObject>


/// This method is called by mediation when your Custom Event is scheduled to be executed. Results
/// of the execution should be reported back via the delegate.
/// |adSize| is the size of the ad as configured in the mediation UI for the mediation placement.
/// |serverParameter| and |serverLabel| are the parameter and label configured in the mediation UI for the Custom Event.
/// |customEventExtra| contains the additional parameters set by the application. This property allows you to pass additional
/// information from your application to your Custom Event object.To do so, create an instance of
/// NSDictionary to pass to GNAdView requestExtra property. That NSDictionary becomes the customEventExtra here.
- (void)requestBannerAd:(CGSize)adSize
              parameter:(NSString *)serverParameter
                  label:(NSString *)serverLabel
           requestExtra:(NSDictionary *)customEventExtra;

/// You should call back to the |delegate| with the results of the execution to ensure mediation
/// behaves correctly. The delegate is weakly referenced to prevent memory leaks caused by circular
/// retention.
///
/// Define the -delegate and -setDelegate: methods in your class.
///
/// In your class's -dealloc method, remember to nil out the delegate.
@property(nonatomic, weak) id<GNAdCustomEventBannerDelegate> delegate;

@optional
- (void)resetViewFrame:(CGRect)aRect;

@end
