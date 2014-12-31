//
//  CaptureVideoViewController.m
//  9HugMoment
//
//  Created by Tommy on 11/24/14.
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import "CaptureVideoViewController.h"
#import "MixVideoViewController.h"

@interface CaptureVideoViewController ()

@property(nonatomic,assign) NSInteger count;
@property(nonatomic,assign) NSInteger duration;
@property(nonatomic,strong) NSTimer* timer;
@property(nonatomic,strong) NSTimer* timerCursor;
@property(nonatomic,strong) NSString* capturePath;

@property (weak, nonatomic) IBOutlet UIView *navigationCustomView;
@property (weak, nonatomic) IBOutlet UIButton *touchMixVideoButton;
@property (weak, nonatomic) IBOutlet UIScrollView *selectFrameScrollView;
@property (weak, nonatomic) IBOutlet UIView *previewView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *removeCapturedButton;
@property (weak, nonatomic) IBOutlet UIButton *doneCaptureButton;
@property (weak, nonatomic) IBOutlet UIImageView *imvFrame;
@property (weak, nonatomic) IBOutlet UIImageView *imvCapture;
@property (weak, nonatomic) IBOutlet UIView *recordPercent;
@property (weak, nonatomic) IBOutlet UIImageView *imvAnimationFrame;
@property (weak, nonatomic) IBOutlet UILabel *lblTutorial;
@property (weak, nonatomic) IBOutlet UIButton *touchDoneCapture;

- (void)showAlertResumVideo;

@end

@implementation CaptureVideoViewController{
    MixVideoViewController *mixVideoViewController;
    NSArray *_qrcode;
}

#pragma mark - Head Controls

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationView];
    [self createUI];
    [self.navigationCustomView addSubview:navigationView];
    [self _resetCapture];

    _previewView.backgroundColor = [UIColor blackColor];
    CGRect previewFrame = CGRectMake(0, 60.0f, CGRectGetWidth(self.view.frame), CGRectGetWidth(self.view.frame));
    _previewView.frame = previewFrame;
    _previewLayer = [[PBJVision sharedInstance] previewLayer];
    _previewLayer.frame = _previewView.bounds;
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [_previewView.layer addSublayer:_previewLayer];
    
    UISwipeGestureRecognizer * swipeLeftGest = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipee:)];
    swipeLeftGest.direction = UISwipeGestureRecognizerDirectionLeft;
    UISwipeGestureRecognizer * swipeRightGest = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipee:)];
    swipeRightGest.direction = UISwipeGestureRecognizerDirectionRight;
    _imvFrame.gestureRecognizers = @[swipeLeftGest,swipeRightGest];
    _imvFrame.userInteractionEnabled = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];

    unlink([_capturePath UTF8String]);
    [self _resetCapture];

    [[PBJVision sharedInstance] startPreview];

    _imgIndex = 0;
    _imvFrame.image = nil;
    _imvCapture.userInteractionEnabled = YES;
    navigationView.titleNvgLabel.text = @"New Moment";
    self.touchMixVideoButton.enabled = NO;
    _count = 12;
    _timeLabel.text = [NSString stringWithFormat:@"00:%ld",(long)_count];
    [self createProcessView];
    [self touchResetCapturedButton:nil];
    [self hightButtonCaptureConstraint];
    [self.swipeFrameLabel bringSubviewToFront:self.view];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)hightButtonCaptureConstraint{
    if (IS_IPHONE_4) {
        _hightViewOffsetConstraint.constant = 60;
    }else if (IS_IPHONE_5){
        _hightViewOffsetConstraint.constant = 80;
    }else if (IS_IPHONE_6){
        _hightViewOffsetConstraint.constant = 100;
    }else if (IS_IPHONE_6_PLUS){
        _hightViewOffsetConstraint.constant = 100;
    }
}

#pragma mark - Navigation Custom View

- (void)initNavigationView {
    navigationView = [[NavigationView alloc]initWithFrame:CGRectZero];
    navigationView.delegate = self;
    CGRect navigationViewFrame = CGRectMake(0, 0, self.navigationCustomView.frame.size.width, self.navigationCustomView.frame.size.height);
    navigationView.frame = navigationViewFrame;
}

