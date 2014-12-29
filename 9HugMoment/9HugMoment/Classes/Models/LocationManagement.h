//
//  LocationManagement.h
//  My Therapist
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class LocationManagement;
@protocol LocationManagementDelegate <NSObject>
@optional;
- (void)didSelectedCancelButtonAlert;

@end

@interface LocationManagement : NSObject<UIAlertViewDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) id<LocationManagementDelegate> delegate;

+(LocationManagement*)shareLocation;
- (void)requestTurnOnLocationServices;
- (void)getCurrentLocation;

@end
