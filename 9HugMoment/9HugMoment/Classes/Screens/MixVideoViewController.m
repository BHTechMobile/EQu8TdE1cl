//
//  MixVideoViewController.m
//  9HugMoment
//
//  Created by Tommy on 11/24/14.
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import "MixVideoViewController.h"
#import "VideoFilterActionView.h"
#import "MixAudioViewController.h"

@interface MixVideoViewController ()

@property (nonatomic, strong) NSString *tokenAuto;
@property (nonatomic, strong) MPMediaItem* audioItem;
@property (nonatomic, strong) NSURL* exportUrl;
@property (nonatomic, assign) BOOL mixed;
@property (nonatomic, strong) NSString* message;
@property (nonatomic, weak) NSLayoutConstraint *topPosition;
@property (nonatomic, strong) NSDictionary *postParams;

@property (weak, nonatomic) IBOutlet UIButton *touchPublicVideoButton;
@property (weak, nonatomic) IBOutlet UIView *navigationCustomView;
@property (strong, nonatomic) IBOutlet GPUImageView *playerView;
@property (weak, nonatomic) IBOutlet UIImageView *imvFrame;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;
@property (weak, nonatomic) IBOutlet UIScrollView *selectFrameScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *videoFilterScrollView;
@property (weak, nonatomic) IBOutlet UIButton *notificationButton;
@property (weak, nonatomic) IBOutlet UIButton *btnPlay;
@property (weak, nonatomic) IBOutlet UIImageView *imvPlay;
@property (weak, nonatomic) IBOutlet UIButton *btnFrames;
@property (weak, nonatomic) IBOutlet UIButton *btnVideoFilters;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *hightImageViewOffsetConstraint;

- (IBAction)publicVideoButtonAction:(id)sender;

@end

@implementation MixVideoViewController{
    UIButton *buttonBack;
    UIImageView *imageChoose;
    MixAudioViewController *mixAudioViewController;
    NSString *linkVideoFromServer;
}

#pragma mark - Header Control

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationView];
    [self.navigationCustomView addSubview:_navigationView];
    [self playVideoWithFilter:@"GPUImageFilter"];
    [self createUI];
    imageChoose = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    imageChoose.image = [UIImage imageNamed:@"play-icon"];
    [self hightConstraint];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _navigationView.titleNvgLabel.text = @"Mixing Video";
    [self hightConstraint];
    
    _locationManagement = [LocationManagement shareLocation];
    _locationManagement.locationManager.delegate = self;
    [_locationManagement getCurrentLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Location Management

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    // Notification when application close or reopen.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActiveNotification:) name:UIApplicationDidBecomeActiveNotification object:[UIApplication sharedApplication]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidFinishLaunchingNotification:) name:UIApplicationDidFinishLaunchingNotification object:[UIApplication sharedApplication]];
    
    _locationManagement = [LocationManagement shareLocation];
    _locationManagement.locationManager.delegate = self;
    [_locationManagement requestTurnOnLocationServices];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    // Remove Notification.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:[UIApplication sharedApplication]];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidFinishLaunchingNotification object:[UIApplication sharedApplication]];
    
    [_locationManagement.locationManager stopUpdatingLocation];
}

- (void)applicationDidBecomeActiveNotification:(NSNotification *)notification {
    _locationManagement = [LocationManagement shareLocation];
    [_locationManagement requestTurnOnLocationServices];
    //    [_locationManagement.locationManager startUpdatingLocation];
}

