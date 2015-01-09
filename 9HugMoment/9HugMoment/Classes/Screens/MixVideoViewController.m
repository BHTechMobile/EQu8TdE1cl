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
    _changeFrameButtons = [[NSMutableArray alloc] init];
    [self initNavigationView];
    [self.navigationCustomView addSubview:_navigationView];
    [self playVideoWithFilter:@"GPUImageFilter"];
    [self createUI];
    imageChoose = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    imageChoose.image = [UIImage imageNamed:@"play-icon"];
    [self hightConstraint];
    needShowEnterMessageView = NO;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    _locationManagement = [LocationManagement shareLocation];
    _locationManagement.locationManager.delegate = self;
    [_locationManagement requestTurnOnLocationServices];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    // Remove Notification.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:[UIApplication sharedApplication]];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidFinishLaunchingNotification object:[UIApplication sharedApplication]];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

#pragma mark - Custom Methods

//+ (NSArray *)filters
//{
//    static NSArray *names;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        names = @[
//                  @"GPUImageFilter",
//                  @"GPUImageBilateralFilter",
//                  @"GPUImageBoxBlurFilter",
//                  @"GPUImageBulgeDistortionFilter",
//                  @"GPUImageColorInvertFilter",
//                  @"GPUImageGaussianBlurPositionFilter",
//                  @"GPUImageGaussianSelectiveBlurFilter",
//                  @"GPUImageGrayscaleFilter",
//                  @"GPUImageMissEtikateFilter",
//                  @"GPUImageMonochromeFilter",
//                  @"GPUImagePinchDistortionFilter",
//                  @"GPUImageSepiaFilter",
//                  @"GPUImageZoomBlurFilter",
//                  @"GPUImageColorDodgeBlendFilter0",
//                  @"GPUImageColorDodgeBlendFilter1",
//                  @"GPUImageColorDodgeBlendFilter2",
//                  @"GPUImageColorDodgeBlendFilter3",
//                  @"GPUImageColorDodgeBlendFilter4",
//                  @"GPUImageColorDodgeBlendFilter5",
//                  @"GPUImageColorDodgeBlendFilter6",
//                  @"GPUImageColorDodgeBlendFilter7",
//                  @"GPUImageColorDodgeBlendFilter8"
//                  ];
//    });
//    
//    return names;
//}
//
//+ (NSArray *)titleFilter{
//    static NSArray *titles;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        titles = @[
//                   @"None",
//                   @"Bilateral",
//                   @"Box Blur",
//                   @"Bulge",
//                   @"Invert",
//                   @"Blur",
//                   @"Selective",
//                   @"Grayscale",
//                   @"Etikate",
//                   @"Monochrome",
//                   @"Distortion",
//                   @"Sepia",
//                   @"Zoom Blur",
//                   @"Blue Yellow",
//                   @"Binary",
//                   @"Moving Cloud",
//                   @"Footage Crate",
//                   @"Colorful Rays",
//                   @"Rainning",
//                   @"Sky",
//                   @"Shooting Stars",
//                   @"Swrirling Colored"
//                   ];
//    });
//    
//    return titles;
//}

- (void)createUI{
    _imvFrame.image = _imgFrame;
    
    //Schedule
    [self initScheduleView];
    // Enter Message
    [self initInputMessageView];
    
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

    [self createFramesVideo];
    [self createFiltersVideo];
    
}

