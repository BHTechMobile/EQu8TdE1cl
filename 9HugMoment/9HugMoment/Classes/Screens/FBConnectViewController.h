//
//  FBConnectViewController.h
//  9HugMoment
//
//  Created by Tommy on 11/24/14.
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <FacebookSDK/FBSession.h>
#import "UserData.h"

@class FBConnectViewController;

@protocol FBConnectViewControllerDelegate <NSObject>

-(void)fbConnectViewController:(FBConnectViewController*)vc didConnectFacebookSuccess:(id)response;

@end

@interface FBConnectViewController : UIViewController<FBLoginViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageChange;
@property (weak, nonatomic) id<FBConnectViewControllerDelegate> delegate;


@end