- (void)applicationDidFinishLaunchingNotification:(NSNotification *)notification{
    [_locationManagement.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    currentLocation = newLocation;
    NSLog(@"found %f",newLocation.coordinate.latitude);
    NSLog(@"found currentLocation %f",currentLocation.coordinate.latitude);
    [_locationManagement.locationManager stopUpdatingLocation];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    switch (status) {
        case kCLAuthorizationStatusAuthorized:
            NSLog(@"kCLAuthorizationStatusAuthorized");
            [_locationManagement.locationManager startUpdatingLocation];
            break;
        case kCLAuthorizationStatusDenied:
            NSLog(@"kCLAuthorizationStatusDenied");
            break;
        case kCLAuthorizationStatusNotDetermined:
            NSLog(@"kCLAuthorizationStatusNotDetermined");
            break;
        case kCLAuthorizationStatusRestricted:
            NSLog(@"kCLAuthorizationStatusRestricted");
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            NSLog(@"kCLAuthorizationStatusAuthorizedWhenInUse");
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    [_locationManagement.locationManager stopUpdatingLocation];
}


#pragma mark - NSLayoutConstraint

- (void)hightConstraint{
    if (IS_IPHONE_4) {
        _hightImageViewOffsetConstraint.constant = 280;
    }else if (IS_IPHONE_5){
        _hightImageViewOffsetConstraint.constant = 320;
    }else if (IS_IPHONE_6){
        _hightImageViewOffsetConstraint.constant = 375;
    }else if (IS_IPHONE_6_PLUS){
        _hightImageViewOffsetConstraint.constant = 414;
    }
}

#pragma mark - Navigation Custom View

- (void)initNavigationView {
    _navigationView = [[NavigationView alloc]initWithFrame:CGRectZero];
    _navigationView.delegate = self;
    CGRect navigationViewFrame = CGRectMake(0, 0, self.navigationCustomView.frame.size.width, self.navigationCustomView.frame.size.height);
    _navigationView.frame = navigationViewFrame;
}

- (void)backNvgAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)facebookNvgAction {
    
}

- (void)twitterNvgAction {
    
}

- (void)ggPlusNvgAction {
    
}

#pragma mark - Fillter

+ (NSArray *)filters
{
    static NSArray *names;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        names = @[
                  @"GPUImageFilter",
                  @"GPUImageBilateralFilter",
                  @"GPUImageBoxBlurFilter",
                  @"GPUImageBulgeDistortionFilter",
                  @"GPUImageColorInvertFilter",
                  @"GPUImageGaussianBlurPositionFilter",
                  @"GPUImageGaussianSelectiveBlurFilter",
                  @"GPUImageGrayscaleFilter",
                  @"GPUImageMissEtikateFilter",
                  @"GPUImageMonochromeFilter",
                  @"GPUImagePinchDistortionFilter",
                  @"GPUImageSepiaFilter",
                  @"GPUImageZoomBlurFilter",
                  @"GPUImageColorDodgeBlendFilter0",
                  @"GPUImageColorDodgeBlendFilter1",
                  @"GPUImageColorDodgeBlendFilter2",
                  @"GPUImageColorDodgeBlendFilter3",
                  @"GPUImageColorDodgeBlendFilter4",
                  @"GPUImageColorDodgeBlendFilter5",
                  @"GPUImageColorDodgeBlendFilter6",
                  @"GPUImageColorDodgeBlendFilter7",
                  @"GPUImageColorDodgeBlendFilter8"
                  ];
    });
    
    return names;
}

+ (NSArray *)titleFilter{
    static NSArray *titles;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        titles = @[
                   @"None",
                   @"Bilateral",
                   @"Box Blur",
                   @"Bulge",
                   @"Invert",
                   @"Blur",
                   @"Selective",
                   @"Grayscale",
                   @"Etikate",
                   @"Monochrome",
                   @"Distortion",
                   @"Sepia",
                   @"Zoom Blur",
                   @"Blue Yellow",
                   @"Binary",
                   @"Moving Cloud",
                   @"Footage Crate",
                   @"Colorful Rays",
                   @"Rainning",
                   @"Sky",
                   @"Shooting Stars",
                   @"Swrirling Colored"
                   ];
    });
    
    return titles;
}

#pragma mark - Create UI