- (void)createFramesVideo
{
    if(([FramesModel sharedFrames].frames) &&
       ([[FramesModel sharedFrames].frames isKindOfClass:[NSArray class]]))
    {
        for (int i = 0; i < [FramesModel sharedFrames].frames.count; i++)
        {
            UIImage *currentThumbnail = nil;
            Frame *currentFrame = [[FramesModel sharedFrames].frames objectAtIndex:i];
            currentThumbnail = currentFrame.thumbnailImage;
            
            UIButton *currentButton = [Utilities squareButtonWithSize:SIZE_SQUARE_BUTTON_FRAME_MIX_VIDEO_VIEW_CONTROLLER
                                                           background:currentThumbnail
                                                                 text:nil
                                                               target:self
                                                             selector:@selector(changeFrame:) tag:i
                                                          isTypeFrame:YES];
            if(!currentThumbnail)
            {
                [currentButton setImage:[UIImage imageNamed:IMAGE_NAME_ICON_DEFAULT_NO_IMAGE] forState:UIControlStateNormal];
                [currentFrame downloadThumbnailSuccess:^{
                    
                    [currentButton setImage:currentFrame.thumbnailImage forState:UIControlStateNormal];
                    UIView *parentButton = currentButton.superview;
                    [currentButton removeFromSuperview];
                    [parentButton addSubview:currentButton];
                } failure:^(NSError *error) {
                    NSLog(@"Download Frame failed:%@",error.localizedDescription);
                }];
            }
            [_changeFrameButtons addObject:currentButton];
        }
    }
    _selectFrameScrollView.contentSize = CGSizeMake(_changeFrameButtons.count*66, _selectFrameScrollView.frame.size.height);
    _selectFrameScrollView.scrollEnabled = YES;
    
    for (int i = 0;i<_changeFrameButtons.count;i++) {
        
        UIButton * button = _changeFrameButtons[i];
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
}

- (void)createFiltersVideo
{
    _videoFilterScrollView.contentSize = CGSizeMake([FiltersModel sharedFilters].filters.count*60 + ([FiltersModel sharedFilters].filters.count -1) *10, _videoFilterScrollView.frame.size.height);
    _videoFilterScrollView.scrollEnabled = YES;
    
    for (int i = 0; i < [FiltersModel sharedFilters].filters.count; i++) {
        VideoFilterActionView * actionView = [VideoFilterActionView fromNib];
        Filter *currentFilter = [[FiltersModel sharedFilters].filters objectAtIndex:i];
        if (!currentFilter.thumbnailImage) {
            actionView.imageView.image = [UIImage imageNamed:IMAGE_NAME_ICON_DEFAULT_NO_IMAGE];
            [currentFilter downloadThumbnailSuccess:^{
                actionView.imageView.image = [[self class] makeRoundedImage:currentFilter.thumbnailImage radius:30];
                UIView *parent = actionView.superview;
                [actionView removeFromSuperview];
                [parent addSubview:actionView];
            } failure:^(NSError *error) {
                NSLog(@"Download Filter failed:%@",error.localizedDescription);
            }];
        }
        else
        {
            actionView.imageView.image = [[self class] makeRoundedImage:currentFilter.thumbnailImage radius:30];
        }
        
        actionView.layer.masksToBounds = YES;
        //        actionView.imageView.layer.cornerRadius = actionView.imageView.image.size.width/2;
        actionView.label.text = currentFilter.name;
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
        default:
            break;
    }
}

- (void)playVideoWithFilter:(Filter *)filterVideo
{

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
    
    if ([filterVideo.type isEqualToString:FILTER_TYPE_NAME_STATIC])
    {
        filter = [[NSClassFromString(filterVideo.className) alloc] init];
        if (filter == nil) {
            return;
        }
        [movieFile addTarget:filter];
        GPUImageView *filterView = (GPUImageView *)self.playerView;
        [filter addTarget:filterView];
        [movieFile startProcessing];
    }
    else if ([filterVideo.type isEqualToString:FILTER_TYPE_NAME_DYNAMIC])
    {
//        filter = [[NSClassFromString(subFilterClassString) alloc] init];
//        if (filter == nil) {
//            return;
//        }
//        NSString * videoIndex = [filterVideo substringFromIndex:filterVideo.length -1];
//        
//        NSURL *filterURL = [[NSBundle mainBundle] URLForResource:pathFilter withExtension:(videoIndex.integerValue == 3 || videoIndex.integerValue == 6)?@"mov":@"mp4"];
//        
//        filterMovie = [[GPUImageMovie alloc] initWithURL:filterURL];
//        
//        filterMovie.playAtActualSpeed = YES;
//        
//        [movieFile addTarget:filter];
//        [filterMovie addTarget:filter];
//        
//        [filter addTarget:_playerView];
//        
//        [movieFile startProcessing];
//        [filterMovie startProcessing];
    }
    [_audioPlayer performSelector:@selector(play) withObject:nil afterDelay:0.1];
    
    
//    NSString * subFilterClassString = [filterVideo substringToIndex:filterVideo.length -1];
//    if ([subFilterClassString isEqualToString:@"GPUImageColorDodgeBlendFilter"]) {
//        filter = [[NSClassFromString(subFilterClassString) alloc] init];
//        if (filter == nil) {
//            return;
//        }
//        NSString * videoIndex = [filterVideo substringFromIndex:filterVideo.length -1];
//        
//        NSURL *filterURL = [[NSBundle mainBundle] URLForResource:pathFilter withExtension:(videoIndex.integerValue == 3 || videoIndex.integerValue == 6)?@"mov":@"mp4"];
//        
//        filterMovie = [[GPUImageMovie alloc] initWithURL:filterURL];
//        
//        filterMovie.playAtActualSpeed = YES;
//        
//        [movieFile addTarget:filter];
//        [filterMovie addTarget:filter];
//        
//        [filter addTarget:_playerView];
//        
//        [movieFile startProcessing];
//        [filterMovie startProcessing];
//    }
//    else{
//        filter = [[NSClassFromString(_currentFilterClassString) alloc] init];
//        if (filter == nil) {
//            return;
//        }
//        [movieFile addTarget:filter];
//        GPUImageView *filterView = (GPUImageView *)self.playerView;
//        [filter addTarget:filterView];
//        [movieFile startProcessing];
//    }
    
}

//-(void)playVideoWithFilter:(NSString*)filterClassString{
//    
//    _currentFilterClassString = filterClassString;
//    
//    _imvPlay.hidden = YES;
//    _isPlaying = YES;
//    if (movieFile) {
//        [movieFile cancelProcessing];
//        [movieFile endProcessing];
//        movieFile = nil;
//    }
//    
//    if (filterMovie){
//        [filterMovie cancelProcessing];
//        [filterMovie endProcessing];
//        filterMovie = nil;
//        
//    }
//    
//    [_audioPlayer stop];
//    NSError * audioError = nil;
//    
//    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:(_exportUrl)?_exportUrl:_capturePath error:&audioError];
//    _audioPlayer.delegate = self;
//    if (!audioError) {
//        [_audioPlayer prepareToPlay];
//    }
//    
//    movieFile = [[GPUImageMovie alloc] initWithURL:(_exportUrl)?_exportUrl:_capturePath];
//    movieFile.playAtActualSpeed = YES;
//    movieFile.shouldRepeat = NO;
//    
//    if (filter) {
//        [filter removeAllTargets];
//        filter = nil;
//    }
//    
//    
//    NSString * subFilterClassString = [filterClassString substringToIndex:filterClassString.length -1];
//    if ([subFilterClassString isEqualToString:@"GPUImageColorDodgeBlendFilter"]) {
//        filter = [[NSClassFromString(subFilterClassString) alloc] init];
//        if (filter == nil) {
//            return;
//        }
//        NSString * videoIndex = [filterClassString substringFromIndex:filterClassString.length -1];
//        
//        NSURL *filterURL = [[NSBundle mainBundle] URLForResource:filterClassString withExtension:(videoIndex.integerValue == 3 || videoIndex.integerValue == 6)?@"mov":@"mp4"];
//        
//        filterMovie = [[GPUImageMovie alloc] initWithURL:filterURL];
//        
//        filterMovie.playAtActualSpeed = YES;
//        
//        [movieFile addTarget:filter];
//        [filterMovie addTarget:filter];
//        
//        [filter addTarget:_playerView];
//        
//        [movieFile startProcessing];
//        [filterMovie startProcessing];
//    }
//    else{
//        filter = [[NSClassFromString(_currentFilterClassString) alloc] init];
//        if (filter == nil) {
//            return;
//        }
//        [movieFile addTarget:filter];
//        GPUImageView *filterView = (GPUImageView *)self.playerView;
//        [filter addTarget:filterView];
//        [movieFile startProcessing];
//    }
//    [_audioPlayer performSelector:@selector(play) withObject:nil afterDelay:0.1];
//    
//}

#pragma mark - Actions

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

- (void)changeFilter:(id)sender{
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
    
    //TODO: Filter Play
//    Filter *currentFilter = [[FiltersModel sharedFilters].filters objectAtIndex:[sender tag]];
    [self playVideoWithFilter:[[FiltersModel sharedFilters].filters objectAtIndex:[sender tag]]];
    
}

- (void)changeFrame:(id)sender{
    for (UIView * view in _selectFrameScrollView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            ((UIButton*)view).layer.borderWidth = 0;
        }
    }

    Frame *currentFrame = [[FramesModel sharedFrames].frames objectAtIndex:[sender tag]];
    _imvFrame.image = currentFrame.detailImage;
    if(!currentFrame.detailImage)
    {
        [currentFrame downloadThumbnailSuccess:^{
            _imvFrame.image = currentFrame.detailImage;
        } failure:^(NSError *error) {
            NSLog(@"Download Frame failed:%@",error.localizedDescription);
        }];
    }
    
    UIButton *currentSelectButton = sender;
    _imgFrame = _imvFrame.image;
    currentSelectButton.layer.borderWidth = 3;
    currentSelectButton.layer.borderColor = [UIColor colorWithRed:69/255.0 green:187/255.0 blue:255/255.0 alpha:1.0].CGColor;
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

- (IBAction)sendButtonTapped:(UIButton *)sender {
    [self mixVideo];
}

- (IBAction)backButtonTapped:(id)sender {
    [movieFile cancelProcessing];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickedPlayButton:(id)sender {
    if (_isPlaying) {
        [movieFile cancelProcessing];
        [_audioPlayer stop];
        _isPlaying = !_isPlaying;
        _imvPlay.hidden = _isPlaying;
    }
    else{
        [self playVideoWithFilter:_currentFilter];
    }
    
}

#pragma mark - ...

- (void)setupRemotePlayerByUrl:(NSURL*)url{
    
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
    
    NSString *latitudeLocal = [NSString stringWithFormat:@"%f", currentLocation.coordinate.latitude];
    NSString *longitudeLocal = [NSString stringWithFormat:@"%f", currentLocation.coordinate.longitude];
    NSLog(@"latitudeLocal %f ",currentLocation.coordinate.latitude);
    NSLog(@"longitudeLocal %f ",currentLocation.coordinate.longitude);
    [MixVideoServices updateMessage:_message?_message:@""
                                key:_mKey
                              frame:@"1"
                               path:_exportUrl
                           latitude:latitudeLocal
                          longitude:longitudeLocal
                       notification:_notificationButton.selected
                          scheduled:[NSString stringWithFormat:@"%f",[[_scheduleView getSelectedDate] timeIntervalSince1970]]
                          thumbnail:image
                            sussess:^(AFHTTPRequestOperation *operation, id responseObject) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                                    [[NSNotificationCenter defaultCenter] postNotificationName:CALL_PUSH_NOTIFICATIONS object:nil];
                                    [self.navigationController popToRootViewControllerAnimated:YES];
                                });
                            }
                            failure:^(NSString *bodyString, NSError *error) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                                });
                            _mixed = NO;
                        }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Actions