- (void)backNvgAction {
//    [PBJVision sharedInstance].cameraDevice = PBJCameraDeviceFront;
//
    [PBJVision sharedInstance].delegate = nil;
    [[PBJVision sharedInstance] endVideoCapture];
    [[PBJVision sharedInstance] stopPreview];

    [self.navigationController popViewControllerAnimated:YES];

}

- (void)facebookNvgAction {
    
}

- (void)twitterNvgAction {
    
}

- (void)ggPlusNvgAction {
    
}

#pragma mark - Control

-(void)changeCurrentFrameToLeft:(BOOL)yesOrNo{
    const NSArray* frameNames =@[@"",
                                 @"1_pink_heart",
                                 @"2_blue amazing curve",
                                 @"4_halloween",
                                 @"3_butter_fly",
                                 @"5_floral_on_the_right",
                                 @"6_golden_flora",
                                 @"7_daisies_yellow"];
    NSLog(@"%s,%d,%@",__PRETTY_FUNCTION__,_imgIndex,[frameNames objectAtIndex:_imgIndex]);
    int direction = (yesOrNo)?1.0:-1.0;
    _imvAnimationFrame.hidden = NO;
    [_imvAnimationFrame setFrame:CGRectMake(direction*CGRectGetWidth(self.view.frame), 44, CGRectGetWidth(self.view.frame), CGRectGetWidth(self.view.frame))];
    _imvAnimationFrame.image = [UIImage imageNamed:[frameNames objectAtIndex:_imgIndex]];
    [UIView animateWithDuration:0.33f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         [_imvFrame setFrame:CGRectMake(direction*-CGRectGetWidth(self.view.frame), 44, CGRectGetWidth(self.view.frame), CGRectGetWidth(self.view.frame))];
                         [_imvAnimationFrame setFrame:CGRectMake(0.0, 44, CGRectGetWidth(self.view.frame), CGRectGetWidth(self.view.frame))];
                         
                     }
                     completion:^(BOOL finished){
                         dispatch_async(dispatch_get_main_queue(), ^{
                             _imvFrame.image = _imvAnimationFrame.image;
                             [_imvFrame setFrame:CGRectMake(0, 44, CGRectGetWidth(self.view.frame), CGRectGetWidth(self.view.frame))];
                             _imvAnimationFrame.hidden = YES;
                         });
                     }];
    
}

-(void)createUI
{
    self.view.multipleTouchEnabled = NO;
    _capturePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"capture.mp4"];
    [self.view bringSubviewToFront:_timeLabel];
    //bgr_frame_select_no_frame
    const NSArray* frameNames =@[@"bgr_frame_select_no_frame",
                                 @"1_pink_heart_thumb",
                                 @"2_blue amazing curve_thumb",
                                 @"4_halloween_thumb",
                                 @"3_butter_fly_thumb",
                                 @"5_floral_on_the_right_thumb",
                                 @"6_golden_flora_thumb",
                                 @"7_daisies_yellow_thumb"];
    
    changeFrameButtons = @[
                           [Utilities squareButtonWithSize:50 background:[UIImage imageNamed:[frameNames objectAtIndex:0]] text:nil target:self selector:@selector(changeFrame:) tag:0 isTypeFrame:YES],
                           [Utilities squareButtonWithSize:48 background:[UIImage imageNamed:[frameNames objectAtIndex:1]] text:nil target:self selector:@selector(changeFrame:) tag:1 isTypeFrame:YES],
                           [Utilities squareButtonWithSize:48 background:[UIImage imageNamed:[frameNames objectAtIndex:2]] text:nil target:self selector:@selector(changeFrame:) tag:2 isTypeFrame:YES],
                           [Utilities squareButtonWithSize:48 background:[UIImage imageNamed:[frameNames objectAtIndex:3]] text:nil target:self selector:@selector(changeFrame:) tag:3 isTypeFrame:YES],
                           [Utilities squareButtonWithSize:48 background:[UIImage imageNamed:[frameNames objectAtIndex:4]] text:nil target:self selector:@selector(changeFrame:) tag:4 isTypeFrame:YES],
                           [Utilities squareButtonWithSize:48 background:[UIImage imageNamed:[frameNames objectAtIndex:5]] text:nil target:self selector:@selector(changeFrame:) tag:5 isTypeFrame:YES],
                           [Utilities squareButtonWithSize:48 background:[UIImage imageNamed:[frameNames objectAtIndex:6]] text:nil target:self selector:@selector(changeFrame:) tag:6 isTypeFrame:YES],
                           [Utilities squareButtonWithSize:48 background:[UIImage imageNamed:[frameNames objectAtIndex:7]] text:nil target:self selector:@selector(changeFrame:) tag:7 isTypeFrame:YES]
                           ];
    
    _selectFrameScrollView.contentSize = CGSizeMake(changeFrameButtons.count*66, _selectFrameScrollView.size.height);
    _selectFrameScrollView.scrollEnabled = YES;
    for (int i = 0;i<changeFrameButtons.count;i++) {
        
        UIButton * button = changeFrameButtons[i];
        if (i ==0) {
            button.layer.borderWidth = 3;
            button.layer.borderColor = [UIColor colorWithRed:69/255.0 green:187/255.0 blue:255/255.0 alpha:1.0].CGColor;
            
        }
        button.center = CGPointMake(4+button.size.width/2 + i*(button.size.width+8), _selectFrameScrollView.size.height/2);
        [_selectFrameScrollView addSubview:button];
    }
}

