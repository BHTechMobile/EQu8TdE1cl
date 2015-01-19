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
#import <SDWebImage/SDImageCache.h>

static NSString * const MomentViewCellIdentifier = @"MomentViewCellIdentifier";

@interface MomentsViewController ()<MomentsModelDelegate, MomentsMessageTableViewCellDelegate>{
    CaptureVideoViewController *captureVideoViewController;
    MomentsModel *_momentModel;
    MessageObject *_messageSelected;
    ODRefreshControl *_refreshControl, *_refreshControlMessageNewest;
    MBProgressHUD *_hud;
    MessageDetailsViewController *_messageDetailsViewController;
}

@property (weak, nonatomic) IBOutlet UITableView *messagesHotTableView;
@property (weak, nonatomic) IBOutlet UITableView *messagesNewestTableView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeToShowMessageSegment;

@property (nonatomic, strong) ArrayDataSource *arrayDataSourceMessageHot, *arrayDataSourceMessageNewest;
@property (strong, nonatomic) UIButton *newsMomentButton;

- (IBAction)changeTypeToShowMessageAction:(id)sender;

@end

@implementation MomentsViewController

#pragma mark - MomentsViewController management

- (void)viewDidLoad {
    [super viewDidLoad];
    _momentModel = [[MomentsModel alloc] init];
    _momentModel.delegate = self;
    _hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_hud];
    [self initRefreshControl];
    [self initNewMessageView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNSNotifications:)
                                                 name:CALL_PUSH_NOTIFICATIONS object:nil];
    [self getAllMessage];
    [UserData currentAccount].needRefreshPublicScreen = @"0";


}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    if ([[UserData currentAccount].needRefreshPublicScreen boolValue])
    {
        [self getAllMessage];
        [UserData currentAccount].needRefreshPublicScreen = @"0";
    }
}

- (void)pushNSNotifications:(NSNotification*)notify{
    self.newsMomentButton.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Custom Methods

- (void)setupTable{
    [self setupTableView:_messagesHotTableView];
    [self setupTableView:_messagesNewestTableView];
}

- (void)getAllMessage {
    _newsMomentButton.hidden = YES;
    [_hud show:YES];
    [_momentModel getAllMessagesSuccess:^(id result) {
        NSLog(@"Message hot count : %lu",(unsigned long)_momentModel.messagesHot.count);
        NSLog(@"Message newest count : %lu",(unsigned long)_momentModel.messagesNewest.count);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setupTable];
            [_messagesHotTableView reloadData];
            [_messagesNewestTableView reloadData];

        });
        [_hud hide:YES];
    } failure:^(NSError *error) {
        [_hud hide:YES];
    }];
}

- (void)initRefreshControl
{
    _refreshControl = [[ODRefreshControl alloc] initInScrollView:_messagesHotTableView];
    [_refreshControl addTarget:self action:@selector(refreshTableView) forControlEvents:UIControlEventValueChanged];
    
    _refreshControlMessageNewest = [[ODRefreshControl alloc] initInScrollView:_messagesNewestTableView];
    [_refreshControlMessageNewest addTarget:self action:@selector(refreshTableView) forControlEvents:UIControlEventValueChanged];
}

- (void)initNewMessageView
{
    CGRect frameExtend = [_newsMomentButton frame];
    frameExtend.origin.y = WIDTH_BUTTON_NEW_MOMENTS;
    frameExtend.origin.x = CGRectGetWidth(self.view.frame)/3;
    frameExtend.size.width = CGRectGetWidth(self.view.frame)/3;
    frameExtend.size.height = HIGHT_BUTTON_NEW_MOMENTS;
    
    _newsMomentButton = [[UIButton alloc] initWithFrame:frameExtend];
    
    [_newsMomentButton setBackgroundColor:[UIColor lightGrayColor]];
    _newsMomentButton.layer.cornerRadius = CORNER_RADIUS;
    
    [_newsMomentButton setTitle:TITLE_BUTTON_NEW_MOMENTS forState:UIControlStateNormal];
    [_newsMomentButton.titleLabel setFont:[UIFont systemFontOfSize:TITLE_BUTTON_NEW_MOMENTS_FONT_SIZE]];
    [_newsMomentButton addTarget:self action:@selector(callPullDownRequest:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_newsMomentButton];
    self.newsMomentButton.hidden = YES;
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:PUSH_MESSAGE_DETAILS_VIEW_CONTROLLER])
    {
        _messageDetailsViewController = [segue destinationViewController];
        _messageDetailsViewController.messageObject = _messageSelected;
        _messageDetailsViewController.hidesBottomBarWhenPushed = YES;
    }
}

