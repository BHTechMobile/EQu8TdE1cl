//
//  MessageDetailsViewController.m
//  9HugMoment
//

#import "MessageDetailsViewController.h"

@interface MessageDetailsViewController ()

@end

@implementation MessageDetailsViewController

#pragma mark - MessageDetailsViewController managements

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _messageDetailsModel = [[MessageDetailsModel alloc] init];
    _recordObject = [[RecordObject alloc] init];
    _recordObject.delegate = self;
    _messageDetailsModel.delegate = self;
    _messageDetailsModel.message = _messageObject;
    _imageCacheObject = [ImageCacheObject shareImageCache];
    [self initProgressHUD];
    [self initImagePicker];
    [self initActionSheet];
    [self updateUpVote];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self requestMessage];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    if (_moviePlayerStreaming) {
        [_moviePlayerStreaming stop];
    }
    if (_messageAudioTableViewCell.audioPlayer) {
        [_messageAudioTableViewCell.audioPlayer stop];
    }
}

#pragma mark - Actions

- (IBAction)cancelRecordAction:(id)sender {
}

- (IBAction)sendPhotoAction:(id)sender {
}

- (IBAction)playAudioAction:(id)sender {
    [_messageAudioTableViewCell playAllAudioAction];
}

- (IBAction)addPhotoAction:(id)sender {
    [self imagePickerPressed];
}

- (IBAction)recordAction:(id)sender {
    [_recordObject hideRecordView:_recordView];
    if (_recordObject.isRecordSuccess)
    {
        [_hud show:YES];
        [_messageDetailsModel uploadAudioMessage:^(id response, NSError *error) {
            if (!error)
            {
                [_hud hide:YES];
                [_messageDetailsModel getMessageByKey:_messageObject.key];
            }
            else
            {
                [_hud hide:YES];
            }
        }];
    }
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)likeAction:(id)sender {
    [_messageDetailsModel voteMessage];
}

- (IBAction)holdAndRecordAction:(id)sender {
    [_moviePlayerStreaming pause];
    [_recordObject showRecordView:_recordView withParentView:self.view];
}

#pragma mark - Custom Methods

- (void)initProgressHUD
{
    _hud = [[MBProgressHUD alloc] initWithView:self.view];
    _hud.userInteractionEnabled = NO;
    _hud.labelText = NSLocalizedString(@"Loading...", nil);
    _hud.labelFont = FONT_SIZE_DEFAULT_HUD;
    _hud.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:_hud];
}

- (void)requestMessage
{
    [_hud show:YES];
    [_messageDetailsModel getMessageByKey:_messageObject.key];
}

- (void)initVideoStreaming
{
    NSURL *videoURL = [NSURL URLWithString:_messageObject.attachement1];
    _moviePlayerStreaming = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
    _moviePlayerStreaming.controlStyle = MPMovieControlStyleEmbedded;
    _moviePlayerStreaming.shouldAutoplay = NO;

    _moviePlayerStreaming.view.frame = CGRectMake(0, 0, _messageDetailsTableView.frame.size.width - PADDING_VIDEO_PLAYER_VIEW_MESSAGE_DETAILS_VIEW_CONTROLLER, _messageDetailsTableView.frame.size.width - PADDING_VIDEO_PLAYER_VIEW_MESSAGE_DETAILS_VIEW_CONTROLLER);
    [_moviePlayerStreaming prepareToPlay];
}

- (void)updateUpVote
{
    BOOL isCurrentUserVoted = [MessageDetailsModel isCurrentUserVoted:_messageObject];
    if (isCurrentUserVoted) {
        [_likeButton setBackgroundImage:[UIImage imageNamed:IMAGE_NAME_ICON_LIKE_BLUE] forState:UIControlStateNormal];
        [_likeButton setBackgroundImage:[UIImage imageNamed:IMAGE_NAME_ICON_LIKE_BLUE] forState:UIControlStateHighlighted];
    }
    else
    {
       [_likeButton setBackgroundImage:[UIImage imageNamed:IMAGE_NAME_ICON_LIKE_GRAY] forState:UIControlStateNormal];
        [_likeButton setBackgroundImage:[UIImage imageNamed:IMAGE_NAME_ICON_LIKE_GRAY] forState:UIControlStateHighlighted];
    }
}