- (IBAction)calendarAction:(id)sender {
    [_calendatButton setBackgroundImage:[UIImage imageNamed:IMAGE_NAME_ICON_CALENDAR_ON] forState:UIControlStateNormal];
    _scheduleView.hidden = NO;
    [_scheduleView showWithAnimation];
    
}

- (IBAction)messageAction:(id)sender {
    needShowEnterMessageView = YES;
    [_messageButton setBackgroundImage:[UIImage imageNamed:IMAGE_NAME_ICON_TEXT_MESSAGE_ON] forState:UIControlStateNormal];
    _enterMessageView.hidden = NO;
    [_enterMessageView.textView setText:@""];
    [_enterMessageView.textView becomeFirstResponder];
}

- (IBAction)frameInputAction:(id)sender {
    //TODO File Action
}

- (IBAction)notificationAction:(id)sender {
    _notificationButton.selected = !_notificationButton.selected;
    if (_notificationButton.selected)
    {
        [_notificationButton setBackgroundImage:[UIImage imageNamed:IMAGE_NAME_ICON_NOTIFICATION_ON] forState:UIControlStateNormal];
    }
    else
    {
        [_notificationButton setBackgroundImage:[UIImage imageNamed:IMAGE_NAME_ICON_NOTIFICATION] forState:UIControlStateNormal];
    }
}

