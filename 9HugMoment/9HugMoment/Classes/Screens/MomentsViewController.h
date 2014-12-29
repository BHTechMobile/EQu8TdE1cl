//
//  MomentsViewController.h
//  9HugMoment
//
//  Created by Tommy on 11/24/14.
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MomentsMessageTableViewCell.h"
#import "MessageObject.h"
#import "DownloadVideoView.h"
#import "FBConnectViewController.h"

@interface MomentsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,DownloadVideoDelegate,FBConnectViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *addCaptureVideoButton;
@property (weak, nonatomic) IBOutlet UITableView *messagesTableView;

- (IBAction)addCaptureVideoButtonAction:(id)sender;
- (IBAction)refreshButtonAction:(id)sender;
- (void)showLoginFB;
@property (nonatomic, retain) UIButton *newsMomentButton;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end
