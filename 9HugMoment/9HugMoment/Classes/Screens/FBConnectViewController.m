//
//  FBConnectViewController.m
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import "FBConnectViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "FacebookManager.h"
#import "Utilities.h"
#import "BaseServices.h"
#import <MBProgressHUD.h>

@interface FBConnectViewController()

- (IBAction)touchLoginFaceBook:(id)sender;

@end

@implementation FBConnectViewController


- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Button Login Facebook

- (IBAction)touchLoginFaceBook:(id)sender{
    if (APP_DELEGATE.session.state != FBSessionStateCreated) {
        APP_DELEGATE.session = [[FBSession alloc] initWithPermissions:@[@"publish_actions",@"public_profile", @"user_friends",@"read_friendlists"]];
    }
    [APP_DELEGATE.session openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
        if (!error) {
            [self login];
            APP_DELEGATE.session = session;
            [FBSession setActiveSession:session];
        }
    }];
}

#pragma mark - Check status login facebook

- (void)login{
    FBRequest *_fbRequest = [FBRequest requestForMe];
    [_fbRequest setSession:APP_DELEGATE.session];
    [_fbRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error)
     {
         NSDictionary *_userInfo = nil;
         if( [result isKindOfClass:[NSDictionary class]] )
         {
             _userInfo = (NSDictionary *)result;
             NSLog(@"_userFB = %@",_userInfo);
             [[NSUserDefaults standardUserDefaults]setObject:_userInfo forKey:objectLogin];
             NSLog(@"_userFB after = %@",_userInfo);
             [self loginid:_userInfo];
             [MBProgressHUD showHUDAddedTo:self.view animated:YES];
             [FBSession setActiveSession:APP_DELEGATE.session];
         }
     }];
    
}

#pragma mark - Method Login/Logout

-(void)loginid:(NSDictionary *)user{
    [[UserData currentAccount] clearCached];
    if (user) {
        [[UserData currentAccount] setStrFacebookToken:APP_DELEGATE.session.accessTokenData.accessToken];
        [[UserData currentAccount] setStrFacebookId:[user valueForKey:@"id"]];
        [[UserData currentAccount] setStrFullName:[user valueForKey:@"name"]];
        [[UserData currentAccount] setStrUserToken:[Utilities MD5StringFromString:[user valueForKey:@"id"]]];
        NSLog(@"User Token: %@",[UserData currentAccount].strUserToken);
        NSDictionary *dicParam = @{@"code":[user valueForKey:@"id"],
                                   @"fullname":[user valueForKey:@"name"],
                                   @"facebookid":[user valueForKey:@"id"] ,
                                   @"facebook_token":APP_DELEGATE.session.accessTokenData.accessToken,
                                   @"nickname":[user valueForKey:@"name"]
                                   };
        
        [BaseServices createUserWithParam:dicParam success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"response = %@",responseObject);
            
            [[UserData currentAccount] setStrId:[responseObject valueForKey:@"id"]];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self dismissViewControllerAnimated:YES completion:NULL];
            if (_delegate && [_delegate respondsToSelector:@selector(fbConnectViewController:didConnectFacebookSuccess:)]) {
                [_delegate fbConnectViewController:self didConnectFacebookSuccess:nil];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            [self dismissViewControllerAnimated:YES completion:NULL];
            NSLog(@"error = %@",error);
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
        
    }
}

@end

