//
//  MeScreenViewController.m
//  9HugMoment
//

#import "MeScreenViewController.h"
#import "MeScreenModel.h"

@interface MeScreenViewController ()<UITextFieldDelegate, MeScreenModelDelegate>

@property (strong, nonatomic) MeScreenModel *meScreenModel;

@property (weak, nonatomic) IBOutlet UIImageView *userPhotoImageView;
@property (weak, nonatomic) IBOutlet UIButton *userPhotoButton;
@property (weak, nonatomic) IBOutlet UITextField *inputStatusTextField;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfCreditsTopContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *creditsTopContentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundStatisticImageView;
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;

//Gifts Sent
@property (strong, nonatomic) IBOutlet UIButton *giftsSentButton;
@property (strong, nonatomic) IBOutlet UILabel *numberOfGiftsSentLabel;
@property (weak, nonatomic) IBOutlet UILabel *giftsSentLabel;
//Request
@property (strong, nonatomic) IBOutlet UIButton *requestsButton;
@property (strong, nonatomic) IBOutlet UILabel *numberOfRequestsLabel;
@property (weak, nonatomic) IBOutlet UILabel *requestsLabel;
//Friends
@property (strong, nonatomic) IBOutlet UIButton *friendsButton;
@property (strong, nonatomic) IBOutlet UILabel *numberOfFriendsLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendsLabel;
//Credits
@property (strong, nonatomic) IBOutlet UIButton *creditsButton;
@property (strong, nonatomic) IBOutlet UILabel *numberOfCreditsLabel;
@property (weak, nonatomic) IBOutlet UILabel *creditsLabel;
//Stickers
@property (strong, nonatomic) IBOutlet UIButton *stickersButton;
@property (strong, nonatomic) IBOutlet UILabel *numberOfStickersLabel;
@property (weak, nonatomic) IBOutlet UILabel *stickersLabel;

- (IBAction)userPhotoAction:(id)sender;
- (IBAction)giftsSentAction:(id)sender;
- (IBAction)requestsAction:(id)sender;
- (IBAction)friendsAction:(id)sender;
- (IBAction)creditsAction:(id)sender;
- (IBAction)stickersAction:(id)sender;
- (IBAction)tapViewAction:(id)sender;

@end

@implementation MeScreenViewController

#pragma mark - MeScreenViewController management

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _meScreenModel = [[MeScreenModel alloc] init];
    _meScreenModel.delegate = self;
    [self setFontCalibri];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self initData];
    [self setUpStatusImage];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - Actions

- (IBAction)logout:(id)sender {
    [[FBSession activeSession] closeAndClearTokenInformation];
    [APP_DELEGATE.session closeAndClearTokenInformation];
    [[UserData currentAccount] clearCached];
    self.tabBarController.selectedIndex = 2;
}

- (IBAction)userPhotoAction:(id)sender {
    //TODO: Click to user Photo
}

- (IBAction)giftsSentAction:(id)sender {
    //TODO: Click to user Gifts sent
}

- (IBAction)requestsAction:(id)sender {
    //TODO: Click to user Request
}

- (IBAction)friendsAction:(id)sender {
    //TODO: Click to user Friends
}

- (IBAction)creditsAction:(id)sender {
    //TODO: Click to user Credits
}

- (IBAction)stickersAction:(id)sender {
    //TODO: Click to user Stcikers
}

- (IBAction)tapViewAction:(id)sender {
    [self.view endEditing:YES];
}

#pragma mark - Custom Methods

- (void)initData
{
    
    //Avatar
    [_userPhotoImageView.layer setMasksToBounds:YES];
    [_userPhotoImageView.layer setCornerRadius:HALF_OF(_userPhotoImageView.frame.size.width)];
    NSLog(@"Facebook ID: %@",[UserData currentAccount].strFacebookId);
    [_meScreenModel.class getUserAvatarWithUserFacebookID:[UserData currentAccount].strFacebookId forImageView:_userPhotoImageView];
    //Name
    _userNameLabel.text = [[UserData currentAccount].strFullName uppercaseString];
    
    //Status
    [_meScreenModel getUserStatus];
    
    //Statistics
    [_meScreenModel getUserStatistics];
}

