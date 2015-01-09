//
//  MomentsViewController.m
//  9HugMoment
//
//  Created by Tommy on 11/24/14.
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import "MomentsViewController.h"
#import "CaptureVideoViewController.h"
#import "MomentsModel.h"
#import "ODRefreshControl.h"
#import "ArrayDataSource.h"
#import "MessageDetailsViewController.h"
#import "MomentsMessageTableViewCell.h"
#import "MessageObject.h"
#import "DownloadVideoView.h"
#import "FBConnectViewController.h"

static NSString * const MomentViewCellIdentifier = @"MomentViewCellIdentifier";

@interface MomentsViewController (){
    CaptureVideoViewController *captureVideoViewController;
    MomentsModel *_momentModel;
    MessageObject *message;
    ODRefreshControl *_refreshControl;
    MBProgressHUD *_hud;
    NSCache *_avatarCache;
    MessageDetailsViewController *_messageDetailsViewController;
}

@property (nonatomic, strong) ArrayDataSource *arrayDataSource;
@property (weak, nonatomic) IBOutlet UITableView *messagesTableView;
@property (strong, nonatomic) UIButton *newsMomentButton;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation MomentsViewController

#pragma mark - MomentsViewController management

- (void)viewDidLoad {
    [super viewDidLoad];
    _momentModel = [[MomentsModel alloc] init];
    _avatarCache = [[NSCache alloc] init];
    
    _hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_hud];
    
    _refreshControl = [[ODRefreshControl alloc] initInScrollView:self.messagesTableView];
    [_refreshControl addTarget:self action:@selector(refreshTableView) forControlEvents:UIControlEventValueChanged];
    [self getAllMessage];
    
    CGRect frameExtend2 = [_newsMomentButton frame];
    frameExtend2.origin.y = WIDTH_BUTTON_NEW_MOMENTS;
    frameExtend2.origin.x = CGRectGetWidth(self.view.frame)/3;
    frameExtend2.size.width = CGRectGetWidth(self.view.frame)/3;
    frameExtend2.size.height = HIGHT_BUTTON_NEW_MOMENTS;
    
    _newsMomentButton = [[UIButton alloc] initWithFrame:frameExtend2];
    
    [_newsMomentButton setBackgroundColor:[UIColor lightGrayColor]];
    _newsMomentButton.layer.cornerRadius = CORNER_RADIUS;
    
    [_newsMomentButton setTitle:TITLE_BUTTON_NEW_MOMENTS forState:UIControlStateNormal];
    [_newsMomentButton.titleLabel setFont:[UIFont systemFontOfSize:TITLE_BUTTON_NEW_MOMENTS_FONT_SIZE]];
    [_newsMomentButton addTarget:self action:@selector(callPullDownRequest:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_newsMomentButton];
    
    self.newsMomentButton.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNSNotifications:)
                                                 name:CALL_PUSH_NOTIFICATIONS object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)pushNSNotifications:(NSNotification*)notify{
    self.newsMomentButton.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Custom Methods

- (void)setupTable{
    for (int i=0; i<_momentModel.messages.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [self setupTableView:indexPath];
    }
}

- (void)getAllMessage {
    _newsMomentButton.hidden = YES;
    [_hud show:YES];
    [_momentModel getAllMessagesSuccess:^(id result) {
        NSLog(@"count : %lu",(unsigned long)_momentModel.messages.count);
        [_messagesTableView reloadData];
        [self setupTable];
        [_hud hide:YES];
    } failure:^(NSError *error) {
        [_hud hide:YES];
    }];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:PUSH_MESSAGE_DETAILS_VIEW_CONTROLLER])
    {
        _messageDetailsViewController = [segue destinationViewController];
        _messageDetailsViewController.messageObject = message;
        _messageDetailsViewController.hidesBottomBarWhenPushed = YES;
    }
}

#pragma mark - TableView delegates & datasources

- (void)setupTableView:(NSIndexPath *)indexPath{
    TableViewCellConfigureBlock configureCell = ^(MomentsMessageTableViewCell *momentsMessageTableViewCell, MessageObject *myMessage){
        [momentsMessageTableViewCell setMessageWithMessage:myMessage];
    };
    _arrayDataSource = [[ArrayDataSource alloc]initWithItems:_momentModel.messages
                                              cellIdentifier:MomentViewCellIdentifier
                                          configureCellBlock:configureCell];
    
    self.messagesTableView.dataSource = self.arrayDataSource;
    [self.messagesTableView registerClass:[MomentsMessageTableViewCell class] forCellReuseIdentifier:MomentViewCellIdentifier];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    message = [_momentModel.messages objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:PUSH_MESSAGE_DETAILS_VIEW_CONTROLLER sender:nil];
}

#pragma mark - Button New moment

-(void)callPullDownRequest:(UIButton *)btn{
    [self getAllMessage];
}


#pragma mark - Refresh control management

- (void)refreshTableView {
    [_momentModel getAllMessagesSuccess:^(id result) {
        NSLog(@"Message found: %lu",(unsigned long)_momentModel.messages.count);
        [self refreshTableViewDone];
    } failure:^(NSError *error) {
        [self refreshTableViewDone];
    }];
    _newsMomentButton.hidden = YES;
}

- (void)refreshTableViewDone {
    [_refreshControl endRefreshing];
    [_messagesTableView reloadData];
}


@end