- (IBAction)tagAction:(id)sender {
    _tagButton.selected = !_tagButton.selected;
    if (_tagButton.selected)
    {
        [_tagButton setBackgroundImage:[UIImage imageNamed:IMAGE_NAME_ICON_TAG_ON] forState:UIControlStateNormal];
    }
    else
    {
        [_tagButton setBackgroundImage:[UIImage imageNamed:IMAGE_NAME_ICON_TAG] forState:UIControlStateNormal];
    }
}

- (IBAction)publicVideoButtonAction:(id)sender {
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"songsongsong" object:nil];
    [self mixVideo];
}

#pragma mark - GPUImageMovie delegate

- (void)didCompletePlayingMovie
{
    //TODO: Completed play movie
}

#pragma mark - Custom Methods

- (void)keyboardWillShow:(NSNotification*)aNotification
{
    NSDictionary *keyboardInfo = [aNotification userInfo];
    NSValue *keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    if (needShowEnterMessageView) {
        [self showEnterMessageViewWithKeyboardFrame:keyboardFrameBeginRect];
    }
}

#pragma mark - ScheduleView management

- (void)initScheduleView
{
    _scheduleView = [ScheduleView fromNib];
    _scheduleView.frame = CGRectMake(0, self.view.size.height-_scheduleView.frame.size.height, self.view.frame.size.width, _scheduleView.frame.size.height);
    _scheduleView.alpha = 0.0;
    [self.view addSubview:_scheduleView];
    _scheduleView.hidden = YES;
}