- (void)updateStatistics
{
    _numberOfGiftsSentLabel.text = [UserData currentAccount].strUserNumberOfGifts;
    _numberOfRequestsLabel.text = [UserData currentAccount].strUserNumberOfRequests;
    _numberOfFriendsLabel.text = [UserData currentAccount].strUserNumberOfFriends;
    _numberOfCreditsLabel.text = _numberOfCreditsTopContentLabel.text = [UserData currentAccount].strUserNumberOfCredits;
    _numberOfStickersLabel.text = [UserData currentAccount].strUserNumberOfStickers;
}

- (void)setFontCalibri{
    [_userNameLabel setFont:CalibriFont(SIZE_FONT_LABEL_USER_NAME_ME_SCREEN_VIEW_CONTROLLER)];
    [_inputStatusTextField setFont:CalibriFont(SIZE_FONT_LABEL_INPUT_STATUS_ME_SCREEN_VIEW_CONTROLLER)];
    [_creditsTopContentLabel setFont:CalibriFont(SIZE_FONT_LABEL_CREDIT_TOP_CONTENT_ME_SCREEN_VIEW_CONTROLLER)];
    
    [_numberOfGiftsSentLabel setFont:CalibriFont(_numberOfGiftsSentLabel.size.width / PROPORTION_LABEL_WIDH_AND_FONT_ME_SCREEN_VIEW_CONTROLLER)];
    [_numberOfRequestsLabel setFont:CalibriFont(_numberOfRequestsLabel.size.width / PROPORTION_LABEL_WIDH_AND_FONT_ME_SCREEN_VIEW_CONTROLLER)];
    [_numberOfFriendsLabel setFont:CalibriFont(_numberOfFriendsLabel.size.width / PROPORTION_LABEL_WIDH_AND_FONT_ME_SCREEN_VIEW_CONTROLLER)];
    [_numberOfCreditsLabel setFont:CalibriFont(_numberOfCreditsLabel.size.width / PROPORTION_LABEL_WIDH_AND_FONT_ME_SCREEN_VIEW_CONTROLLER)];
    [_numberOfStickersLabel setFont:CalibriFont(_numberOfStickersLabel.size.width / PROPORTION_LABEL_WIDH_AND_FONT_ME_SCREEN_VIEW_CONTROLLER)];
    
    [_giftsSentLabel setFont:CalibriFont(_giftsSentLabel.size.width / PROPORTION_LABEL_WIDH_AND_FONT_ME_SCREEN_VIEW_CONTROLLER)];
    [_requestsLabel setFont:CalibriFont(_requestsLabel.size.width / PROPORTION_LABEL_WIDH_AND_FONT_ME_SCREEN_VIEW_CONTROLLER)];
    [_friendsLabel setFont:CalibriFont(_friendsLabel.size.width / PROPORTION_LABEL_WIDH_AND_FONT_ME_SCREEN_VIEW_CONTROLLER)];
    [_creditsLabel setFont:CalibriFont(_creditsLabel.size.width / PROPORTION_LABEL_WIDH_AND_FONT_ME_SCREEN_VIEW_CONTROLLER)];
    [_stickersLabel setFont:CalibriFont(_stickersLabel.size.width / PROPORTION_LABEL_WIDH_AND_FONT_ME_SCREEN_VIEW_CONTROLLER)];
    
}

- (void)setUpStatusImage
{
    [_meScreenModel setImageFrameMessage:_statusImageView];
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField.text.length > 0) {
        //TODO: Sent to servers
        [_meScreenModel updateUserStatus:textField.text];
    }
    return YES;
}

#pragma mark - MeScreenModel Delegate

- (void)didUpdateUserStatusSuccess:(MeScreenModel *)meScreenModel
{
    //TODO: Waiting server
    _inputStatusTextField.text = [UserData currentAccount].strUserStatus;
}

- (void)didUpdateUserStatusFail:(MeScreenModel *)meScreenModel withError:(NSError *)error
{
    //TODO: Waiting server
}

- (void)didGetUserStatusSuccess:(MeScreenModel *)meScreenModel
{
    //TODO: Waiting server
    _inputStatusTextField.text = [UserData currentAccount].strUserStatus;
}

- (void)didGetUserStatusFail:(MeScreenModel *)meScreenModel withError:(NSError *)error
{
    //TODO: Waiting server
}

- (void)didGetUserStatisticsSuccess:(MeScreenModel *)meScreenModel
{
    //TODO: Waiting server
    [self updateStatistics];
}

- (void)didGetUserStatisticsFail:(MeScreenModel *)meScreenModel withError:(NSError *)error
{
    //TODO: Waiting server
}

@end
