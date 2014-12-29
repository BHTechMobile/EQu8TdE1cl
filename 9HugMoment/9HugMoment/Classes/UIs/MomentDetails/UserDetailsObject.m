//
//  UserDetailsObject.m
//  9HugMoment
//

#import "UserDetailsObject.h"

static NSDateFormatter *_dateFormatter;

@implementation UserDetailsObject

+ (UserDetailsObject *)createUserByDictionnary:(NSDictionary *)dict
{
    if (!dict) {
        return nil;
    }
    UserDetailsObject *userDetailsObject = [[UserDetailsObject alloc] init];
    [userDetailsObject initDateFormat];
    
    NSString *userID    = [dict stringForKey:KEY_ID];
    NSString *code      = [dict stringForKey:KEY_CODE];
    NSString *fullName  = [dict stringForKey:KEY_FULL_NAME];
    NSString *nickName  = [dict stringForKey:KEY_NICK_NAME];
    NSString *facebookID    = [dict stringForKey:KEY_FACEBOOK_ID];
    NSString *facebookToken = [dict stringForKey:KEY_FACEBOOK_TOKEN];
    NSString *mobile    = [dict stringForKey:KEY_MOBILE];
    NSString *email     = [dict stringForKey:KEY_EMAIL];
    NSString *password  = [dict stringForKey:KEY_PASSWORD];
    NSString *createdDate   = [dict stringForKey:KEY_CREATED_DATE];
    
    double timeInterval = 0;
    @try {
        timeInterval = [createdDate doubleValue];
    }
    @catch (NSException *exception) {
        timeInterval = 0;
    }
    NSString *timePostComment = (timeInterval == 0)?@"":[_dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
    
    userDetailsObject.userID    = (userID != (id)[NSNull null])?userID:@"";
    userDetailsObject.code      = (code != (id)[NSNull null])?code:@"";
    userDetailsObject.fullName  = (fullName != (id)[NSNull null])?fullName:@"";
    userDetailsObject.nickName  = (nickName != (id)[NSNull null])?nickName:@"";
    userDetailsObject.facebookID    = (facebookID != (id)[NSNull null])?facebookID:@"";
    userDetailsObject.facebookToken = (facebookToken != (id)[NSNull null])?facebookToken:@"";
    userDetailsObject.mobile    = (mobile != (id)[NSNull null])?mobile:@"";
    userDetailsObject.email     = (email != (id)[NSNull null])?email:@"";
    userDetailsObject.password  = (password != (id)[NSNull null])?password:@"";
    userDetailsObject.createdDate   = timePostComment;
    
    return userDetailsObject;
}

- (void)initDateFormat
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"HH:mm"];
    }
}

@end