#pragma mark - EnterMessage management & delegate

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
    CGPoint enterMessagePoint = CGPointMake(HALF_OF(_contentMixView.frame.size.width) - HALF_OF(SIZE_ENTER_MESSAGE_MOMENT_DETAIL_VIEW_CONTROLLER.width), HALF_OF(_contentMixView.frame.size.height) - HALF_OF(SIZE_ENTER_MESSAGE_MOMENT_DETAIL_VIEW_CONTROLLER.height));
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

- (void)showEnterMessageViewWithKeyboardFrame:(CGRect)keyboardFrameBeginRect
{
    CGFloat yPointEnterMessageShow = HALF_OF(_contentMixView.frame.size.height) - HALF_OF(SIZE_ENTER_MESSAGE_MOMENT_DETAIL_VIEW_CONTROLLER.height);
    CGFloat yPointKeyboardAfterShow = keyboardFrameBeginRect.origin.y - keyboardFrameBeginRect.size.height;
    if (yPointKeyboardAfterShow < (yPointEnterMessageShow + SIZE_ENTER_MESSAGE_MOMENT_DETAIL_VIEW_CONTROLLER.height)) {
        
        [UIView animateWithDuration:TIME_TO_SHOW_ENTER_MESSAGE_VIEW animations:^{
            CGPoint enterMessagePoint = CGPointMake(HALF_OF(_contentMixView.frame.size.width) - HALF_OF(SIZE_ENTER_MESSAGE_MOMENT_DETAIL_VIEW_CONTROLLER.width), yPointKeyboardAfterShow - SIZE_ENTER_MESSAGE_MOMENT_DETAIL_VIEW_CONTROLLER.height);
            CGRect enterMessageFrame = CGRectMake(enterMessagePoint.x, enterMessagePoint.y, SIZE_ENTER_MESSAGE_MOMENT_DETAIL_VIEW_CONTROLLER.width, SIZE_ENTER_MESSAGE_MOMENT_DETAIL_VIEW_CONTROLLER.height);
            _enterMessageView.frame = enterMessageFrame;
        }];
        
    }else {
        [UIView animateWithDuration:TIME_TO_SHOW_ENTER_MESSAGE_VIEW animations:^{
            [self setDefaultFrameInputMessageView];
        }];
    }
}

- (void)didCancelInputMessage
{
    needShowEnterMessageView = NO;
    if ((![_message isEqualToString:@""]) && (_message != nil)) {
        [_messageButton setBackgroundImage:[UIImage imageNamed:IMAGE_NAME_ICON_TEXT_MESSAGE_ON] forState:UIControlStateNormal];
    }
    else{
        [_messageButton setBackgroundImage:[UIImage imageNamed:IMAGE_NAME_ICON_TEXT_MESSAGE] forState:UIControlStateNormal];
    }
    [self setFrameInputMessageViewHide];
    _enterMessageView.hidden = YES;
}

- (void)didEnterMessage:(EnterMessageView *)enterMessageController andMessage:(NSString *)message
{
    _message = message;
    [self didCancelInputMessage];
}


@end