- (void)createProcessView{
    if (_viewCurrentProgress) {
        [_viewCurrentProgress removeFromSuperview];
        [_cursorImageView removeFromSuperview];
    }
    _cursorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
    [_cursorImageView setBackgroundColor:[UIColor whiteColor]];
    [_recordPercent setBackgroundColor:BG_COLOR_PROCESS];
    _viewCurrentProgress = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, CGRectGetHeight(_recordPercent.frame))];
    [_viewCurrentProgress setBackgroundColor:COLOR_PROCESS];
    [_recordPercent addSubview:_viewCurrentProgress];
    [_recordPercent insertSubview:_cursorImageView aboveSubview:_viewCurrentProgress];
    UIView *firstSpaceView = [Utilities viewSpace:PointX];
    [firstSpaceView setBackgroundColor:[UIColor lightGrayColor]];
    [firstSpaceView setTag: 99];
    [_recordPercent insertSubview:firstSpaceView belowSubview:_viewCurrentProgress];
    [self startCursor];
    _arrayViewSpeacators = [NSMutableArray new];
}

-(IBAction)changeFrame:(id)sender{
    for (UIView * view in _selectFrameScrollView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            ((UIButton*)view).layer.borderWidth = 0;
        }
    }
    const NSArray* frameNames =@[@"",
                                 @"1_pink_heart",
                                 @"2_blue amazing curve",
                                 @"4_halloween",
                                 @"3_butter_fly",
                                 @"5_floral_on_the_right",
                                 @"6_golden_flora",
                                 @"7_daisies_yellow"];
    
    _imvFrame.image = [UIImage imageNamed:[frameNames objectAtIndex:[sender tag]]];
    UIButton * button = sender;
    button.layer.borderWidth = 3;
    button.layer.borderColor = [UIColor colorWithRed:69/255.0 green:187/255.0 blue:255/255.0 alpha:1.0].CGColor;
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

-(void)startOrPauseOrResumeVideoCapture:(BOOL)yesOrNo
{
    
    if (yesOrNo && ![PBJVision sharedInstance].isRecording) {
        [[PBJVision sharedInstance] startVideoCapture];
        [self startCursor];
        [self addSpeacetors];
        [self startTimer];
        
    }
    if (yesOrNo && [PBJVision sharedInstance].isPaused){
        [[PBJVision sharedInstance] resumeVideoCapture];
        [self startTimer];
        [self addSpeacetors];
    }
    if (!yesOrNo && ![PBJVision sharedInstance].isPaused){
        if (_timer) {
            [_timer invalidate];
            _timer = nil;
        }
        [self startCursor];
        [[PBJVision sharedInstance] pauseVideoCapture];
    }
    NSLog(@"total number speace %@",_arrayViewSpeacators);
}

