//
//  CodeViewController.m
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "CodeViewController.h"
#import "CaptureVideoViewController.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
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
    _scaned = NO;
    //    _capture = nil;
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
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    _scaned = NO;
    [self createCapture];
    if ([UserData currentAccount].strFacebookId) {
        _lblName.text = [UserData currentAccount].strFullName;
        [_imvAvatar sd_setImageWithURL: [NSURL URLWithString:[NSString stringWithFormat: @"https://graph.facebook.com/"@"%@/picture?type=large", [UserData currentAccount].strFacebookId]] placeholderImage:nil ];
    }
    
    //#warning TEST DATA
    // _enterCodeTextField.text = @"2xlr0";
}

- (void)viewWillDisappear:(BOOL)animated {
    [self removeCapture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI {
    _enterCodeView.layer.cornerRadius = 6.0f;
    _downloadView = [DownloadVideoView fromNib];
    _downloadView.alpha = 0.0;
    _downloadView.delegate = self;
    [self.view addSubview:_downloadView];
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
        _capture.focusMode = AVCaptureFocusModeContinuousAutoFocus;
        //        _capture.rotation = 90.0f;
        
        _capture.layer.frame = self.view.bounds;
        [self.view.layer insertSublayer:_capture.layer atIndex:0];
        
        _capture.delegate = self;
    }
}

- (void)removeCapture {
    _capture.delegate = nil;
    [_capture stop];
    NSLog(@"stopped");
    _capture = nil;
}

#pragma mark - ZXCaptureDelegate Methods

- (void)captureResult:(ZXCapture *)capture result:(ZXResult *)result {
    
    if (!result)
        return;
    if (_downloadView.alpha == 1.0) {
        return;
    }
    
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
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [BaseServices getMessageByKey:key
//                          sussess:^(AFHTTPRequestOperation *operation, id responseObject) {
//                              
//                              NSDictionary *dict = (NSDictionary *)responseObject;
//                              
//                              // NSLog(@"%@",_message.code);
//                              
//                              [MBProgressHUD hideHUDForView:self.view animated:YES];
//                              
//                              if (![HMessage downloadedByDictionary:dict]) {
//                                  _message = [HMessage createByDictionary:dict];
//                                  [[NSManagedObjectContext MR_defaultContext]
//                                   MR_saveOnlySelfWithCompletion:nil];
//                                  [_downloadView showWithAnimation];
//                                  [_downloadView downloadVideoByMessage:_message];
//                                  return;
//                              }
//                              
//                              _message = [HMessage createByDictionary:dict];
//                              [[NSManagedObjectContext MR_defaultContext]
//                               MR_saveOnlySelfWithCompletion:nil];
//                              
//                              MSGDetailViewController *msgDetailCtr =
//                              [[MSGDetailViewController alloc] initWithNibName:nil bundle:nil];
//                              
//                              HMessage *message = _message;
//                              
//                              msgDetailCtr.mKey = key;
//                              msgDetailCtr.capturePath =
//                              [NSURL fileURLWithPath:message.localVideoPath];
//                              
//                              [msgDetailCtr getMessageByKey:message.key];
//                              
//                              [self.navigationController pushViewController:msgDetailCtr
//                                                                   animated:YES];
//                          }
//                          failure:^(NSString *bodyString, NSError *error) {
//                              
//                              if ([bodyString isEqualToString:@"\"message has not been sent\""]) {
//                                  _mKey = key;
//                                  
//                                  CaptureVideoViewController *captureVideoVC =
//                                  [[CaptureVideoViewController alloc] initWithNibName:nil
//                                                                               bundle:nil];
//                                  
//                                  [self.navigationController pushViewController:captureVideoVC
//                                                                       animated:YES];
//                                  captureVideoVC.mKey = _mKey;
//                                  
//                              } else if ([bodyString isEqualToString:@"\"message not found\""]) {
//                                  [UIAlertView showMessage:bodyString];
//                                  _scaned = NO;
//                              } else if (bodyString) {
//                                  [UIAlertView showMessage:bodyString];
//                                  _scaned = NO;
//                              } else {
//                                  [UIAlertView showMessage:@"Please scan again"];
//                                  _scaned = NO;
//                              }
//                              
//                              [MBProgressHUD hideHUDForView:self.view animated:YES];
//                          }];
}

- (void)downloadVideoSuccess:(MessageObject*)message  {
    [_downloadView hideWithAnimation];

}

- (void)downloadVideoFailure:(MessageObject*)message  {
    [_downloadView hideWithAnimation];
    [UIAlertView showTitle:@"Error" message:@"Cann't download this video"];
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

@end
