//
//  FacebookManager.h
//  MusicPlayer
//
//  Created by Kalvar on 2014/1/1.
//  Copyright (c) 2014年 Kalvar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Social/Social.h>

@interface FacebookManager : NSObject

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userGender;
@property (nonatomic, strong) NSString *userBirthday;
@property (nonatomic, strong) NSDictionary *userInfo;

+(instancetype)sharedManager;


#pragma --mark FacebookSDK Using Methods
-(void)awakeFBSession;
-(BOOL)isFBSessionOpen;
-(FBSession *)getActiveFBSession;
-(BOOL)canUseSettingsFacebookAccount;
-(void)login;
-(void)loginWithCompletion:( void(^)(BOOL success, NSDictionary *userInfo) )_completion;
-(void)logout;

@end
