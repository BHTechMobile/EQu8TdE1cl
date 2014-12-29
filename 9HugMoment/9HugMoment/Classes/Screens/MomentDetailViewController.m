//
//  MomentDetailViewController.m
//  9HugMoment
//
//  Created by Tommy on 11/24/14.
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import "MomentDetailViewController.h"

static NSDateFormatter *_dateFormatter;

@implementation MomentDetailViewController{
    MomentsModel *_momentModel;
    MomentsDetailsModel *_momentsDetailsModel;
    EnterMessageView *_enterMessageView;
    MBProgressHUD *_hud;
    NSCache *_avatarCache;
}

#pragma mark - MomentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _avatarCache = [[NSCache alloc] init];
    _momentsDetailsModel = [[MomentsDetailsModel alloc] init];
    _momentsDetailsModel.delegate = self;
    _momentsDetailsModel.message = _messageObject;
    [self initProgressHUD];
    [self initDateFormat];
    [self initInputMessageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [self requestMessage];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [_videoPlayer pause];
    _videoPlayer = nil;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

#pragma mark - Custom Methods

- (NSString *)setFormatDate :(NSDate *)date andFormat:(NSString *)stringFormat
{
    NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
    [_formatter setDateFormat:stringFormat];
    NSString *sentDate = [_formatter stringFromDate:date];
    return sentDate;
}

- (void)initVideoPlayer
{
    _videoPlayer = [PlayerView fromNib];
    [_videoPlayer setFrame:CGRectMake(0, 0, _messageContentTableView.frame.size.width, _messageContentTableView.frame.size.width)];
}

- (void)initInputMessageView
{
    _enterMessageView = [EnterMessageView fromNib];
    _enterMessageView.delegate = self;
    [self setDefaultFrameInputMessageView];
    [self.view addSubview:_enterMessageView];
    _enterMessageView.hidden = YES;
}

- (void)setDefaultFrameInputMessageView
{
    CGPoint enterMessagePoint = CGPointMake(HALF_OF(_messageContentTableView.frame.size.width) - HALF_OF(SIZE_ENTER_MESSAGE_MOMENT_DETAIL_VIEW_CONTROLLER.width), HALF_OF(_messageContentTableView.frame.size.height) - HALF_OF(SIZE_ENTER_MESSAGE_MOMENT_DETAIL_VIEW_CONTROLLER.height));
    CGRect enterMessageFrame = CGRectMake(enterMessagePoint.x, enterMessagePoint.y, SIZE_ENTER_MESSAGE_MOMENT_DETAIL_VIEW_CONTROLLER.width, SIZE_ENTER_MESSAGE_MOMENT_DETAIL_VIEW_CONTROLLER.height);
    _enterMessageView.frame = enterMessageFrame;
}

- (void)setFrameInputMessageViewHide
{
    CGRect enterMessageFarmeTemp = _enterMessageView.frame;
    enterMessageFarmeTemp.origin.x = HALF_OF(enterMessageFarmeTemp.size.width);
    enterMessageFarmeTemp.origin.y = enterMessageFarmeTemp.origin.y + HALF_OF(enterMessageFarmeTemp.size.height);
    enterMessageFarmeTemp.size.width = 0;
    enterMessageFarmeTemp.size.height = 0;
    _enterMessageView.frame = enterMessageFarmeTemp;
}

- (void)keyboardWillShow:(NSNotification*)aNotification
{
    NSDictionary *keyboardInfo = [aNotification userInfo];
    NSValue *keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    CGFloat yPointEnterMessageShow = HALF_OF(_messageContentTableView.frame.size.height) - HALF_OF(SIZE_ENTER_MESSAGE_MOMENT_DETAIL_VIEW_CONTROLLER.height);
    CGFloat yPointKeyboardAfterShow = keyboardFrameBeginRect.origin.y - keyboardFrameBeginRect.size.height;
    if (yPointKeyboardAfterShow < (yPointEnterMessageShow + SIZE_ENTER_MESSAGE_MOMENT_DETAIL_VIEW_CONTROLLER.height)) {
        
        [UIView animateWithDuration:TIME_TO_SHOW_ENTER_MESSAGE_VIEW animations:^{
            CGPoint enterMessagePoint = CGPointMake(HALF_OF(_messageContentTableView.frame.size.width) - HALF_OF(SIZE_ENTER_MESSAGE_MOMENT_DETAIL_VIEW_CONTROLLER.width), yPointKeyboardAfterShow - SIZE_ENTER_MESSAGE_MOMENT_DETAIL_VIEW_CONTROLLER.height);
            CGRect enterMessageFrame = CGRectMake(enterMessagePoint.x, enterMessagePoint.y, SIZE_ENTER_MESSAGE_MOMENT_DETAIL_VIEW_CONTROLLER.width, SIZE_ENTER_MESSAGE_MOMENT_DETAIL_VIEW_CONTROLLER.height);
            _enterMessageView.frame = enterMessageFrame;
        }];
        
    }else {
        [UIView animateWithDuration:TIME_TO_SHOW_ENTER_MESSAGE_VIEW animations:^{
            [self setDefaultFrameInputMessageView];
        }];
    }
}

- (void)initProgressHUD
{
    _hud = [[MBProgressHUD alloc] initWithView:self.view];
    _hud.userInteractionEnabled = NO;
    _hud.labelText = NSLocalizedString(@"Loading...", nil);
    _hud.labelFont = FONT_SIZE_DEFAULT_HUD;
    _hud.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:_hud];
}

