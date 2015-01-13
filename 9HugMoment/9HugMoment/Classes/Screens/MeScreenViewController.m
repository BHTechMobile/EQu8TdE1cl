//
//  MeScreenViewController.m
//  9HugMoment
//

#import "MeScreenViewController.h"
#import "MeScreenModel.h"
#import "StatisticsObject.h"

@interface MeScreenViewController ()<UITextFieldDelegate, MeScreenModelDelegate>

@property (strong, nonatomic) MeScreenModel *meScreenModel;

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
}

- (IBAction)giftsSentAction:(id)sender {
}

- (IBAction)requestsAction:(id)sender {
}

- (IBAction)friendsAction:(id)sender {
}

- (IBAction)creditsAction:(id)sender {
}

- (IBAction)stickersAction:(id)sender {
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

- (void)updateStatistics:(StatisticsObject *)statisticsObject
{
    _numberOfGiftsSentLabel.text = statisticsObject.numberOfGifts;
    _numberOfRequestsLabel.text = statisticsObject.numberOfRequests;
    _numberOfFriendsLabel.text = statisticsObject.numberOfFriends;
    _numberOfCreditsLabel.text = _numberOfCreditsTopContentLabel.text = statisticsObject.numberOfCredits;
    _numberOfStickersLabel.text = statisticsObject.numberOfStickers;
}

- (void)setFontCalibri{
    
    [_creditsTopContentLabel setFont:CalibriFont(18)];
    
    [_numberOfGiftsSentLabel setFont:CalibriFont(21)];
    [_numberOfRequestsLabel setFont:CalibriFont(21)];
    [_numberOfFriendsLabel setFont:CalibriFont(18)];
    [_numberOfCreditsLabel setFont:CalibriFont(21)];
    [_numberOfStickersLabel setFont:CalibriFont(28)];
    
    [_userNameLabel setFont:CalibriFont(28)];
    [_inputStatusTextField setFont:CalibriFont(21)];
    
    [_giftsSentButton.titleLabel setFont:CalibriFont(18)];
    [_requestsButton.titleLabel setFont:CalibriFont(18)];
    [_friendsButton.titleLabel setFont:CalibriFont(10)];
    [_creditsButton.titleLabel setFont:CalibriFont(18)];
    [_stickersButton.titleLabel setFont:CalibriFont(28)];
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
}

- (void)didUpdateUserStatusFail:(MeScreenModel *)meScreenModel withError:(NSError *)error
{
    //TODO: Waiting server
}

- (void)didGetUserStatusSuccess:(MeScreenModel *)meScreenModel withStatus:(NSString *)statusString
{
    //TODO: Waiting server
    _inputStatusTextField.text = statusString;
}

- (void)didGetUserStatusFail:(MeScreenModel *)meScreenModel withError:(NSError *)error
{
    //TODO: Waiting server
}

- (void)didGetUserStatisticsSuccess:(MeScreenModel *)meScreenModel withDict:(StatisticsObject *)statisticsObject
{
    //TODO: Waiting server
    [self updateStatistics:statisticsObject];
}

- (void)didGetUserStatisticsFail:(MeScreenModel *)meScreenModel withError:(NSError *)error
{
    //TODO: Waiting server
}

@end
