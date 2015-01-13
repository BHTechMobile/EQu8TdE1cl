//
//  CodeViewController.m
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "CodeViewController.h"
#import "CaptureVideoViewController.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import <ZXingObjC/ZXingObjC.h>
#import "MessageObject.h"
#import "QuartzCore/CALayer.h"
#import "DownloadVideoView.h"
#import "VolumeView.h"
#import <FacebookSDK/FacebookSDK.h>
#import <QuartzCore/QuartzCore.h>
#import "FBConnectViewController.h"
#import "MessageDetailsViewController.h"

@interface CodeViewController ()<ZXCaptureDelegate,UITextFieldDelegate,AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate,FBConnectViewControllerDelegate>{
    int _yesSwipe;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeightConstraint;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet UIView *centerView;

@property (strong, nonatomic) IBOutlet UIButton *checkCodeButton;
@property (strong, nonatomic) IBOutlet UIView *scanRectView;
@property (strong, nonatomic) IBOutlet UIView *enterCodeView;
@property (strong, nonatomic) IBOutlet UITextField *enterCodeTextField;
@property (strong, nonatomic) IBOutlet UILabel *lblSwipe;
@property (strong, nonatomic) IBOutlet UIImageView *imvAvatar;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UIImageView *scannerSquareImv;

@property (nonatomic, strong) ZXCapture *capture;
@property (nonatomic, strong) MessageObject *message;
@property (nonatomic, strong) NSString *mKey;
@property (nonatomic, assign) BOOL scaned;
@property (nonatomic, strong) AVCaptureSession *session;

- (IBAction)checkCodeButtonTapped:(UIButton *)sender;
- (IBAction)okButtonTapped:(id)sender;
@end

@implementation CodeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _bottomHeightConstraint.constant = _topHeightConstraint.constant = (self.view.bounds.size.height - self.view.bounds.size.width)/2 - 40;
    _scaned = NO;
    [self createCapture];
    [self createUI];
    [_imvAvatar.layer setMasksToBounds:YES];
    [_imvAvatar.layer setCornerRadius:17];
    
    self.navigationItem.title = @"QRCode Scanner";
    UITapGestureRecognizer *tapGestureRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleTapFrom:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    UISwipeGestureRecognizer *swipeleft =
    [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(swipeleft:)];
    swipeleft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeleft];
    
    UISwipeGestureRecognizer *swiperight =
    [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(swipeleft:)];
    swiperight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swiperight];
    
}

- (void)showLoginFB {
    FBConnectViewController* fbConnectViewController = (FBConnectViewController *)[[UIStoryboard storyboardWithName:TRENDING_STORY_BOARD bundle: nil] instantiateViewControllerWithIdentifier:PRESENT_TRENDING];
    fbConnectViewController.delegate = self;
    fbConnectViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:fbConnectViewController animated:YES completion:nil];
}

- (void)handleTapFrom:(UITapGestureRecognizer *)recognizer {
    if ([_enterCodeTextField isFirstResponder]) {
        [_enterCodeTextField resignFirstResponder];
    }
}

- (void)swipeleft:(UISwipeGestureRecognizer *)recognizer {
    _yesSwipe = recognizer.direction;
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft || recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        [self transitionViewCode];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!APP_DELEGATE.session.isOpen) {
        APP_DELEGATE.session = [[FBSession alloc] initWithPermissions:@[@"publish_actions",@"public_profile", @"user_friends",@"read_friendlists"]];
        if (APP_DELEGATE.session.state == FBSessionStateCreatedTokenLoaded) {
            [APP_DELEGATE.session openWithCompletionHandler:^(FBSession *session,
                                                              FBSessionState status,
                                                              NSError *error) {
                [FBSession setActiveSession:session];
                APP_DELEGATE.session = session;
                if ([UserData currentAccount].strFacebookId) {
                    _lblName.text = [UserData currentAccount].strFullName;
                    [_imvAvatar sd_setImageWithURL: [NSURL URLWithString:[NSString stringWithFormat: @"https://graph.facebook.com/"@"%@/picture?type=large", [UserData currentAccount].strFacebookId]] placeholderImage:nil ];
                }
            }];
        }else{
            [self showLoginFB];
        }
    }
    else{
        if ([UserData currentAccount].strFacebookId) {
            _lblName.text = [UserData currentAccount].strFullName;
            [_imvAvatar sd_setImageWithURL: [NSURL URLWithString:[NSString stringWithFormat: @"https://graph.facebook.com/"@"%@/picture?type=large", [UserData currentAccount].strFacebookId]] placeholderImage:nil ];
        }
    }
    [self.navigationController setNavigationBarHidden:YES animated:NO];

    //#warning TEST DATA
     _enterCodeTextField.text = @"jcxzg";
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _scaned = NO;
    [self createCapture];

}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI {
    _enterCodeView.layer.cornerRadius = 6.0f;
    if (IS_IPHONE_4) {
        _topView.frame = CGRectMake(0, 44, 320, 44);
        _bottomView.frame =
        CGRectMake(0, self.view.frame.size.height - 88, 320, 39);
    }
    if (_capture.captureDevice.isFlashAvailable) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self
                   action:@selector(flashButtonTapped:)
         forControlEvents:UIControlEventTouchUpInside]; // adding action
        [button setBackgroundImage:[UIImage imageNamed:@"btn_flash"]
                          forState:UIControlStateNormal];
        button.frame = CGRectMake(2, 2, 20, 32);
        UIBarButtonItem *barButton =
        [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = barButton;
    }
}