-(void)createUI{
    _imvFrame.image = _imgFrame;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(sendButtonTapped:) forControlEvents:UIControlEventTouchUpInside]; //adding action
    [button setBackgroundImage:[UIImage imageNamed:@"btn_nex_cyan"] forState:UIControlStateNormal];
    button.frame = CGRectMake(2 ,2,14,22);
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barButton;
    
    buttonBack=[UIButton buttonWithType:UIButtonTypeCustom];
    [buttonBack setFrame:CGRectMake(2 ,2,14,22)];
    [buttonBack addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [buttonBack setImage:[UIImage imageNamed:@"btn_back_cyan@2x.png"] forState:UIControlStateNormal];
    UIBarButtonItem *btnback = [[UIBarButtonItem alloc]initWithCustomView:buttonBack];
    self.navigationItem.leftBarButtonItem = btnback;
    
    const NSArray* frameNames =@[@"bgr_frame_select_no_frame",
                                 @"1_pink_heart_thumb",
                                 @"2_blue amazing curve_thumb",
                                 @"4_halloween_thumb",
                                 @"3_butter_fly_thumb",
                                 @"5_floral_on_the_right_thumb",
                                 @"6_golden_flora_thumb",
                                 @"7_daisies_yellow_thumb"];
    
    changeFrameButtons = @[
                           [Utilities squareButtonWithSize:60 background:[UIImage imageNamed:[frameNames objectAtIndex:0]] text:nil target:self selector:@selector(changeFrame:) tag:0 isTypeFrame:YES],
                           [Utilities squareButtonWithSize:58 background:[UIImage imageNamed:[frameNames objectAtIndex:1]] text:nil target:self selector:@selector(changeFrame:) tag:1 isTypeFrame:YES],
                           [Utilities squareButtonWithSize:58 background:[UIImage imageNamed:[frameNames objectAtIndex:2]] text:nil target:self selector:@selector(changeFrame:) tag:2 isTypeFrame:YES],
                           [Utilities squareButtonWithSize:58 background:[UIImage imageNamed:[frameNames objectAtIndex:3]] text:nil target:self selector:@selector(changeFrame:) tag:3 isTypeFrame:YES],
                           [Utilities squareButtonWithSize:58 background:[UIImage imageNamed:[frameNames objectAtIndex:4]] text:nil target:self selector:@selector(changeFrame:) tag:4 isTypeFrame:YES],
                           [Utilities squareButtonWithSize:58 background:[UIImage imageNamed:[frameNames objectAtIndex:5]] text:nil target:self selector:@selector(changeFrame:) tag:5 isTypeFrame:YES],
                           [Utilities squareButtonWithSize:58 background:[UIImage imageNamed:[frameNames objectAtIndex:6]] text:nil target:self selector:@selector(changeFrame:) tag:6 isTypeFrame:YES],
                           [Utilities squareButtonWithSize:58 background:[UIImage imageNamed:[frameNames objectAtIndex:7]] text:nil target:self selector:@selector(changeFrame:) tag:7 isTypeFrame:YES]
                           ];
    
    _selectFrameScrollView.contentSize = CGSizeMake(changeFrameButtons.count*66, _selectFrameScrollView.frame.size.height);
    _selectFrameScrollView.scrollEnabled = YES;
    
    for (int i = 0;i<changeFrameButtons.count;i++) {
        
        UIButton * button = changeFrameButtons[i];
        if (i ==0) {
            button.layer.borderWidth = 3;
            button.layer.borderColor = [UIColor colorWithRed:69/255.0 green:187/255.0 blue:255/255.0 alpha:1.0].CGColor;
            
        }
        button.center = CGPointMake(4+button.self.frame.size.width/2 + i*(button.self.frame.size.width+8), 36);
        [_selectFrameScrollView addSubview:button];
        if (i==_indexFrame) {
            [_selectFrameScrollView scrollRectToVisible:button.frame animated:YES];
            [self changeFrame:button];
        }
    }
    
    _videoFilterScrollView.contentSize = CGSizeMake([MixVideoViewController filters].count*60 + ([MixVideoViewController filters].count -1) *10, _videoFilterScrollView.frame.size.height);
//    _videoFilterScrollView.contentSize = CGSizeMake(_videoFilterScrollView.frame.size.width, _videoFilterScrollView.frame.size.height);
    _videoFilterScrollView.scrollEnabled = YES;
    
    for (int i = 0;i<[MixVideoViewController filters].count;i++) {
        VideoFilterActionView * actionView = [VideoFilterActionView fromNib];
        actionView.imageView.image = [[self class] makeRoundedImage:[UIImage imageNamed:(i<22)?[MixVideoViewController filters][i]:@"GPUImageFilter"] radius:30];
        actionView.layer.masksToBounds = YES;
        //        actionView.imageView.layer.cornerRadius = actionView.imageView.image.size.width/2;
        actionView.label.text = [MixVideoViewController titleFilter][i];
        actionView.button.tag = i;
        [actionView.button addTarget:self action:@selector(changeFilter:) forControlEvents:UIControlEventTouchUpInside];
//        actionView.frame = CGRectMake(i * 70, 0, actionView.frame.size.width, actionView.frame.size.height);
        actionView.frame = CGRectMake(i * 70, 0, 60, 80);
        [_videoFilterScrollView addSubview:actionView];
    }
    
    _videoFilterScrollView.backgroundColor = [UIColor colorWithRed:43.0/255.0f green:41.0/255.0f blue:50.0/255.0f alpha:1];
    _selectFrameScrollView.backgroundColor = [UIColor colorWithRed:43.0/255.0f green:41.0/255.0f blue:50.0/255.0f alpha:1];
    [self clickedVideoFilterButton:nil];
    
}

