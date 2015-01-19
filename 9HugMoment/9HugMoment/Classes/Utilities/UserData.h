//
//  UserData
//  Copyright (c) 2014 BHTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserData : NSObject


@property (nonatomic,retain) NSString *strFacebookId;
@property (nonatomic,retain) NSString *strFacebookToken;
@property (nonatomic,retain) NSString *strFullName;
@property (nonatomic,retain) NSString *strMobile;
@property (nonatomic,retain) NSString *strNickname;
@property (nonatomic,retain) NSString *strPassword;
@property (nonatomic,retain) NSString *strId;

@property (nonatomic,retain) NSString *strUserToken;
@property (nonatomic,retain) NSString *strUserStatus;
//Statistics
@property (nonatomic,retain) NSString *strUserNumberOfGifts;
@property (nonatomic,retain) NSString *strUserNumberOfRequests;
@property (nonatomic,retain) NSString *strUserNumberOfFriends;
@property (nonatomic,retain) NSString *strUserNumberOfCredits;
@property (nonatomic,retain) NSString *strUserNumberOfStickers;

@property (nonatomic,retain) NSString *needRefreshMeScreen;
@property (nonatomic,retain) NSString *needRefreshPublicScreen;
@property (nonatomic,retain) NSString *previousFacebookID;

+(UserData*)currentAccount;

-(BOOL)isRemembered;

-(void)setShouldRememberMe:(BOOL)yesOrNo;

-(void)clearCached;

@end