- (void)addSpeacetors{
    if(CGRectGetMinX(_cursorImageView.frame)>0)
        [_recordPercent insertSubview:[Utilities viewSpace:CGRectGetMinX(_cursorImageView.frame)] aboveSubview:_viewCurrentProgress];
    float durations = CGRectGetMinX(_cursorImageView.frame)*_count/CGRectGetWidth(self.view.frame);
    NSMutableDictionary *_dicViewSpeacator = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithFloat:durations] forKey:KEY_DISTANCE];
    [_arrayViewSpeacators addObject:_dicViewSpeacator];
    
}

-(void)startCursor
{
    if (_timerCursor) {
        [_timerCursor invalidate];
        _timerCursor = nil;
    }
    _timerCursor = [NSTimer scheduledTimerWithTimeInterval:1.2 target:self selector:@selector(updateCursor) userInfo:nil repeats:YES];
}

- (void)updateCursor{
    if (_cursorImageView.hidden) {
        [_cursorImageView setHidden:NO];
    }else
        [_cursorImageView setHidden:YES];
}

-(void)startTimer
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(tick) userInfo:nil repeats:YES];
}

-(void)tick{
    [_timerCursor invalidate];
    [_cursorImageView setHidden:NO];
    _startCount ++;
    CGRect frameCursorImageView = [_cursorImageView frame];
    frameCursorImageView.origin.x =1.0*_startCount*CGRectGetWidth(self.view.frame)/(_count*100) ;
    if (frameCursorImageView.origin.x>CGRectGetWidth(self.view.frame)) {
        frameCursorImageView.origin.x = CGRectGetWidth(self.view.frame);
    }
    if (frameCursorImageView.origin.x>PointX) {
        self.touchMixVideoButton.enabled = YES;
    }
    [_cursorImageView setFrame:frameCursorImageView];
    [_viewCurrentProgress setFrame:CGRectMake(0, 0, frameCursorImageView.origin.x, CGRectGetHeight(_recordPercent.frame))];
    float f = _count - floorf( _startCount*0.01);
    _timeLabel.text = [NSString stringWithFormat:@"00:%@%.0f",f>=10?@"":@"0",f];
    if (_startCount>=_count*100) {
        [_timer invalidate];
        [self _endCapture];
        _imvCapture.userInteractionEnabled = NO;
        _imvCapture.highlighted = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        });
    }
}

- (void)showAlertResumVideo{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Resum Video"
                                                    message:@"Do you wany to resume previous video?"
                                                   delegate:self
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Yes",nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        [self _resetCapture];
        [self touchResetCapturedButton:nil];
    }else{
        [self _resumeCapture];
    }
}

#pragma mark - Touch Move

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch *aTouch = [touches anyObject];
    CGPoint currentTouchPosition = [aTouch locationInView:_imvCapture];
    if (currentTouchPosition.x >= 0
        && currentTouchPosition.x <= _imvCapture.frame.size.width
        && currentTouchPosition.y >= 0
        && currentTouchPosition.y <= _imvCapture.frame.size.height) {
        _imvCapture.highlighted = YES;
        [self startOrPauseOrResumeVideoCapture:YES];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *aTouch = [touches anyObject];
    CGPoint currentTouchPosition = [aTouch locationInView:_imvCapture];
    if (currentTouchPosition.x >= 0
        && currentTouchPosition.x <= _imvCapture.frame.size.width
        && currentTouchPosition.y >= 0
        && currentTouchPosition.y <= _imvCapture.frame.size.height) {
        _imvCapture.highlighted = NO;
        
        if (_timer) {
            [_timer invalidate];
            _timer = nil;
        }
        [self startOrPauseOrResumeVideoCapture:NO];
        
        
        
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *aTouch = [touches anyObject];
    CGPoint currentTouchPosition = [aTouch locationInView:_imvCapture];
    if (currentTouchPosition.x >= 0
        && currentTouchPosition.x <= _imvCapture.frame.size.width
        && currentTouchPosition.y >= 0
        && currentTouchPosition.y <= _imvCapture.frame.size.height) {
        _imvCapture.highlighted = NO;
        
        if (_timer) {
            [_timer invalidate];
            _timer = nil;
        }
        [self startOrPauseOrResumeVideoCapture:NO];
        
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *aTouch = [touches anyObject];
    CGPoint currentTouchPosition = [aTouch locationInView:_imvCapture];
    
    if (currentTouchPosition.x < 0
        || currentTouchPosition.x > _imvCapture.frame.size.width
        || currentTouchPosition.y < 0
        || currentTouchPosition.y > _imvCapture.frame.size.height) {
        _imvCapture.highlighted = NO;
        
        if (_timer) {
            [_timer invalidate];
            _timer = nil;
        }
        [self startOrPauseOrResumeVideoCapture:NO];
        
    }
}

#pragma mark - Navigation

-(void)showMixScreen{
    [self performSegueWithIdentifier:@"pushMixVideoViewController" sender:nil];
    [[PBJVision sharedInstance] stopPreview];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"pushMixVideoViewController"]) {
        mixVideoViewController = [segue destinationViewController];
        mixVideoViewController.capturePath = [NSURL fileURLWithPath:_capturePath];
        mixVideoViewController.imgFrame = _imvFrame.image;
        mixVideoViewController.indexFrame = _imgIndex;
        mixVideoViewController.duration = (_startCount*1.0)/100.0f;
        mixVideoViewController.mKey = _mKey;
    }
}