#pragma mark - Button controll

- (IBAction)clickedFramesButtons:(id)sender {
    _videoFilterScrollView.hidden = YES;
    _selectFrameScrollView.hidden = NO;
    _btnFrames.selected = YES;
    _btnVideoFilters.selected = NO;
}

- (IBAction)clickedVideoFilterButton:(id)sender {
    _videoFilterScrollView.hidden = NO;
    _selectFrameScrollView.hidden = YES;
    _btnFrames.selected = NO;
    _btnVideoFilters.selected = YES;
}

-(IBAction)changeFilter:(id)sender{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    for (int i = 0;i<_videoFilterScrollView.subviews.count;i++) {
        if (i==[sender tag]) {
            UIView *view = (VideoFilterActionView*)_videoFilterScrollView.subviews[i];
            [view addSubview:imageChoose];
            //            ((VideoFilterActionView*)_videoFilterScrollView.subviews[i]).imageView.layer.borderWidth = 3;
            //            ((VideoFilterActionView*)_videoFilterScrollView.subviews[i]).imageView.layer.borderColor = [UIColor colorWithRed:69/255.0 green:187/255.0 blue:255/255.0 alpha:1.0].CGColor;
        }
        //        else{
        //            ((VideoFilterActionView*)_videoFilterScrollView.subviews[i]).imageView.layer.borderWidth = 0;
        //        }
    }
    [self playVideoWithFilter:[[MixVideoViewController filters] objectAtIndex:[sender tag]]];
    
}

-(IBAction)changeFrame:(id)sender{
    for (UIView * view in _selectFrameScrollView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            ((UIButton*)view).layer.borderWidth = 0;
        }
    }
    
    const NSArray* frameNames =@[@"",@"1_pink_heart",
                                 @"2_blue amazing curve",
                                 @"4_halloween",
                                 @"3_butter_fly",
                                 @"5_floral_on_the_right",
                                 @"6_golden_flora",
                                 @"7_daisies_yellow"];
    
    _imvFrame.image = [UIImage imageNamed:[frameNames objectAtIndex:[sender tag]]];
    UIButton * button = sender;
    _imgFrame = _imvFrame.image;
    button.layer.borderWidth = 3;
    button.layer.borderColor = [UIColor colorWithRed:69/255.0 green:187/255.0 blue:255/255.0 alpha:1.0].CGColor;
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

