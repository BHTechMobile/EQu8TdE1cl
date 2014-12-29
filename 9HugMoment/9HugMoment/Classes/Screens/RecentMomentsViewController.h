//
//  RecentMomentsViewController.h
//  9HugMoment
//
//  Created by Tommy on 11/24/14.
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MomentsMessageTableViewCell.h"
#import "MessageObject.h"
#import "DownloadVideoView.h"

@interface RecentMomentsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,DownloadVideoDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myMessagesTableView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, retain) UIButton *newsMomentButton;

@end