#pragma mark - Swipt Button

-(void)swipee:(id)sender{
    UISwipeGestureRecognizer * swipeGest = sender;
    switch (swipeGest.direction) {
        case UISwipeGestureRecognizerDirectionLeft:
            _imgIndex = (_imgIndex+7)%8;
            [self changeCurrentFrameToLeft:YES];
            break;
        case UISwipeGestureRecognizerDirectionRight:
            _imgIndex = (_imgIndex+1)%8;
            [self changeCurrentFrameToLeft:NO];
        default:
            break;
    }
    [_imvFrame setTag:_imgIndex];
}

#pragma mark - private start/stop helper methods

- (void)_startCapture{
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    [[PBJVision sharedInstance] startVideoCapture];
}

- (void)_pauseCapture{
    [[PBJVision sharedInstance] pauseVideoCapture];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    
}

- (void)_resumeCapture{
    [[PBJVision sharedInstance] resumeVideoCapture];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
}

- (void)_endCapture{
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [[PBJVision sharedInstance] endVideoCapture];
}

- (void)_resetCapture{
    PBJVision *vision = [PBJVision sharedInstance];
    vision.delegate = self;

    self.touchMixVideoButton.enabled = NO;
    if (vision.isRecording) {
        [vision cancelVideoCapture];
    }
//    vision.cameraDevice = PBJCameraDeviceBack;
    vision.cameraMode = PBJCameraModeVideo;
    vision.outputFormat = PBJOutputFormatSquare;
    vision.videoRenderingEnabled = YES;
    vision.audioCaptureEnabled = YES;
}

#pragma mark - PBJVisionDelegate

// session

- (void)visionSessionWillStart:(PBJVision *)vision{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    
}

- (void)visionSessionDidStart:(PBJVision *)vision{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    
}

- (void)visionSessionDidStop:(PBJVision *)vision{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    
}

// preview