#pragma mark - ...

-(void)setupRemotePlayerByUrl:(NSURL*)url{
    
    NSError * audioError = nil;
    if (_audioPlayer) {
        [_audioPlayer stop];
    }
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:_capturePath error:&audioError];
    _audioPlayer.delegate = self;
    if (!audioError) {
        [_audioPlayer prepareToPlay];
    }
    movieFile = [[GPUImageMovie alloc] initWithURL:url];
    movieFile.playAtActualSpeed = YES;
    movieFile.shouldRepeat = NO;
    
    filter = [[GPUImageFilter alloc] init];
    [movieFile addTarget:filter];
    GPUImageView *filterView = (GPUImageView *)self.playerView;
    [filter addTarget:filterView];
    [movieFile startProcessing];
    [_audioPlayer performSelector:@selector(play) withObject:nil afterDelay:0.2];
    _currentFilterClassString = @"GPUImageFilter";
    
}

-(void)playVideoWithFilter:(NSString*)filterClassString{
    
    _currentFilterClassString = filterClassString;
    
    _imvPlay.hidden = YES;
    _isPlaying = YES;
    if (movieFile) {
        [movieFile cancelProcessing];
        [movieFile endProcessing];
        movieFile = nil;
    }
    
    if (filterMovie){
        [filterMovie cancelProcessing];
        [filterMovie endProcessing];
        filterMovie = nil;
        
    }
    
    [_audioPlayer stop];
    NSError * audioError = nil;
    
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:(_exportUrl)?_exportUrl:_capturePath error:&audioError];
    _audioPlayer.delegate = self;
    if (!audioError) {
        [_audioPlayer prepareToPlay];
    }
    
    movieFile = [[GPUImageMovie alloc] initWithURL:(_exportUrl)?_exportUrl:_capturePath];
    movieFile.playAtActualSpeed = YES;
    movieFile.shouldRepeat = NO;
    
    if (filter) {
        [filter removeAllTargets];
        filter = nil;
    }
    
    
    NSString * subFilterClassString = [filterClassString substringToIndex:filterClassString.length -1];
    if ([subFilterClassString isEqualToString:@"GPUImageColorDodgeBlendFilter"]) {
        filter = [[NSClassFromString(subFilterClassString) alloc] init];
        if (filter == nil) {
            return;
        }
        NSString * videoIndex = [filterClassString substringFromIndex:filterClassString.length -1];
        
        NSURL *filterURL = [[NSBundle mainBundle] URLForResource:filterClassString withExtension:(videoIndex.integerValue == 3 || videoIndex.integerValue == 6)?@"mov":@"mp4"];
        
        filterMovie = [[GPUImageMovie alloc] initWithURL:filterURL];
        
        filterMovie.playAtActualSpeed = YES;
        
        [movieFile addTarget:filter];
        [filterMovie addTarget:filter];
        
        [filter addTarget:_playerView];
        
        [movieFile startProcessing];
        [filterMovie startProcessing];
    }
    else{
        filter = [[NSClassFromString(_currentFilterClassString) alloc] init];
        if (filter == nil) {
            return;
        }
        [movieFile addTarget:filter];
        GPUImageView *filterView = (GPUImageView *)self.playerView;
        [filter addTarget:filterView];
        [movieFile startProcessing];
    }
    [_audioPlayer performSelector:@selector(play) withObject:nil afterDelay:0.1];
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation


