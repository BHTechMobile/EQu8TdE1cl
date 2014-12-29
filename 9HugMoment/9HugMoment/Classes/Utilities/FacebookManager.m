//
//  FacebookManager.m
//  MusicPlayer
//
//  Created by Kalvar on 2014/1/1.
//  Copyright (c) 2014年 Kalvar. All rights reserved.
//

#import "FacebookManager.h"
#import "AppDelegate.h"

static NSString *_kFacebookUserId         = @"_kFacebookUserId";
static NSString *_kFacebookUserName       = @"_kFacebookUserName";
static NSString *_kFacebookUserGender     = @"_kFacebookUserGender";
static NSString *_kFacebookUserBirthday   = @"_kFacebookUserBirthday";
static NSString *_kFacebookRequestResults = @"_kFacebookRequestResults";

@implementation FacebookManager (fixNSDefaults)

-(AppDelegate *)getAppDelegate
{
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

#pragma --mark Gets NSDefault Values
/*
 * @ 取出萬用型態
 */
-(id)defaultValueForKey:(NSString *)_key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:_key];
}

/*
 * @ 取出 String
 */
-(NSString *)defaultStringValueForKey:(NSString *)_key
{
    return [NSString stringWithFormat:@"%@", [self defaultValueForKey:_key]];
}

/*
 * @ 取出 BOOL
 */
-(BOOL)defaultBoolValueForKey:(NSString *)_key
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:_key];
}

#pragma --mark Saves NSDefault Values
/*
 * @ 儲存萬用型態
 */
-(void)saveDefaultValue:(id)_value forKey:(NSString *)_forKey
{
    [[NSUserDefaults standardUserDefaults] setObject:_value forKey:_forKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/*
 * @ 儲存 String
 */
-(void)saveDefaultValueForString:(NSString *)_value forKey:(NSString *)_forKey
{
    [self saveDefaultValue:_value forKey:_forKey];
}

/*
 * @ 儲存 BOOL
 */
-(void)saveDefaultValueForBool:(BOOL)_value forKey:(NSString *)_forKey
{
    [self saveDefaultValue:[NSNumber numberWithBool:_value] forKey:_forKey];
}

#pragma --mark Removes NSDefault Values
-(void)removeDefaultValueForKey:(NSString *)_key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:_key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end

@implementation FacebookManager (facebooks)

-(AppDelegate *)_getAppDelegate
{
	return [self getAppDelegate];
}

-(FBSession *)_getActiveFBSession
{
    return [self _getAppDelegate].session;
}

#pragma --mark User Id
-(NSString *)_getUserId
{
    return [self defaultValueForKey:_kFacebookUserId];
}

-(void)_deleteUserId
{
    [self removeDefaultValueForKey:_kFacebookUserId];
}

-(void)_saveUserId:(NSString *)_facebookId
{
    [self saveDefaultValueForString:_facebookId forKey:_kFacebookUserId];
}

#pragma --mark User Name
-(NSString *)_getUserName
{
    return [self defaultValueForKey:_kFacebookUserName];
}

-(void)_deleteUserName
{
    [self removeDefaultValueForKey:_kFacebookUserName];
}

-(void)_saveUserName:(NSString *)_userName
{
    [self saveDefaultValueForString:_userName forKey:_kFacebookUserName];
}

#pragma --mark User Gender
-(NSString *)_getUserGender
{
    return [self defaultValueForKey:_kFacebookUserGender];
}

-(void)_deleteUserGender
{
    [self removeDefaultValueForKey:_kFacebookUserGender];
}

-(void)_saveUserGender:(NSString *)_userGender
{
    [self saveDefaultValueForString:_userGender forKey:_kFacebookUserGender];
}

#pragma --mark User Birtyday
-(NSString *)_getUserBirthday
{
    return [self defaultValueForKey:_kFacebookUserBirthday];
}

-(void)_deleteUserBirthday
{
    [self removeDefaultValueForKey:_kFacebookUserBirthday];
}

-(void)_saveUserBirthday:(NSString *)_userBirthday
{
    [self saveDefaultValueForString:_userBirthday forKey:_kFacebookUserBirthday];
}

#pragma --mark User Info
-(NSDictionary *)_getUserInfo
{
    return [self defaultValueForKey:_kFacebookRequestResults];
}

-(void)_deleteUserInfo
{
    [self removeDefaultValueForKey:_kFacebookRequestResults];
}

-(void)_saveUserInfo:(NSDictionary *)_userInfo
{
    [self saveDefaultValue:_userInfo forKey:_kFacebookRequestResults];
}

#pragma --mark Login & Others
-(void)_updateSession
{
//    AppDelegate *appDelegate = [self _getAppDelegate];
//    if (!appDelegate.session.isOpen)
//    {
//        appDelegate.session = [[FBSession alloc] init];
//        if (appDelegate.session.state == FBSessionStateCreatedTokenLoaded)
//        {
    //            [appDelegate.session openWithCompletionHandler:^(FBSession *session,
    //                                                             FBSessionState status,
    //                                                             NSError *error)
    //            {
    //                //...
    //            }];
//        }
//    }
    AppDelegate *appdel = [self _getAppDelegate];
    if (!appdel.session.isOpen) {
        appdel.session = [[FBSession alloc] initWithPermissions:@[@"email",@"user_birthday",@"user_birthday",@"user_birthday",]];
         [FBSession setActiveSession:appdel.session];
                if (appdel.session.state == FBSessionStateCreatedTokenLoaded) {
         [appdel.session openWithBehavior:FBSessionLoginBehaviorUseSystemAccountIfPresent completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
             [self sessionStateChanged:session state:status error:error];
         }];
        }
    }
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen:
            if (!error) {
                // We have a valid session
                NSLog(@"User session found");
            }
            break;
        case FBSessionStateClosed:
            NSLog(@"FBSessionStateClosed");
        case FBSessionStateClosedLoginFailed:
            NSLog(@"FBSessionStateClosedLoginFailed");
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"FBSessionStateClosed"
     object:session];
    
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"facebook Hinweis"
                                                        message:@"facebook Login nicht möglich, bitte versuchen Sie es erneut."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        NSLog(@"Facebook session error: %@", error.localizedDescription);
    }
}