- (IBAction)flashButtonTapped:(id)sender {
    if (_capture.hasTorch) {
        if (_capture.torch == YES) {
            _capture.torch = NO;
        } else {
            _capture.torch = YES;
        }
    }
}

- (void)createCapture {
    if (!_capture) {
        _capture = [[ZXCapture alloc] init];
        _capture.camera = _capture.back;
//        _capture.focusMode = AVCaptureFocusModeContinuousAutoFocus;
        _capture.layer.frame = self.view.bounds;
        [self.view.layer insertSublayer:_capture.layer atIndex:0];
        
        _capture.delegate = self;
    }
//    [_capture start];
}

- (void)removeCapture {
    _capture.camera = _capture.front;
    _capture.delegate = nil;
    [_capture order_skip];
    [_capture hard_stop];
    _capture = nil;
}

#pragma mark - ZXCaptureDelegate Methods

- (void)captureResult:(ZXCapture *)capture result:(ZXResult *)result {
    NSLog(@"%s %@",__PRETTY_FUNCTION__,result);
    if (!result)
        return;
    
    if ([self validateQRCode:result.text] && !_scaned) {
        _scaned = YES;
        NSURL *url = [NSURL URLWithString:result.text];
        NSString *key = [url lastPathComponent];
        _mKey = key;
        [self performSelectorOnMainThread:@selector(getMessageByKey:)
                               withObject:key
                            waitUntilDone:YES];
    }
}

- (void)getMessageByKey:(NSString *)key {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BaseServices getMessageByKey:key sussess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = (NSDictionary *)responseObject;
        
        // NSLog(@"%@",_message.code);
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        _message = [MessageObject createMessageByDictionnary:dict];
        
        if (!_message) {
            return;
        }
        //TODO: Go to detail message
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:TRENDING_STORY_BOARD bundle: nil];
        MessageDetailsViewController *messageDetailsViewController = [storyboard instantiateViewControllerWithIdentifier:BUNDLE_IDENTIFIER_MESSAGE_DETAILS_VIEW_CONTTROLLER_TRENDING];
        messageDetailsViewController.messageObject = _message;
        messageDetailsViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:messageDetailsViewController animated:YES];
    } failure:^(NSString *bodyString, NSError *error) {
        if ([bodyString isEqualToString:@"\"message has not been sent\""]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                _mKey = key;
                [self removeCapture];
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:TRENDING_STORY_BOARD bundle: nil];
                CaptureVideoViewController *lvc = [storyboard instantiateViewControllerWithIdentifier:CAPTURE_VIDEO_TRENDING_INDENTIFIER];
                lvc.mKey = key;
                lvc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:lvc animated:YES];
            });
        } else if ([bodyString isEqualToString:@"\"message not found\""]) {
            [[[UIAlertView alloc] initWithTitle:@"" message:bodyString delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];

        } else if (bodyString) {
            [[[UIAlertView alloc] initWithTitle:@"" message:bodyString delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"" message:@"Please scan again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (BOOL)validateQRCode:(NSString *)code {
    NSURL *url = [NSURL URLWithString:code];
    NSString *host = [url host];
    if (!host) {
        return NO;
    }
    if ([host isEqualToString:NICEHUG_DOMAIN]) {
        return YES;
    }
    return NO;
}

- (IBAction)checkCodeButtonTapped:(UIButton *)sender {
    [self transitionViewCode];
}

- (IBAction)okButtonTapped:(id)sender {
    if ([_enterCodeTextField isFirstResponder]) {
        [_enterCodeTextField resignFirstResponder];
    }
    if (_enterCodeTextField.text == nil ||
        [_enterCodeTextField.text isEqualToString:@""]) {
        return;
    }
    [self getMessageByKey:_enterCodeTextField.text];
}

- (void)transitionToEnterCodeView {
    _scannerSquareImv.hidden = !_scannerSquareImv.hidden;
    _checkCodeButton.hidden = !_checkCodeButton.hidden;
    _lblSwipe.text =
    (!_checkCodeButton.hidden) ? @"swipe to enter code manually" : @"swipe to scan QRcode";
    _checkCodeButton.enabled = NO;
    [UIView transitionWithView:_scanRectView
                      duration:0.5
                       options:_yesSwipe==2 ? UIViewAnimationOptionTransitionFlipFromRight
                              : UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{ _enterCodeView.hidden = !_checkCodeButton.hidden; }
                    completion:^(BOOL finished) {
                        _checkCodeButton.selected = !_checkCodeButton.selected;
                        _checkCodeButton.enabled = YES;
                    }];
}

- (IBAction)closeButtonClicked:(id)sender {
    [self transitionViewCode];
}

- (void)transitionViewCode{
    if (_yesSwipe==1) {
        _yesSwipe=2;
    }else
        _yesSwipe=1;
    if (_enterCodeView.hidden) {
        [_enterCodeTextField becomeFirstResponder];
    }else
        [_enterCodeTextField resignFirstResponder];
    [self transitionToEnterCodeView];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self okButtonTapped:nil];
    return YES;
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    _scaned = NO;
}

#pragma mark - FBConnectVC Delegate

-(void)fbConnectViewController:(FBConnectViewController*)vc didConnectFacebookSuccess:(id)response{
    if ([UserData currentAccount].strFacebookId) {
        _lblName.text = [UserData currentAccount].strFullName;
        [_imvAvatar sd_setImageWithURL: [NSURL URLWithString:[NSString stringWithFormat: @"https://graph.facebook.com/"@"%@/picture?type=large", [UserData currentAccount].strFacebookId]] placeholderImage:nil ];
    }
}


@end