-(void)mixAudioViewControllerDidCancel
{
//    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)mixAudioViewController:(MixAudioViewController *)setupViewController didMixVideoUrl:(NSURL *)mixUrl
{
    _exportUrl = mixUrl;
    //    _mixed = YES;
    [self.navigationController popViewControllerAnimated:YES];
//    [self.navigationController dismissViewControllerAnimated:NO completion:^{
//        //        [_videoPlayer playWithUrl:_exportUrl];
//    }];
}

#pragma mark - Mix Audio Setup

- (void)mixAudioSetup{
    MixAudioViewController * audioVC =  [[MixAudioViewController alloc] initWithNibName:nil bundle:nil];
    audioVC.capturePath = _capturePath;
    audioVC.audioItem = _audioItem;
    audioVC.delegate = self;
    UIViewController *sourceViewController = self;
    UIViewController *destinationController = audioVC;
    sourceViewController.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
    destinationController.view.alpha = 0.0;
//    [sourceViewController.navigationController presentViewController:destinationController animated:NO completion:nil];
    [UIView beginAnimations: nil context: nil];
    destinationController.view.alpha = 1.0;
    [UIView commitAnimations];

    [self performSegueWithIdentifier:@"pushMixAudioViewController" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"pushMixAudioViewController"]) {
        mixAudioViewController = [segue destinationViewController];
        mixAudioViewController.capturePath = _capturePath;
        mixAudioViewController.audioItem = _audioItem;
        mixAudioViewController.delegate = self;
        
        UIViewController *sourceViewController = self;
        UIViewController *destinationController = mixAudioViewController;
        sourceViewController.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
        destinationController.view.alpha = 0.0;
        [UIView beginAnimations: nil context: nil];
        destinationController.view.alpha = 1.0;
        [UIView commitAnimations];
        
    }
}


- (IBAction)musicButtonTapped:(id)sender {
    if (_isPlaying) {
        [self clickedPlayButton:nil];
    }
    if (_audioItem) {
        [self mixAudioSetup];
        
    }
    else{
        MPMediaPickerController *picker =
        [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeMusic];
        
        picker.delegate						= self;
        picker.allowsPickingMultipleItems	= NO;
        picker.navigationController.navigationBarHidden = YES;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

#pragma mark Media item picker delegate methods________

- (void) mediaPicker: (MPMediaPickerController *) mediaPicker didPickMediaItems: (MPMediaItemCollection *) mediaItemCollection {
    if ([[mediaItemCollection items] count] == 0) {
        return;
    }
    
    _audioItem = [[mediaItemCollection items] objectAtIndex:0];
    
    if (!_audioItem || ![_audioItem valueForProperty:MPMediaItemPropertyAssetURL]) {
        [UIAlertView showMessage:@"Invalid Audio"];
    }
    _mixed = NO;
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self mixAudioSetup];
        
    }];
}

- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - buttons clicked

- (IBAction)sendButtonTapped:(UIButton *)sender {
    [self mixVideo];
}

- (IBAction)backButtonTapped:(id)sender {
    [movieFile cancelProcessing];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)processMixingWithStatus:(AVAssetExportSessionStatus)status outputURLString:(NSString*)output{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    });
    
    switch (status){
        case AVAssetExportSessionStatusFailed:
        {
            _mixed = NO;
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            break;
        }
        case AVAssetExportSessionStatusCompleted:
        {
            _exportUrl = [NSURL fileURLWithPath:output];
            _mixed = YES;
            [self upload];
            break;
        }
    }
}
- (IBAction)clickedPlayButton:(id)sender {
    if (_isPlaying) {
        [movieFile cancelProcessing];
        [_audioPlayer stop];
        _isPlaying = !_isPlaying;
        _imvPlay.hidden = _isPlaying;
    }
    else{
        [self playVideoWithFilter:_currentFilterClassString];
    }
    
}