- (void)initDateFormat
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"HH:mm"];
    }
}

- (void)requestMessage
{
    [_hud show:YES];
    [_momentsDetailsModel getMessageByKey:_messageObject.key];
}

#pragma mark - TableView delegates & datasources

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == MomentDetailCellTypePlayer){
        return _messageContentTableView.frame.size.width;
    }else if (indexPath.row == MomentDetailCellTypeUserInfo){
        return HEIGHT_USER_INFO_CELL_MOMENT_DETAIL_VIEW_CONTROLLER;
    }else if (indexPath.row == MomentDetailCellTypeUpvoteMessage){
        return HEIGHT_UP_VOTE_MESSAGE_DEFAULT_CELL_MOMENT_DETAIL_VIEW_CONTROLLER;
    }else if (indexPath.row == MomentDetailCellTypeCommentHeader){
        return HEIGHT_COMMENT_HEADER_CELL_MOMENT_DETAIL_VIEW_CONTROLLER;
    }else {
        return HEIGHT_COMMENT_MESSAGE_CELL_MOMENT_DETAIL_VIEW_CONTROLLER;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int numberOfMessage = 0;
    @try {
        numberOfMessage = (int)_messageObject.voicesArray.count;
    }
    @catch (NSException *exception) {
        numberOfMessage = 0;
    }
    return MomentDetailCellTypeCommentMessage + numberOfMessage;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cellResult;
    if (indexPath.row == MomentDetailCellTypePlayer) {
        cellResult = [self playerCellForRowAtTable:tableView];
    }else if(indexPath.row == MomentDetailCellTypeUserInfo) {
        cellResult = [self userInfoCellForRowAtTable:tableView];
    }else if(indexPath.row == MomentDetailCellTypeUpvoteMessage){
        cellResult = [self upVoteMessageCellForRowAtTable:tableView];
    }else if(indexPath.row == MomentDetailCellTypeCommentHeader){
        cellResult = [self commentHeaderCellForRowAtTable:tableView withIndexPath:indexPath];
    }else {
        cellResult = [self commentMessageCellForRowAtTable:tableView withIndexPath:indexPath];
    }
    cellResult.selectionStyle = UITableViewCellSelectionStyleNone;
    return cellResult;
}

#pragma mark - TableView Cell & Data
// Init Cell
- (PlayerViewTableViewCell *)playerCellForRowAtTable:(UITableView *)tableView
{
    PlayerViewTableViewCell *cell = (PlayerViewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:IDENTIFIER_PLAYER_VIEW_TABLE_VIEW_CELL];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:[[PlayerViewTableViewCell class] description] bundle:nil] forCellReuseIdentifier:IDENTIFIER_PLAYER_VIEW_TABLE_VIEW_CELL];
        cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER_PLAYER_VIEW_TABLE_VIEW_CELL];
        
    }
    if (!_videoPlayer) {
        [self initVideoPlayer];
        [_videoPlayer playWithUrl:_capturePath];
    }
    [cell.playerViewCell addSubview:_videoPlayer];
    return cell;
}