#pragma mark - TableView delegates & datasources

- (void)setupTableView:(UITableView *)tableView{
    TableViewCellConfigureBlock configureCell = ^(MomentsMessageTableViewCell *momentsMessageTableViewCell, MessageObject *myMessage){
        momentsMessageTableViewCell.delegate = self;
        [momentsMessageTableViewCell setMessageWithMessage:myMessage];
    };
    
    if (tableView == _messagesHotTableView) {
        _arrayDataSourceMessageHot = [[ArrayDataSource alloc]initWithItems:_momentModel.messagesHot
                                                            cellIdentifier:MomentViewCellIdentifier
                                                        configureCellBlock:configureCell];
        
        _messagesHotTableView.dataSource = _arrayDataSourceMessageHot;
        [_messagesHotTableView registerClass:[MomentsMessageTableViewCell class] forCellReuseIdentifier:MomentViewCellIdentifier];
    }
    else if (tableView == _messagesNewestTableView)
    {
        _arrayDataSourceMessageNewest = [[ArrayDataSource alloc]initWithItems:_momentModel.messagesNewest
                                                               cellIdentifier:MomentViewCellIdentifier
                                                           configureCellBlock:configureCell];
        
        _messagesNewestTableView.dataSource = _arrayDataSourceMessageNewest;
        [_messagesNewestTableView registerClass:[MomentsMessageTableViewCell class] forCellReuseIdentifier:MomentViewCellIdentifier];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _messagesHotTableView) {
        _messageSelected = [_momentModel.messagesHot objectAtIndex:indexPath.row];
    }
    if (tableView == _messagesNewestTableView) {
        _messageSelected = [_momentModel.messagesNewest objectAtIndex:indexPath.row];
    }
    [self performSegueWithIdentifier:PUSH_MESSAGE_DETAILS_VIEW_CONTROLLER sender:nil];
}

#pragma mark - Refresh control management

- (void)refreshTableView {
    [_momentModel getAllMessagesSuccess:^(id result) {
        NSLog(@"Message hot found: %lu",(unsigned long)_momentModel.messagesHot.count);
        NSLog(@"Message newest found: %lu",(unsigned long)_momentModel.messagesNewest.count);
        [self refreshTableViewDone];
    } failure:^(NSError *error) {
        [self refreshTableViewDone];
    }];
    _newsMomentButton.hidden = YES;
}

- (void)refreshTableViewDone{
    [_refreshControl endRefreshing];
    [_refreshControlMessageNewest endRefreshing];
    [_messagesHotTableView reloadData];
    [_messagesNewestTableView reloadData];
}

#pragma mark - Actions

- (IBAction)changeTypeToShowMessageAction:(id)sender {
    if (_typeToShowMessageSegment.selectedSegmentIndex == TypeToShowMessageHot) {
        _messagesHotTableView.hidden = NO;
        _messagesNewestTableView.hidden = YES;
    }
    else
    {
        _messagesHotTableView.hidden = YES;
        _messagesNewestTableView.hidden = NO;
    }
}

- (void)callPullDownRequest:(id)sender{
    // Button New moment
    [self getAllMessage];
}

#pragma mark - MomentsModel delegate

- (void)didVoteMessageSuccess:(MomentsModel *)momentsDetailsModel
{
    [self getAllMessage];
}

- (void)didVoteMessageFailed:(MomentsModel *)momentsDetailsModel
{
    [self getAllMessage];
}

#pragma MomentsMessageTableViewCell delegate

- (void)didClickVote:(MomentsMessageTableViewCell *)momentsMessageTableViewCell withMessage:(MessageObject *)messageVote
{
    [_momentModel voteMessage:messageVote];
}

@end