-(void)mixVideo{
    if (_audioPlayer) {
        [_audioPlayer stop];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _imvPlay.hidden = YES;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    });
    if ([[[filter class] description] isEqualToString:@"GPUImageFilter"]) {
        [MixEngine mixImage:_imgFrame videoUrl:_exportUrl?_exportUrl:_capturePath completionHandler:^(NSString *output, AVAssetExportSessionStatus status) {
            [self processMixingWithStatus:status outputURLString:output];
        }];
    }
    else if ([[_currentFilterClassString substringToIndex:_currentFilterClassString.length -1] isEqualToString:@"GPUImageColorDodgeBlendFilter"]){
        if (movieFile) {
            [movieFile cancelProcessing];
            [movieFile endProcessing];
            movieFile = nil;
        }
        
        if (filterMovie){
            [filterMovie cancelProcessing];
            [filterMovie endProcessing];
            filterMovie = nil;
            
        }
        movieFile = [[GPUImageMovie alloc] initWithURL:(_exportUrl)?_exportUrl:_capturePath];
        movieFile.playAtActualSpeed = YES;
        movieFile.shouldRepeat = NO;
        
        if (filter) {
            [filter removeAllTargets];
            filter = nil;
        }
        filter = [[NSClassFromString([_currentFilterClassString substringToIndex:_currentFilterClassString.length -1]) alloc] init];
        if (filter == nil) {
            return;
        }
        NSString * videoIndex = [_currentFilterClassString substringFromIndex:_currentFilterClassString.length -1];
        
        NSURL *filterURL = [[NSBundle mainBundle] URLForResource:_currentFilterClassString withExtension:(videoIndex.integerValue == 3 || videoIndex.integerValue == 6)?@"mov":@"mp4"];
        
        filterMovie = [[GPUImageMovie alloc] initWithURL:filterURL];
        
        filterMovie.playAtActualSpeed = YES;
        
        [movieFile addTarget:filter];
        [filterMovie addTarget:filter];
        
        NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/abc.m4v"];
        unlink([pathToMovie UTF8String]);
        NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
        
        movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(480, 480.0)];
        
        [filter addTarget:movieWriter];
        
        movieWriter.shouldPassthroughAudio = YES;
        movieFile.audioEncodingTarget = movieWriter;
        [movieFile enableSynchronizedEncodingUsingMovieWriter:movieWriter];
        
        [movieFile startProcessing];
        [filterMovie startProcessing];
        [movieWriter startRecording];
        
        double delayInSeconds = _duration;
        dispatch_time_t stopTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(stopTime, dispatch_get_main_queue(), ^(void){
            [filter removeTarget:movieWriter];
            movieFile.audioEncodingTarget = nil;
            [movieWriter finishRecording];
            [MixEngine mixImage:_imgFrame videoUrl:movieURL completionHandler:^(NSString *output, AVAssetExportSessionStatus status) {
                [self processMixingWithStatus:status outputURLString:output];
            }];
        });
    }
    else{
        _videoFilterScrollView.userInteractionEnabled = NO;
        if (movieFile) {
            [movieFile endProcessing];
            movieFile = nil;
        }
        movieFile = [[GPUImageMovie alloc] initWithURL:(_exportUrl)?_exportUrl:_capturePath];
        movieFile.playAtActualSpeed = YES;
        
        if (filter) {
            [filter removeAllTargets];
            filter = nil;
        }
        filter = [[NSClassFromString(_currentFilterClassString) alloc] init];
        
        [movieFile addTarget:filter];
        
        NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/abc.m4v"];
        unlink([pathToMovie UTF8String]);
        NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
        
        movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(480, 480.0)];
        
        [filter addTarget:movieWriter];
        
        movieWriter.shouldPassthroughAudio = YES;
        movieFile.audioEncodingTarget = movieWriter;
        [movieFile enableSynchronizedEncodingUsingMovieWriter:movieWriter];
        
        [movieFile startProcessing];
        [movieWriter startRecording];
        
        double delayInSeconds = _duration;
        dispatch_time_t stopTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(stopTime, dispatch_get_main_queue(), ^(void){
            [filter removeTarget:movieWriter];
            movieFile.audioEncodingTarget = nil;
            [movieWriter finishRecording];
            [MixEngine mixImage:_imgFrame videoUrl:movieURL completionHandler:^(NSString *output, AVAssetExportSessionStatus status) {
                [self processMixingWithStatus:status outputURLString:output];
            }];
        });
    }
}

