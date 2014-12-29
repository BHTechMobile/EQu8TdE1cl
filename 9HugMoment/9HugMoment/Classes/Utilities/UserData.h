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

+(UserData*)currentAccount;

-(BOOL)isRemembered;

-(void)setShouldRememberMe:(BOOL)yesOrNo;

-(void)clearCached;

@end