#pragma mark - Table View delegates & datasources

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == MessageDetailCellTypePlayer){
        return _messageDetailsTableView.frame.size.width;
    }else if (indexPath.row == MessageDetailCellTypeUserInfo){
        return HEIGHT_USER_INFO_CELL_MESSAGE_DETAILS_VIEW_CONTROLLER;
    }else if (indexPath.row == MessageDetailCellTypeCaption){
        return (HEIGHT_CAPTION_CELL_DEFAULT_MESSAGE_DETAILS_VIEW_CONTROLLER >  heightMessageCaptionCell)?HEIGHT_CAPTION_CELL_DEFAULT_MESSAGE_DETAILS_VIEW_CONTROLLER:heightMessageCaptionCell;
    }else if (indexPath.row == MessageDetailCellTypeCommentAudio){
        return HEIGHT_COMMENT_AUDIO_CELL_DEFAULT_MESSAGE_DETAILS_VIEW_CONTROLLER;
    }else if (indexPath.row == MessageDetailCellTypeCommentPicture){
        return HEIGHT_COMMENT_PHOTO_CELL_DEFAULT_MESSAGE_DETAILS_VIEW_CONTROLLER + HALF_OF(HEIGHT_RECORD_BUTTON_MESSAGE_DETAILS_VIEW_CONTROLLER);
    }else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return MessageDetailCellTypeMax;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cellResult;
    if (indexPath.row == MessageDetailCellTypePlayer) {
        cellResult = [self playerCellForRowAtTable:tableView];
    }else if(indexPath.row == MessageDetailCellTypeUserInfo) {
        cellResult = [self userInfoCellForRowAtTable:tableView];
    }else if(indexPath.row == MessageDetailCellTypeCaption){
        cellResult = [self messageCaptionCellForRowAtTable:tableView withIndexPath:indexPath];
    }else if(indexPath.row == MessageDetailCellTypeCommentAudio){
        cellResult = [self messageAudioCellForRowAtTable:tableView];
    }else {
        cellResult = [self messagePictureCellForRowAtTable:tableView];
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
    if (!_moviePlayerStreaming) {
        [self initVideoStreaming];
    }
    [cell.playerViewCell addSubview:_moviePlayerStreaming.view];
    return cell;
}

- (UserInfoTableViewCell *)userInfoCellForRowAtTable:(UITableView *)tableView
{
    UserInfoTableViewCell *cell = (UserInfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:IDENTIFIER_USER_INFO_TABLE_VIEW_CELL];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:[[UserInfoTableViewCell class] description] bundle:nil] forCellReuseIdentifier:IDENTIFIER_USER_INFO_TABLE_VIEW_CELL];
        cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER_USER_INFO_TABLE_VIEW_CELL];
    }
    cell.userNameLabel.text = _messageObject.fullName;
    cell.timeUploadLabel.text = [_messageDetailsModel getDateTimeByTimeInterval:[_messageObject.sentDate intValue]];
    cell.numberMessageLabel.text = [NSString stringWithFormat:@"%d",(int)[_messageDetailsModel totalMessageRequest]];
    [_messageDetailsModel.class getUserAvatarWithUserFacebookID:_messageObject.userFacebookID forImageView:cell.userImageView];
    return cell;
}

- (MessageCaptionTableViewCell *)messageCaptionCellForRowAtTable:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath
{
    MessageCaptionTableViewCell *cell = (MessageCaptionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:IDENTIFIER_MESSAGE_CAPTION_TABLE_VIEW_CELL];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:[[MessageCaptionTableViewCell class] description] bundle:nil] forCellReuseIdentifier:IDENTIFIER_MESSAGE_CAPTION_TABLE_VIEW_CELL];
        cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER_MESSAGE_CAPTION_TABLE_VIEW_CELL];
    }
    
    if (_messageObject.text && ![_messageObject.text isEqualToString:@""]) {
        cell.captionTextView.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
        cell.captionTextView.text = _messageObject.text;
        CGSize sizeCaptionTextView = [cell.captionTextView sizeThatFits:CGSizeMake(cell.captionTextView.width, FLT_MAX)];
        heightMessageCaptionCell = sizeCaptionTextView.height - PADDING_TOP_CAPTION_TEXT_VIEW_MESSAGE_DETAILS_VIEW_CONTROLLER - PADDING_BOTTOM_CAPTION_TEXT_VIEW_MESSAGE_DETAILS_VIEW_CONTROLLER;
    }
    else
    {
        heightMessageCaptionCell = 0;
    }
    [self tableView:tableView heightForRowAtIndexPath:indexPath];
    return cell;
}

- (MessageAudioTableViewCell *)messageAudioCellForRowAtTable:(UITableView *)tableView
{
    _messageAudioTableViewCell = (MessageAudioTableViewCell *)[tableView dequeueReusableCellWithIdentifier:IDENTIFIER_MESSAGE_AUDIO_TABLE_VIEW_CELL];
    if (!_messageAudioTableViewCell) {
        [tableView registerNib:[UINib nibWithNibName:[[MessageAudioTableViewCell class] description] bundle:nil] forCellReuseIdentifier:IDENTIFIER_MESSAGE_AUDIO_TABLE_VIEW_CELL];
        _messageAudioTableViewCell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER_MESSAGE_AUDIO_TABLE_VIEW_CELL];
    }
    [_messageDetailsModel getAudioCommentFromArray:_messageObject.voicesArray];
    _messageAudioTableViewCell.audioCommentObjectArray = (NSMutableArray *)[[_messageDetailsModel.audioCommentObjectArray reverseObjectEnumerator] allObjects];
    [_messageAudioTableViewCell showUsersAudio];
    return _messageAudioTableViewCell;
}

