//
//  LocationManagement.m
//  My Therapist
//

#import "LocationManagement.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define ALERT_AUTHORIZATION_TITLE @"Location services is authorization denied!"
#define ALERT_AUTHORIZATION_MESSAGE @"Do you want to change authorization status?"
#define ALERT_LOCATION_SERVICES_CAN_NOT_OPEN_TITLE @"Can not access location services!"
#define ALERT_LOCATION_SERVICES_TURN_ON_MESSAGE @"Please go to \"Settings\" -> \"Privacy\" -> \"Location\" and turn on location service."
#define ALERT_LOCATION_SERVICES_CHANGE_AUTHORIZATION_STATUS_MESSAGE @"Please go to \"Settings\" -> \"Privacy\" -> \"Location\" and change authorization status of application."
#define ALERT_LOCATION_SERVICES_TURN_ON_CHANGE_AUTHORIZATION_STATUS_MESSAGE @"Please go to \"Settings\" -> \"Privacy\" -> \"Location\" turn on location service and change authorization status of application."
#define ALERT_LOCATION_SERVICES_TURN_OFF_TITLE @"Location Services is turn off!"
#define ALERT_LOCATION_SERVICES_TURN_OFF_MESSAGE @"Do you want to turn on location services?"

#define TAG_ALERT_VIEW_AUTHORIZATION 101
#define TAG_ALERT_VIEW_AUTHORIZATION_CAN_NOT_OPEN 102
#define TAG_ALERT_VIEW_LOCATION_SERVICES_TURN_OFF 103
#define TAG_ALERT_VIEW_LOCATION_SERVICES_TURN_OFF_AUTHORIZATION_DENIED 104

@implementation LocationManagement

+(LocationManagement*)shareLocation{
    //singleton object
    static LocationManagement * location = nil;
    if (!location) {
        location = [[LocationManagement alloc] init];
        location.locationManager = [[CLLocationManager alloc] init];
    }
    return location;
}

#pragma mark - Alert
__strong static UIAlertView *singleAlert;

/**
 Shows alert view only if there is ho anoters shown alert
 @param alertView
 Alert to show.
 */
+ (void)showSingleAlert:(UIAlertView *)alertView {
    if (singleAlert.visible) {
        [singleAlert dismissWithClickedButtonIndex:0 animated:NO];
        singleAlert = nil;
    }
    singleAlert = alertView;
    [singleAlert show];
}

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitile:(NSString *)cancelTitle{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelTitle otherButtonTitles:nil];
    [LocationManagement showSingleAlert:alertView];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == [alertView cancelButtonIndex]) {
        if (_delegate) {
            [_delegate didSelectedCancelButtonAlert];
        }
        [self getCurrentLocation];
    }else {
        if (alertView.tag == TAG_ALERT_VIEW_AUTHORIZATION && (buttonIndex == 1)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: UIApplicationOpenSettingsURLString]];
            return;
        }
        if (alertView.tag == TAG_ALERT_VIEW_AUTHORIZATION_CAN_NOT_OPEN && (buttonIndex == 1)) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:ALERT_LOCATION_SERVICES_CAN_NOT_OPEN_TITLE
                                                               message:ALERT_LOCATION_SERVICES_CHANGE_AUTHORIZATION_STATUS_MESSAGE
                                                              delegate:nil
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
            [LocationManagement showSingleAlert:alertView];
            return;
        }
        if (alertView.tag == TAG_ALERT_VIEW_LOCATION_SERVICES_TURN_OFF && (buttonIndex == 1)) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:ALERT_LOCATION_SERVICES_CAN_NOT_OPEN_TITLE
                                                               message:ALERT_LOCATION_SERVICES_TURN_ON_MESSAGE
                                                              delegate:nil
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
            [LocationManagement showSingleAlert:alertView];
            return;
        }
        if (alertView.tag == TAG_ALERT_VIEW_LOCATION_SERVICES_TURN_OFF_AUTHORIZATION_DENIED && (buttonIndex == 1)) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:ALERT_LOCATION_SERVICES_CAN_NOT_OPEN_TITLE
                                                               message:ALERT_LOCATION_SERVICES_TURN_ON_CHANGE_AUTHORIZATION_STATUS_MESSAGE
                                                              delegate:nil
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
            [LocationManagement showSingleAlert:alertView];
            return;
        }
    }
}

#pragma mark - Location Services
+ (BOOL)locationIsTurnOn{
    return [CLLocationManager locationServicesEnabled]?YES:NO;
}

+ (CLAuthorizationStatus)authorizationStatus{
    return [CLLocationManager authorizationStatus];
}

- (void)requestTurnOnLocationServices{
    // First time user launch application
    if ([LocationManagement locationIsTurnOn] && ([LocationManagement authorizationStatus] == kCLAuthorizationStatusNotDetermined)) {
        return;
    }
    
    // Request turn on location services
    NSURL *urlSettings;
    if (&UIApplicationOpenSettingsURLString != NULL) {
        urlSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    }
    if ([LocationManagement locationIsTurnOn]) {
        // Location is "Turn On"
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:ALERT_AUTHORIZATION_TITLE]
                                                            message:ALERT_AUTHORIZATION_MESSAGE
                                                           delegate:self
                                                  cancelButtonTitle:@"NO"
                                                  otherButtonTitles:@"YES",nil];
        if ([LocationManagement authorizationStatus] == kCLAuthorizationStatusDenied) {
            if ([[UIApplication sharedApplication] canOpenURL:urlSettings]) {
                alertView.tag = TAG_ALERT_VIEW_AUTHORIZATION;
                [LocationManagement showSingleAlert:alertView];
            }else{
                alertView.tag = TAG_ALERT_VIEW_AUTHORIZATION_CAN_NOT_OPEN;
                [LocationManagement showSingleAlert:alertView];
            }
        }else{
            [self getCurrentLocation];
        }
    }else{
        // Location is "Turn Off"
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:ALERT_LOCATION_SERVICES_TURN_OFF_TITLE]
                                                            message:ALERT_LOCATION_SERVICES_TURN_OFF_MESSAGE
                                                           delegate:self
                                                  cancelButtonTitle:@"NO"
                                                  otherButtonTitles:@"YES",nil];
        alertView.tag = ([LocationManagement authorizationStatus] == kCLAuthorizationStatusDenied)?TAG_ALERT_VIEW_LOCATION_SERVICES_TURN_OFF_AUTHORIZATION_DENIED:TAG_ALERT_VIEW_LOCATION_SERVICES_TURN_OFF;
        [LocationManagement showSingleAlert:alertView];
    }
}

#pragma mark - CLLocation Manager
- (void)getCurrentLocation{
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [_locationManager startUpdatingLocation];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        [_locationManager requestWhenInUseAuthorization];
    }
}

@end