- (UserInfoTableViewCell *)userInfoCellForRowAtTable:(UITableView *)tableView
{
    UserInfoTableViewCell *cell = (UserInfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:IDENTIFIER_USER_INFO_TABLE_VIEW_CELL];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:[[UserInfoTableViewCell class] description] bundle:nil] forCellReuseIdentifier:IDENTIFIER_USER_INFO_TABLE_VIEW_CELL];
        cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER_USER_INFO_TABLE_VIEW_CELL];
    }
    cell.delegate = self;
    cell.userNameLabel.text = _messageObject.fullName;
    cell.voteNumberLabel.text = [_momentsDetailsModel getNumberOfVoteWithMessage:_messageObject];
    cell.voteButton.titleLabel.text = [_momentsDetailsModel getNumberOfVoteWithMessage:_messageObject];
    cell.isUserVoted = [_momentsDetailsModel isUserVotedWithUserID:_messageObject.userID];
    
    if ([_messageObject.location isEqualToString:@""] || !_messageObject.location) {
        cell.locationLabel.text = @"Private";
    }else {
        cell.locationLabel.text = _messageObject.location;
    }
    
    UIImage *userAvatar = [_avatarCache objectForKey:_messageObject.userFacebookID];
    if (!userAvatar) {
        [BaseServices downloadUserImageWithFacebookID:_messageObject.userFacebookID success:^(AFHTTPRequestOperation *operation, id responseObject){
            cell.userImageView.image = responseObject;
            [_avatarCache setObject:responseObject forKey:_messageObject.userFacebookID];
        }failure:^(AFHTTPRequestOperation *operation, NSError *error){
            NSLog(@"Error get user image from facebook: %@",error);
        }];
    }else {
        cell.userImageView.image = userAvatar;
    }
    
    return cell;
}

- (UpvoteMessageTableViewCell *)upVoteMessageCellForRowAtTable:(UITableView *)tableView
{
    UpvoteMessageTableViewCell *cell = (UpvoteMessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:IDENTIFIER_UP_VOTE_MESSAGE_TABLE_VIEW_CELL];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:[[UpvoteMessageTableViewCell class] description] bundle:nil] forCellReuseIdentifier:IDENTIFIER_UP_VOTE_MESSAGE_TABLE_VIEW_CELL];
        cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER_UP_VOTE_MESSAGE_TABLE_VIEW_CELL];
    }
    cell.voteCountLabel.text = [_momentsDetailsModel getNumberOfVoteWithMessage:_messageObject];
    cell.usersFacebookIDArray = _momentsDetailsModel.userFacebookIDVoted;
    [cell showUserPhoto];
    return cell;
}

- (CommentHeaderTableViewCell *)commentHeaderCellForRowAtTable:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath
{
    CommentHeaderTableViewCell *cell = (CommentHeaderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:IDENTIFIER_COMMENT_HEADER_TABLE_VIEW_CELL];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:[[CommentHeaderTableViewCell class] description] bundle:nil] forCellReuseIdentifier:IDENTIFIER_COMMENT_HEADER_TABLE_VIEW_CELL];
        cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER_COMMENT_HEADER_TABLE_VIEW_CELL];
        cell.delegate = self;
        cell.addCommentButton.tag = indexPath.row;
    }
    return cell;
}