- (MessagePictureTableViewCell *)messagePictureCellForRowAtTable:(UITableView *)tableView
{
    MessagePictureTableViewCell *cell = (MessagePictureTableViewCell *)[tableView dequeueReusableCellWithIdentifier:IDENTIFIER_MESSAGE_PICTURE_TABLE_VIEW_CELL];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:[[MessagePictureTableViewCell class] description] bundle:nil] forCellReuseIdentifier:IDENTIFIER_MESSAGE_PICTURE_TABLE_VIEW_CELL];
        cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER_MESSAGE_PICTURE_TABLE_VIEW_CELL];
        cell.delegate = self;
    }
    [_messageDetailsModel getPictureCommentFromArray:_messageObject.photosArray];
    cell.pictureCommentObjectArray = (NSMutableArray *)[[_messageDetailsModel.pictureCommentObjectArray reverseObjectEnumerator] allObjects];
    [cell showPictures];
    return cell;
}

#pragma mark - MessageDetailsModel delegate

- (void)didGetMessageDetailSuccess:(MessageDetailsModel *)momentsDetailsModel withMessage:(MessageObject *)messageResponce
{
    //TODO: Update Data
    _messageDetailsModel.message = _messageObject = messageResponce;
    [_messageDetailsTableView reloadData];
    [_hud hide:YES];
    [self updateUpVote];
}

- (void)didGetMessageDetailFailed:(MessageDetailsModel *)momentsDetailsModel withError:(NSError *)error
{
    [_hud hide:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Load Comment Failed!"
                                                    message:@"Can not load message"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [MessageDetailsModel showSingleAlert:alert];
}

- (void)didVoteMessageSuccess:(MessageDetailsModel *)momentsDetailsModel
{
    [_messageDetailsModel getMessageByKey:_messageObject.key];
}

- (void)didVoteMessageFailed:(MessageDetailsModel *)momentsDetailsModel
{
    [_messageDetailsModel getMessageByKey:_messageObject.key];
}

#pragma mark - Image Picker & Action sheet management & delegate

- (void)initImagePicker
{
    _imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.navigationBar.translucent = NO;
    _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _imagePicker.delegate = self;
}

- (void)initActionSheet
{
    _imageSourceActionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(PHOTO_SOURCE_PICKER_TITLE_MESSAGE_DETAILS_VIEW_CONTROLLER, nil)
                                                          delegate:self cancelButtonTitle:NSLocalizedString(PHOTO_SOURCE_PICKER_CANCEL_MESSAGE_DETAILS_VIEW_CONTROLLER, nil)
                                            destructiveButtonTitle:nil
                                                 otherButtonTitles:NSLocalizedString(PHOTO_SOURCE_CAMERA_MESSAGE_DETAILS_VIEW_CONTROLLER, nil), NSLocalizedString(PHOTO_SOURCE_ALBUM_MESSAGE_DETAILS_VIEW_CONTROLLER, nil), nil];
}

- (void)imagePickerPressed
{
    [_moviePlayerStreaming pause];
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        [_imageSourceActionSheet showInView:self.view];
    } else {
        _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:_imagePicker animated:YES completion:nil];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            SquareCamViewController *squareVC = [SquareCamViewController new];
            squareVC.delegate = self;
            [self.navigationController pushViewController:squareVC animated:YES];
            break;
        }
        case 1:
            _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:_imagePicker animated:YES completion:nil];
            break;
            
        default:
            break;
    }
}

- (void)saveImage :(UIImage *)image{
    NSData* imageData = UIImageJPEGRepresentation(image, 1.0);
    [imageData writeToFile:URL_ATTACH_IMAGE atomically:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    // set thumbnail
    [self saveImage:image];
    //upload
    [_hud show:YES];
    [_messageDetailsModel uploadPhotoMessage:^(id response, NSError *error) {
        if (!error)
        {
            [_messageDetailsModel getMessageByKey:_messageObject.key];
        }
    }];
}

- (void)didCaptureCamera:(UIImage *)image{
    [self saveImage:image];
    //upload
    [_hud show:YES];
    [_messageDetailsModel uploadPhotoMessage:^(id response, NSError *error) {
        if (!error)
        {
            [_messageDetailsModel getMessageByKey:_messageObject.key];
        }
    }];
}

#pragma mark - MessagePictureTableViewCell delegate

- (void)willShowSlideImageView:(SlideImageViewController *)slideImageViewController withCell:(MessagePictureTableViewCell *)messagePictureTableViewCell
{
    [self presentViewController:slideImageViewController animated:YES completion:^{
    }];
}

#pragma mark - RecordObject delegate

- (void)updateCurrentTimeRecord:(NSString *)timeRecord withRecorObject:(RecordObject *)recordObject
{
    _currentTimeRecordLabel.text = timeRecord;
}

@end
