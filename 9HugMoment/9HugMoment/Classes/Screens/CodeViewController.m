//
//  CodeViewController.m
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "CodeViewController.h"
#import "CaptureVideoViewController.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "MomentDetailViewController.h"
#import <ZXingObjC/ZXingObjC.h>
#import "MessageObject.h"
#import "QuartzCore/CALayer.h"
#import "DownloadVideoView.h"
#import "VolumeView.h"
#import <FacebookSDK/FacebookSDK.h>
#import <QuartzCore/QuartzCore.h>
@interface CodeViewController ()<ZXCaptureDelegate,DownloadVideoDelegate,UITextFieldDelegate,AVCaptureMetadataOutputObjectsDelegate>{
    int _yesSwipe;
}


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
@property (nonatomic, strong) DownloadVideoView *downloadView;

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
    _topHeightConstraint.constant = 60.0f;
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
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    _scaned = NO;
    [self createCapture];
    if ([UserData currentAccount].strFacebookId) {
        _lblName.text = [UserData currentAccount].strFullName;
        [_imvAvatar sd_setImageWithURL: [NSURL URLWithString:[NSString stringWithFormat: @"https://graph.facebook.com/"@"%@/picture?type=large", [UserData currentAccount].strFacebookId]] placeholderImage:nil ];
    }
    
    //#warning TEST DATA
     _enterCodeTextField.text = @"jcxzg";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
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
        _capture.layer.frame = self.view.bounds;
        [self.view.layer insertSublayer:_capture.layer atIndex:0];
        
        _capture.delegate = self;
    }
    [_capture start];
}

- (void)removeCapture {
    [_capture order_skip];
    [_capture hard_stop];
    _capture = nil;
}

//- (void) setupScanner{
//    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//    
//    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
//    
//    AVCaptureSession* session = [[AVCaptureSession alloc] init];
//    
//    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
//    [session addOutput:output];
//    [session addInput:input];
//    
//    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
//    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
//    
//    AVCaptureVideoPreviewLayer *preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
//    preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
//    preview.frame = self.view.bounds;
//    
//    AVCaptureConnection *con = preview.connection;
//    
//    con.videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
//    
//    [self.view.layer insertSublayer:preview atIndex:0];
//}
//
//- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects
//       fromConnection:(AVCaptureConnection *)connection{
//    for(AVMetadataObject *current in metadataObjects) {
//        if([current isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
//            NSString *scannedValue = [((AVMetadataMachineReadableCodeObject *) current) stringValue];
//            NSLog(@"%@",scannedValue);
//        }
//    }
//}

#pragma mark - ZXCaptureDelegate Methods

- (void)captureResult:(ZXCapture *)capture result:(ZXResult *)result {
    NSLog(@"%s %@",__PRETTY_FUNCTION__,result);
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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BaseServices getMessageByKey:key sussess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = (NSDictionary *)responseObject;
        
        // NSLog(@"%@",_message.code);
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        _message = [MessageObject createMessageByDictionnary:dict];
        
        if (!_message) {
            [_downloadView showWithAnimation];
            [_downloadView downloadVideoByMessage:_message];
            return;
        }
        
        if (!_message.downloaded && _message.localVideoPath) {
            _downloadView.alpha = 1;
            [_downloadView showWithAnimation];
            [_downloadView downloadVideoByMessage:_message];
        }else {
            //TODO: Go to detail message
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:TRENDING_STORY_BOARD bundle: nil];
            MomentDetailViewController *lvc = [storyboard instantiateViewControllerWithIdentifier:MOMENTS_DETAILS_TRENDING_INDENTIFIER];
            lvc.capturePath = [NSURL fileURLWithPath:_message.localVideoPath];
            lvc.messageObject = _message;
            lvc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:lvc animated:YES];
        }
        
    } failure:^(NSString *bodyString, NSError *error) {
        
        if ([bodyString isEqualToString:@"\"message has not been sent\""]) {
            _mKey = key;
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:TRENDING_STORY_BOARD bundle: nil];
            CaptureVideoViewController *lvc = [storyboard instantiateViewControllerWithIdentifier:CAPTURE_VIDEO_TRENDING_INDENTIFIER];
            lvc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:lvc animated:YES];
            
            
        } else if ([bodyString isEqualToString:@"\"message not found\""]) {
            [UIAlertView showMessage:bodyString];
            _scaned = NO;
        } else if (bodyString) {
            [UIAlertView showMessage:bodyString];
            _scaned = NO;
        } else {
            [UIAlertView showMessage:@"Please scan again"];
            _scaned = NO;
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)downloadVideoSuccess:(MessageObject*)message  {
    [_downloadView hideWithAnimation];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:TRENDING_STORY_BOARD bundle: nil];
    MomentDetailViewController *lvc = [storyboard instantiateViewControllerWithIdentifier:MOMENTS_DETAILS_TRENDING_INDENTIFIER];
    lvc.capturePath = [NSURL fileURLWithPath:_message.localVideoPath];
    lvc.messageObject = _message;
    lvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:lvc animated:YES];

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