#pragma mark - Base Services

-(void)getLinkVideo:(NSString *)_qrCode{
    [BaseServices getMessageByKey:_qrCode sussess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"getLinkVideo success %@",responseObject);
        linkVideoFromServer = [responseObject objectForKey:@"attachement1"];
        NSLog(@"linkVideoFromServer %@",linkVideoFromServer);
        _postParams = @{
                        @"link":linkVideoFromServer
                        };
        NSLog(@"_postParams %@",_postParams);
    } failure:^(NSString *bodyString, NSError *error) {
        NSLog(@"error getLinkVideo %@",error);
    }];
}

#pragma mark - AVAudioPlayer Delegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    _imvPlay.hidden = NO;
    _isPlaying = NO;
    [movieFile cancelProcessing];
}

#pragma mark - Helpers


+ (UIImage *)makeRoundedImage:(UIImage *)image radius:(float)radius;
{
    CALayer *imageLayer = [CALayer layer];
    imageLayer.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    imageLayer.contents = (id)image.CGImage;
    
    imageLayer.masksToBounds = YES;
    imageLayer.cornerRadius = image.size.height/2;
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0);
    [imageLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return roundedImage;
}

- (IBAction)publicVideoButtonAction:(id)sender {
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"songsongsong" object:nil];
    [self mixVideo];
}

#pragma mark - Share video to Facebook

- (void)makeRequestToShareLink:(NSString*)link {
    
    NSDictionary *params = @{@"message": @"I've just take this video with Moment app",
                             @"link": link};
    
    FBRequest *uploadRequest = [FBRequest requestWithGraphPath:@"/me/feed" parameters:params HTTPMethod:@"POST"];
    uploadRequest.session = APP_DELEGATE.session;
    [uploadRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            NSLog(@"result: %@", result);
            [UIAlertView showMessage:@"Video is shared on Facebook!"];
        } else {
            NSLog(@"%@", error.description);
        }
    }];
}

#pragma mark - Upload video

-(void)upload{
    NSLog(@"_exportUrl %@",_exportUrl);
    [BaseServices generateImage:_exportUrl success:^(UIImage *image) {
        [self uploadWithImage:image];
    } failure:^(NSError *error) {
        [self uploadWithImage:nil];
    }];
}

-(void)uploadWithImage:(UIImage*)image{
    [BaseServices createMomentForUser:[[UserData currentAccount] strId] withType:@"1" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString* key = [[responseObject firstObject] valueForKey:@"key"];
        NSString *latitudeLocal = [NSString stringWithFormat:@"%f", currentLocation.coordinate.latitude];
        NSString *longitudeLocal = [NSString stringWithFormat:@"%f", currentLocation.coordinate.longitude];
        NSLog(@"latitudeLocal %f ",currentLocation.coordinate.latitude);
        NSLog(@"longitudeLocal %f ",currentLocation.coordinate.longitude);
        [BaseServices updateMessage:_message?_message:@""
                                key:key
                              frame:@"1"
                               path:_exportUrl
                           latitude:latitudeLocal
                          longitude:longitudeLocal
                       notification:_notificationButton.selected
                          thumbnail:image
                            sussess:^(AFHTTPRequestOperation *operation, id responseObject) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                                    [self makeRequestToShareLink:[NSString stringWithFormat:@"http://www.9hug.com/message/%@",key]];
                                    [UIAlertView showMessage:@"Video is uploaded!"];
                                    [[NSNotificationCenter defaultCenter] postNotificationName:CALL_PUSH_NOTIFICATIONS object:nil];
                                    [self.navigationController popToRootViewControllerAnimated:YES];
                                });
                            } failure:^(NSString *bodyString, NSError *error) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                                });
                                _mixed = NO;
                            }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error %@",error);
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
