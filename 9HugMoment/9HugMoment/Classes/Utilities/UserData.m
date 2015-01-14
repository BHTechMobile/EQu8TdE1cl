//
//  AccountObject.m
//  Copyright (c) 2014 BHTech. All rights reserved.
//

#import "UserData.h"

@implementation UserData

#define USERFACEBOOKID @"USERFACEBOOKID"
#define USERFACEBOOKTOKEN @"USERFACEBOOKTOKEN"
#define USERFULLNAME @"USERFULLNAME"
#define USERMOBILE @"USERMOBILE"
#define USERNICKNAME @"USERNICKNAME"
#define USERPASSWORD @"USERPASSWORD"
#define USERMEMBER @"USERMEMBER"
#define USERID @"USERID"
#define USERCREATEDATE @"USERCREATED"

#define USERCTOKEN @"USERCTOKEN"

#define USER_STATUS @"USERSTATUS"
#define USER_NUMBER_OF_GIFTS @"USERNUMBEROFGIFTS"
#define USER_NUMBER_OF_REQUESTS @"USERNUMBEROFREQUESTS"
#define USER_NUMBER_OF_FRIENDS @"USERNUMBEROFRIENDS"
#define USER_NUMBER_OF_CREDITS @"USERNUMBEROFCREDITS"
#define USER_NUMBER_OF_STICKERS @"USERNUMBEROFSTICKERS"

+(UserData*)currentAccount{
    static UserData *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[UserData alloc] init];
    });
    return _sharedInstance;
}

- (void)setStrUserToken:(NSString *)strUserToken{
    [[NSUserDefaults standardUserDefaults] setValue:strUserToken forKey:USERCTOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)strUserToken{
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:USERCTOKEN]);
    return [[NSUserDefaults standardUserDefaults] valueForKey:USERCTOKEN];
}

- (void)setStrFacebookId:(NSString *)strFacebookId{
    [[NSUserDefaults standardUserDefaults] setValue:strFacebookId forKey:USERFACEBOOKID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)strFacebookId{
    return [[NSUserDefaults standardUserDefaults] valueForKey:USERFACEBOOKID];
}

- (void)setStrFacebookToken:(NSString *)strFacebookToken{
    [[NSUserDefaults standardUserDefaults] setValue:strFacebookToken forKey:USERFACEBOOKTOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)strFacebookToken{
    return [[NSUserDefaults standardUserDefaults] valueForKey:USERFACEBOOKTOKEN];
}

- (void)setStrFullName:(NSString *)strFullName{
    [[NSUserDefaults standardUserDefaults] setValue:strFullName forKey:USERFULLNAME];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)strFullName{
    return [[NSUserDefaults standardUserDefaults] valueForKey:USERFULLNAME];
}

- (void)setStrMobile:(NSString *)strMobile{
    [[NSUserDefaults standardUserDefaults] setValue:strMobile forKey:USERMOBILE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)strMobile{
    return [[NSUserDefaults standardUserDefaults] valueForKey:USERMOBILE];
}

- (void)setStrNickname:(NSString *)strNickname{
    [[NSUserDefaults standardUserDefaults] setValue:strNickname forKey:USERNICKNAME];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)strNickname{
    return [[NSUserDefaults standardUserDefaults] valueForKey:USERNICKNAME];
}

- (void)setStrPassword:(NSString *)strPassword{
    [[NSUserDefaults standardUserDefaults] setValue:strPassword forKey:USERPASSWORD];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)strPassword{
    return [[NSUserDefaults standardUserDefaults] valueForKey:USERPASSWORD];
}

- (void)setStrId:(NSString *)strId{
    [[NSUserDefaults standardUserDefaults] setValue:strId forKey:USERID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)strId{
    return [[NSUserDefaults standardUserDefaults] valueForKey:USERID];
}


-(void)setShouldRememberMe:(BOOL)yesOrNo{
    [[NSUserDefaults standardUserDefaults] setBool:yesOrNo forKey:USERMEMBER];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(BOOL)isRemembered{
    return [[NSUserDefaults standardUserDefaults] boolForKey :USERMEMBER];
}

-(void)clearCached{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:USERMEMBER];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERPASSWORD];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERNICKNAME];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERMOBILE];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERFULLNAME];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERFACEBOOKTOKEN];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERFACEBOOKID];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERID];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERCTOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setStrUserStatus:(NSString *)strUserStatus
{
    [[NSUserDefaults standardUserDefaults] setValue:strUserStatus forKey:USER_STATUS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)strUserStatus
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:USER_STATUS];
}

#pragma mark - Statistics
// Statistics

- (void)setStrUserNumberOfGifts:(NSString *)strUserNumberOfGifts
{
    [[NSUserDefaults standardUserDefaults] setValue:strUserNumberOfGifts forKey:USER_NUMBER_OF_GIFTS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)strUserNumberOfGifts
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:USER_NUMBER_OF_GIFTS];
}

- (void)setStrUserNumberOfRequests:(NSString *)strUserNumberOfRequests
{
    [[NSUserDefaults standardUserDefaults] setValue:strUserNumberOfRequests forKey:USER_NUMBER_OF_REQUESTS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)strUserNumberOfRequests
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:USER_NUMBER_OF_REQUESTS];
}

- (void)setStrUserNumberOfFriends:(NSString *)strUserNumberOfFriends
{
    [[NSUserDefaults standardUserDefaults] setValue:strUserNumberOfFriends forKey:USER_NUMBER_OF_FRIENDS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)strUserNumberOfFriends
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:USER_NUMBER_OF_FRIENDS];
}

- (void)setStrUserNumberOfCredits:(NSString *)strUserNumberOfCredits
{
    [[NSUserDefaults standardUserDefaults] setValue:strUserNumberOfCredits forKey:USER_NUMBER_OF_CREDITS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)strUserNumberOfCredits
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:USER_NUMBER_OF_CREDITS];
}

- (void)setStrUserNumberOfStickers:(NSString *)strUserNumberOfStickers
{
    [[NSUserDefaults standardUserDefaults] setValue:strUserNumberOfStickers forKey:USER_NUMBER_OF_STICKERS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)strUserNumberOfStickers
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:USER_NUMBER_OF_STICKERS];
}

@end