- (void)visionSessionDidStartPreview:(PBJVision *)vision{
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

- (void)visionSessionDidStopPreview:(PBJVision *)vision{
    NSLog(@"%s",__PRETTY_FUNCTION__);}

// device

- (void)visionCameraDeviceWillChange:(PBJVision *)vision{
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

- (void)visionCameraDeviceDidChange:(PBJVision *)vision{
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

// mode

- (void)visionCameraModeWillChange:(PBJVision *)vision{
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

- (void)visionCameraModeDidChange:(PBJVision *)vision{
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

// format

- (void)visionOutputFormatWillChange:(PBJVision *)vision{
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

- (void)visionOutputFormatDidChange:(PBJVision *)vision{
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

- (void)vision:(PBJVision *)vision didChangeCleanAperture:(CGRect)cleanAperture{
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

// focus / exposure

- (void)visionWillStartFocus:(PBJVision *)vision{
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

- (void)visionDidStopFocus:(PBJVision *)vision{
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

- (void)visionWillChangeExposure:(PBJVision *)vision{
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

- (void)visionDidChangeExposure:(PBJVision *)vision{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    
}

// flash

- (void)visionDidChangeFlashMode:(PBJVision *)vision{
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

// photo

- (void)visionWillCapturePhoto:(PBJVision *)vision{
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

- (void)visionDidCapturePhoto:(PBJVision *)vision{
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

- (void)vision:(PBJVision *)vision capturedPhoto:(NSDictionary *)photoDict error:(NSError *)error{
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

// video capture

- (void)visionDidStartVideoCapture:(PBJVision *)vision{
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

- (void)visionDidBecomeActive :(PBJVision *)vision{
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

- (void)visionDidPauseVideoCapture:(PBJVision *)vision{
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

- (void)visionDidResumeVideoCapture:(PBJVision *)vision{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    
}

- (void)vision:(PBJVision *)vision capturedVideo:(NSDictionary *)videoDict error:(NSError *)error{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    });
    NSLog(@"%s",__PRETTY_FUNCTION__);
    
    if (error && [error.domain isEqual:PBJVisionErrorDomain] && error.code == PBJVisionErrorCancelled) {
        NSLog(@"recording session cancelled");
        return;
    } else if (error) {
        NSLog(@"encounted an error in video capture (%@)", error);
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *_currentVideo = videoDict;
        NSString *videoPath = [_currentVideo  objectForKey:PBJVisionVideoPathKey];
        NSError *saveFileError = nil;
        unlink(_capturePath.UTF8String);
        [[NSFileManager defaultManager] moveItemAtPath:videoPath toPath:_capturePath error:&saveFileError];
        if (saveFileError) {
            NSLog(@"%@",saveFileError);
        }
        unlink(videoPath.UTF8String);
        [self showMixScreen];
    });
    
}

// progress

- (void)visionDidCaptureAudioSample:(PBJVision *)vision{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    NSLog(@"captured audio (%f) seconds", vision.capturedAudioSeconds);
}

- (void)visionDidCaptureVideoSample:(PBJVision *)vision{
    NSLog(@"%s captured video (%f) seconds",__PRETTY_FUNCTION__,vision.capturedVideoSeconds);
}

#pragma mark - Navigation Bar Button

- (IBAction)facebookButton:(id)sender {

}

- (IBAction)twitterButton:(id)sender {
    
}

- (IBAction)googleplusButton:(id)sender {
    
}

- (IBAction)backButtonInCapture:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Main Button

- (IBAction)touchDoneCaptureBtn:(id)sender {
    [_timer invalidate];
    //    [self showMixScreen];
    [self _endCapture];
    _imvCapture.userInteractionEnabled = NO;
    _imvCapture.highlighted = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    });
}

- (IBAction)touchResetCapturedButton:(id)sender{
//    [self _resetCapture];
    _timeLabel.text = [NSString stringWithFormat:@"00:%ld",(long)_count];
    CGRect frameCursorImageView = [_cursorImageView frame];
    frameCursorImageView.origin.x =0 ;
    [_cursorImageView setFrame:frameCursorImageView];
    [_viewCurrentProgress setFrame:CGRectMake(0, 0, 0, 8)];
    _startCount = 0;
    for (UIView *viewSpace in _recordPercent.subviews) {
        if (viewSpace.tag == 1000) {
            [viewSpace removeFromSuperview];
        }
    }
    [_arrayViewSpeacators removeAllObjects];
}

- (IBAction)changeCamera:(id)sender {
    if ([PBJVision sharedInstance].cameraDevice == PBJCameraDeviceBack && [[PBJVision sharedInstance] isCameraDeviceAvailable:PBJCameraDeviceFront]) {
        [PBJVision sharedInstance].cameraDevice = PBJCameraDeviceFront;
    }
    else if ([PBJVision sharedInstance].cameraDevice == PBJCameraDeviceFront && [[PBJVision sharedInstance] isCameraDeviceAvailable:PBJCameraDeviceBack]){
        [PBJVision sharedInstance].cameraDevice = PBJCameraDeviceBack;
        
    }
}

@end
