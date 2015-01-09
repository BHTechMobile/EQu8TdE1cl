//
//  MyMomentsViewController.m
//  9HugMoment
//
//  Created by Tommy on 11/24/14.
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import "MyMomentsViewController.h"
#import "ODRefreshControl.h"
#import "MyMomentsModel.h"
#import "ArrayDataSource.h"
#import "ImageCacheObject.h"
#import "MessageDetailsViewController.h"

static NSString * const MomentViewCellIdentifier = @"MomentViewCellIdentifier";

@interface MyMomentsViewController ()

@property (nonatomic, strong) ArrayDataSource *arrayDataSource;

@end

@implementation MyMomentsViewController{
    MyMomentsModel *_myMomentModel;
    DownloadVideoView *_downloadVideoView;
    MessageObject *message;
    ODRefreshControl *_refreshControl;
    MBProgressHUD *_hud;
    NSMutableArray *personArray;
    ImageCacheObject *imageCacheObject;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = TITLES_MYMOMENTS;
    _myMomentModel = [[MyMomentsModel alloc] init];

    _downloadVideoView = [DownloadVideoView downloadVideoViewWithDelegate:self];
    [self.view addSubview:_downloadVideoView];
    
    _hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_hud];
    
    _refreshControl = [[ODRefreshControl alloc] initInScrollView:self.myMessagesTableView];
    [_refreshControl addTarget:self action:@selector(refreshTableView) forControlEvents:UIControlEventValueChanged];
    
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
    
    [self refreshTableView];
    imageCacheObject = [ImageCacheObject shareImageCache];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)pushNSNotifications:(NSNotification*)notify{
    self.newsMomentButton.hidden = NO;
}

#pragma mark - Custom Methods

- (void)setupTable{
    for (int i=0; i<_myMomentModel.messages.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [self setupTableView:indexPath];
    }
}

- (void)getAllMessage {
    _newsMomentButton.hidden = YES;
    [_hud show:YES];
    [_myMomentModel getMyMessagesSuccess:^(id result) {
        NSLog(@"count : %lu",(unsigned long)_myMomentModel.messages.count);
        [_myMessagesTableView reloadData];
        [_hud hide:YES];
    } failure:^(NSError *error) {
        [_hud hide:YES];
    }];
}

#pragma mark - TableView delegates & datasources

- (void)setupTableView:(NSIndexPath *)indexPath{
    TableViewCellConfigureBlock configureCell = ^(MomentsMessageTableViewCell *momentsMessageTableViewCell, MessageObject *myMessage){
        [momentsMessageTableViewCell setMessageWithMessage:myMessage];
    };
    _arrayDataSource = [[ArrayDataSource alloc]initWithItems:_myMomentModel.messages
                                              cellIdentifier:MomentViewCellIdentifier
                                          configureCellBlock:configureCell];
    
    self.myMessagesTableView.dataSource = self.arrayDataSource;
    [self.myMessagesTableView registerClass:[MomentsMessageTableViewCell class] forCellReuseIdentifier:MomentViewCellIdentifier];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    message = [_myMomentModel.messages objectAtIndex:indexPath.row];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:TRENDING_STORY_BOARD bundle: nil];
    MessageDetailsViewController *messageDetailsViewController = [storyboard instantiateViewControllerWithIdentifier:BUNDLE_IDENTIFIER_MESSAGE_DETAILS_VIEW_CONTTROLLER_TRENDING];
    messageDetailsViewController.messageObject = message;
    messageDetailsViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:messageDetailsViewController animated:YES];
}

#pragma mark - Button New moment

-(void)callPullDownRequest:(UIButton *)btn{
    [self refreshTableView];
}

#pragma mark - Refresh control management

- (void)refreshTableView {
    [_myMomentModel getMyMessagesSuccess:^(id result) {
        NSLog(@"Message found: %lu",(unsigned long)_myMomentModel.messages.count);
        [self refreshTableViewDone];
    } failure:^(NSError *error) {
        [self refreshTableViewDone];
    }];
    _newsMomentButton.hidden = YES;
}

- (void)refreshTableViewDone {
    [_refreshControl endRefreshing];
    [_myMessagesTableView reloadData];
    [self setupTable];
}

@end