- (CommentMessageTableViewCell *)commentMessageCellForRowAtTable:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath
{
    CommentMessageTableViewCell *cell = (CommentMessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:IDENTIFIER_COMMENT_MESSAGE_TABLE_VIEW_CELL];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:[[CommentMessageTableViewCell class] description] bundle:nil] forCellReuseIdentifier:IDENTIFIER_COMMENT_MESSAGE_TABLE_VIEW_CELL];
        cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER_COMMENT_MESSAGE_TABLE_VIEW_CELL];
    }
    NSDictionary *currentComments = [_messageObject.voicesArray objectAtIndex:indexPath.row - MomentDetailCellTypeCommentMessage];
    cell.commentTextView.text = [currentComments objectForKey:KEY_MESSAGE_STRING];
    double timeInterval = [[currentComments objectForKey:KEY_SENT_DATE_2] doubleValue];
    NSString *timePostComment = [_dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
    cell.commentTimeLabel.text = timePostComment;
    NSString *currentUserFacebookID = [currentComments objectForKey:KEY_FACEBOOK_ID];
    UIImage *userAvatar = [_avatarCache objectForKey:currentUserFacebookID];
    if (!userAvatar) {
        [BaseServices downloadUserImageWithFacebookID:currentUserFacebookID success:^(AFHTTPRequestOperation *operation, id responseObject){
            cell.userCommentImage.image = responseObject;
            [_avatarCache setObject:responseObject forKey:currentUserFacebookID];
        }failure:^(AFHTTPRequestOperation *operation, NSError *error){
            NSLog(@"Error get user image from facebook: %@",error);
        }];
    }else {
        cell.userCommentImage.image = userAvatar;
    }
    return cell;
}
// Data Cell

#pragma mark - EnterMessage Delegate

- (void)didCancelInputMessage
{
    [self setFrameInputMessageViewHide];
    _enterMessageView.hidden = YES;
}

-(void)didEnterMessage:(EnterMessageView *)enterMessageController andMessage:(NSString *)message
{
    [_hud show:YES];
    [_momentsDetailsModel commentTextMessage:message];
    [self didCancelInputMessage];
}

#pragma mark - Actions

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - MomentsDetailsModel delegate

- (void)didGetMessageDetailSuccess:(MomentsDetailsModel *)momentsDetailsModel withMessage:(MessageObject *)messageResponce
{
    //TODO: Update Data
    _messageObject = messageResponce;
    [_momentsDetailsModel getNumberOfVoteWithMessage:_messageObject];
    [_messageContentTableView reloadData];
    [_hud hide:YES];
}
- (void)didGetMessageDetailFailed:(MomentsDetailsModel *)momentsDetailsModel withError:(NSError *)error
{
    [_hud hide:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Load Comment Failed!"
                                                    message:@"Can not load message"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [self.class showSingleAlert:alert];
}

- (void)didCommentTextMessageSuccess:(MomentsDetailsModel *)momentsDetailsModel
{
    [_hud hide:YES];
    [self requestMessage];
}

- (void)didCommentTextMessageFailed:(MomentsDetailsModel *)momentsDetailsModel
{
    [_hud hide:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Comment Failed!"
                                                    message:@"Can not post your comment, please try again."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [self.class showSingleAlert:alert];
}

- (void)didVoteMessageSuccess:(MomentsDetailsModel *)momentsDetailsModel
{
    [_momentsDetailsModel getMessageByKey:_messageObject.key];
}

- (void)didVoteMessageFailed:(MomentsDetailsModel *)momentsDetailsModel
{
    [_momentsDetailsModel getMessageByKey:_messageObject.key];
}

#pragma mark - CommentHeaderTableViewCell delegate

- (void)didClickAddCommentButton
{
    [self setFrameInputMessageViewHide];
    _enterMessageView.hidden = NO;
    [_enterMessageView.textView setText:@""];
    [_enterMessageView.textView becomeFirstResponder];
}

#pragma mark - UserInfoTableViewCell delegate
- (void)didUserClickVoteButton:(UserInfoTableViewCell *)userInfoTableViewCell
{
    [_momentsDetailsModel voteMessage];
}

#pragma mark - Alert
__strong static UIAlertView *singleAlert;

/**
 Shows alert view only if there is ho anoters shown alert
 @param alertView
 Alert to show.
 */
+ (void)showSingleAlert:(UIAlertView *)alertView {
    if (singleAlert.visible) {
        [singleAlert dismissWithClickedButtonIndex:0 animated:NO];
        singleAlert = nil;
    }
    singleAlert = alertView;
    [singleAlert show];
}

@end