-(void)_loginFacebookWithCompletion:( void(^)(BOOL success, NSDictionary *userInfo) )_completion
{
//    AppDelegate *appdel = [self _getAppDelegate];
//    if (appdel.session.state != FBSessionStateCreated)
//    {
    //        appdel.session = [[FBSession alloc] initWithPermissions:@[@"email",
    //                                                                       @"user_birthday",
    //                                                                       @"user_birthday",
    //                                                                       @"user_birthday",]];
//    }
//    
//    [appdel.session openWithCompletionHandler:^(FBSession *session,
//                                                     FBSessionState status,
//                                                     NSError *error)
    AppDelegate *appdel = [self _getAppDelegate];
    if (appdel.session.state != FBSessionStateCreated) {
        appdel.session = [[FBSession alloc]initWithPermissions:@[@"email",@"user_birthday",@"user_birthday",@"user_birthday",]];
    }
    [appdel.session openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error)
     {
         //檢查是否未存有 Facebook User ID
         NSString *_savedUserId = [self _getUserId];
         if( [_savedUserId length] < 1 || [_savedUserId isEqualToString:@"(null)"] )
         {
             FBRequest *_fbRequest = [FBRequest requestForMe];
             [_fbRequest setSession:session];
             [_fbRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error)
             {
     
                 NSDictionary *_userInfo = nil;
                 if( [result isKindOfClass:[NSDictionary class]] )
                 {
                     _userInfo = (NSDictionary *)result;
                     //User Info
                     [self _saveUserInfo:_userInfo];
                     if( [_userInfo count] > 0 )
                     {
                         [self _saveUserId:[_userInfo objectForKey:@"id"]];
                         //Name
                         [self _saveUserName:[_userInfo objectForKey:@"name"]];
                         //Gender
                         [self _saveUserGender:[_userInfo objectForKey:@"gender"]];
                         //Birthday
                         [self _saveUserBirthday:[_userInfo objectForKey:@"birthday"]];
                     }
                 }
                 if( _completion )
                 {
                     _completion( !( error ), _userInfo );
                 }
             }];
         }
         else
         {
             //有 User Id 就直接更新
             if( _completion )
             {
                 _completion( !( error ), [self _getUserInfo] );
             }
         }
     }];
}

-(void)_logoutFacebook
{
    [self _deleteUserId];
    [self _deleteUserName];
    [self _deleteUserGender];
    [self _deleteUserBirthday];
    [self _deleteUserInfo];
    [[self _getAppDelegate].session closeAndClearTokenInformation];
}

-(BOOL)_sessionIsOpen
{
    return [self _getAppDelegate].session.isOpen;
}

@end

@implementation FacebookManager

@synthesize userId       = _userId;
@synthesize userName     = _userName;
@synthesize userGender   = _userGender;
@synthesize userBirthday = _userBirthday;
@synthesize userInfo     = _userInfo;

+(instancetype)sharedManager
{
    static dispatch_once_t pred;
    static FacebookManager *_object = nil;
    dispatch_once(&pred, ^{
        _object = [[FacebookManager alloc] init];
    });
    return _object;
}

#pragma --mark FacebookSDK Using Methods
/*
 * @ 喚醒 FacebookSDK 的 FBSession 並進行驗證
 */
-(void)awakeFBSession
{
    [self _updateSession];
}

/*
 * @ FacebookSDK 的 FBSession 是否已喚醒並可使用
 */
-(BOOL)isFBSessionOpen
{
    return [self _sessionIsOpen];
}

/*
 * @ 取得 FBSession
 */
-(FBSession *)getActiveFBSession
{
    return [self _getActiveFBSession];
}

/*
 * @ 是否可使用 iPhone Settings 裡的 Facebook 帳號進行 Facebook API Request 請求
 */
-(BOOL)canUseSettingsFacebookAccount
{
    return [SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook];
}

/*
 * @ 登入 Facebook
 */
-(void)login
{
    [self _loginFacebookWithCompletion:nil];
}

-(void)loginWithCompletion:( void(^)(BOOL success, NSDictionary *userInfo) )_completion
{
    [self _loginFacebookWithCompletion:_completion];
}

-(void)logout
{
    [self _logoutFacebook];
}

#pragma --mark Getters
-(NSString *)userId
{
    return [self _getUserId];
}

-(NSString *)userName
{
    return [self _getUserName];
}

-(NSString *)userGender
{
    return [self _getUserGender];
}

-(NSString *)userBirthday
{
    return [self _getUserBirthday];
}

-(NSDictionary *)userInfo
{
    return [self _getUserInfo];
}

@end
