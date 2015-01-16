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
#import "FiltersModel.h"

@interface MixVideoViewController ()<VideoFilterActionViewDelegate, MBProgressHUDDelegate>

@property (strong, nonatomic) Filter *selectedFilter;
@property (strong, nonatomic) NSMutableArray *videoFilterActionViewArray;
@property (strong, nonatomic) MBProgressHUD *hud;

@end

@implementation MixVideoViewController

#pragma mark - Header Control

- (void)viewDidLoad {
    [super viewDidLoad];
    _changeFrameButtons = [[NSMutableArray alloc] init];
    _videoFilterActionViewArray = [[NSMutableArray alloc] init];
    [self initNavigationView];
    [self.navigationCustomView addSubview:_navigationView];
    [self playVideoWithFilter:_selectedFilter];
    [self createUI];
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
    self.shareLocationButton.enabled = NO;
    switch (status) {
        case kCLAuthorizationStatusAuthorized:
            NSLog(@"kCLAuthorizationStatusAuthorized");
            [_locationManagement.locationManager startUpdatingLocation];
            self.shareLocationButton.enabled = YES;
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
            self.shareLocationButton.enabled = YES;
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    self.shareLocationButton.selected = NO;
    self.shareLocationButton.enabled = NO;
    
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
                                                             selector:@selector(changeFrame:)
                                                                  tag:i
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
        if (i == 0) {
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
    _videoFilterScrollView.contentSize = CGSizeMake([FiltersModel sharedFilters].filters.count*WIDTH_VIDEO_FILTER_ACTION_VIEW_MIX_VIDEO_VIEW_CONTROLLER + ([FiltersModel sharedFilters].filters.count -1) *PADDING_SCOLL_VIEW_MIX_VIDEO_VIEW_CONTROLLER, HEIGHT_VIDEO_FILTER_ACTION_VIEW_MIX_VIDEO_VIEW_CONTROLLER);
    _videoFilterScrollView.scrollEnabled = YES;
    
    for (int i = 0; i < [FiltersModel sharedFilters].filters.count; i++) {
        VideoFilterActionView *actionView = [VideoFilterActionView fromNib];
        actionView.frame = CGRectMake(i * (PADDING_SCOLL_VIEW_MIX_VIDEO_VIEW_CONTROLLER + WIDTH_VIDEO_FILTER_ACTION_VIEW_MIX_VIDEO_VIEW_CONTROLLER), 0, WIDTH_VIDEO_FILTER_ACTION_VIEW_MIX_VIDEO_VIEW_CONTROLLER, HEIGHT_VIDEO_FILTER_ACTION_VIEW_MIX_VIDEO_VIEW_CONTROLLER);
        Filter *currentFilter = [[FiltersModel sharedFilters].filters objectAtIndex:i];
        [actionView hideDownloadImageView:YES];
//        [actionView setBackgroundColor:[self randomColor]];
        if ([currentFilter.type isEqualToString:FILTER_TYPE_NAME_DYNAMIC]) {
            if (currentFilter.videourl) {
                if (![currentFilter downloadedVideo]) {
                    [actionView hideDownloadImageView:NO];
                }
            }
        }
        
        if (!currentFilter.thumbnailImage) {
            [currentFilter downloadThumbnailSuccess:^{
                [actionView setThumbnailImage:[[self class] makeRoundedImage:currentFilter.thumbnailImage radius:30]];
            } failure:^(NSError *error) {
                NSLog(@"Download Filter failed:%@",error.localizedDescription);
            }];
        }
        else{
            [actionView setThumbnailImage:[[self class] makeRoundedImage:currentFilter.thumbnailImage radius:30]];
        }
        
        [actionView setFilterName:currentFilter.name];
        actionView.videoFilterTag = [NSNumber numberWithInt:i];
        actionView.delegate = self;
        [_videoFilterActionViewArray addObject:actionView];
        [_videoFilterScrollView addSubview:actionView];
    }
    
    if ([FiltersModel sharedFilters].filters.count>0) {
        _selectedFilter = [FiltersModel sharedFilters].filters[0];
        VideoFilterActionView *actionView = _videoFilterActionViewArray[0];
        [actionView clickMe];
    }
    
    _videoFilterScrollView.backgroundColor = [UIColor colorWithRed:43.0/255.0f green:41.0/255.0f blue:50.0/255.0f alpha:1];
    _selectFrameScrollView.backgroundColor = [UIColor colorWithRed:43.0/255.0f green:41.0/255.0f blue:50.0/255.0f alpha:1];
    [self clickedVideoFilterButton:nil];
    
}

- (void)processMixingWithStatus:(AVAssetExportSessionStatus)status outputURLString:(NSString*)output{
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
    
    if (!filterVideo)
    {
        filter = [[NSClassFromString(FILTER_CLASS_NAME_NO_FRAME) alloc] init];
        if (filter == nil) {
            return;
        }
        [movieFile addTarget:filter];
        GPUImageView *filterView = (GPUImageView *)self.playerView;
        [filter addTarget:filterView];
        [movieFile startProcessing];
    }
    else
    {
        if ([filterVideo.type isEqualToString:FILTER_TYPE_NAME_STATIC])
        {
            filter = [[NSClassFromString(filterVideo.className) alloc] init];
            if (filter == nil) {
                return;
            }
            for (NSString * key in [filterVideo.properties allKeys]) {
                [filter setValue:[filterVideo.properties valueForKey:key] forKey:key];
            }
            [movieFile addTarget:filter];
            GPUImageView *filterView = (GPUImageView *)self.playerView;
            [filter addTarget:filterView];
            [movieFile startProcessing];
        }
        else if ([filterVideo.type isEqualToString:FILTER_TYPE_NAME_DYNAMIC])
        {
            filter = [[NSClassFromString(filterVideo.className) alloc] init];
            if (filter == nil) {
                return;
            }
            
            //TODO: Filter URL;
            NSURL *filterURL = [NSURL fileURLWithPath:[filterVideo localFilterPath]];
            
            filterMovie = [[GPUImageMovie alloc] initWithURL:filterURL];
            
            filterMovie.playAtActualSpeed = YES;
            
            [movieFile addTarget:filter];
            [filterMovie addTarget:filter];
            
            [filter addTarget:_playerView];
            
            [movieFile startProcessing];
            [filterMovie startProcessing];
        }
    }
    [_audioPlayer performSelector:@selector(play) withObject:nil afterDelay:0.1];
}

- (void)keyboardWillShow:(NSNotification*)aNotification
{
    NSDictionary *keyboardInfo = [aNotification userInfo];
    NSValue *keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    if (needShowEnterMessageView) {
        [self showEnterMessageViewWithKeyboardFrame:keyboardFrameBeginRect];
    }
}
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

- (void)processFieldEntries
{
    
}

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

- (void)changeFilter:(Filter *)currentFilter withVideoFilterTag:(NSNumber *)videoFilterTag{
    
    _selectedFilter = currentFilter;
    if (currentFilter) {
        if ([currentFilter.type isEqualToString:FILTER_TYPE_NAME_STATIC])
        {
            [self playVideoWithFilter:currentFilter];
        }
        else if ([currentFilter.type isEqualToString:FILTER_TYPE_NAME_DYNAMIC])
        {
            if ([currentFilter downloadedVideo]) {
                VideoFilterActionView *currentVideoFilterActionView = [_videoFilterActionViewArray objectAtIndex:[videoFilterTag intValue]];
                [currentVideoFilterActionView hideDownloadImageView:YES];
                [self playVideoWithFilter:currentFilter];
            }
            else
            {
                _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [_hud setMode:MBProgressHUDModeAnnularDeterminate];
                _hud.delegate = self;
                _hud.labelText = @"Downloading...";
//                [_hud showWhileExecuting:@selector(processFieldEntries) onTarget:self withObject:nil animated:YES];
                self.view.userInteractionEnabled = NO;
                [currentFilter downloadVideoSuccess:^{
                    VideoFilterActionView *currentVideoFilterActionView = [_videoFilterActionViewArray objectAtIndex:[videoFilterTag intValue]];
                    [currentVideoFilterActionView hideDownloadImageView:YES];
                    [_hud hide:YES];
                    self.view.userInteractionEnabled = YES;
                    [self playVideoWithFilter:currentFilter];
                } failure:^(NSError *error) {
                    [_hud hide:YES];
                    self.view.userInteractionEnabled = YES;
                    UIAlertView *alertDownloadError = [[UIAlertView alloc] initWithTitle:@"Donwload Failed!"
                                                                                 message:@"Can not download this filter"
                                                                                delegate:nil
                                                                       cancelButtonTitle:@"OK"
                                                                       otherButtonTitles:nil ];
                    [self.class showSingleAlert:alertDownloadError];
                } progress:^(CGFloat percent) {
                    //TODO: Show download percent
                    NSLog(@"Current download percent: %f",percent);
                    _hud.progress = percent;
                }];
            }
        }
    }
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

- (void)sendButtonTapped:(UIButton *)sender {
    [self mixVideo];
}

- (void)backButtonTapped:(id)sender {
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
        [self playVideoWithFilter:_selectedFilter];
    }
    
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

- (void)mixVideo{
    if (_audioPlayer) {
        [_audioPlayer stop];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _imvPlay.hidden = YES;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Processing...";
    });
    if ([_selectedFilter.className isEqualToString:FILTER_CLASS_NAME_NO_FRAME]) {
        // No Frame
        [MixEngine mixImage:_imgFrame videoUrl:_exportUrl?_exportUrl:_capturePath completionHandler:^(NSString *output, AVAssetExportSessionStatus status) {
            [self processMixingWithStatus:status outputURLString:output];
        }];
    }
    else if ([_selectedFilter.type isEqualToString:FILTER_TYPE_NAME_DYNAMIC]){
        // Dynamic
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
        //TODO: Change Current Filter
        filter = [[NSClassFromString(_selectedFilter.className) alloc] init];
        if (filter == nil) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            return;
        }
        
        NSURL *filterURL = [NSURL fileURLWithPath:[_selectedFilter localFilterPath]];
        
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
        
        [movieWriter setCompletionBlock:^{
            [filter removeTarget:movieWriter];
            movieFile.audioEncodingTarget = nil;
            [movieWriter finishRecording];
            [MixEngine mixImage:_imgFrame videoUrl:movieURL completionHandler:^(NSString *output, AVAssetExportSessionStatus status) {
                [self processMixingWithStatus:status outputURLString:output];
            }];

        }];
        
        [movieWriter setFailureBlock:^(NSError *error) {
            NSLog(@"%@",error);
            [filter removeTarget:movieWriter];
            movieFile.audioEncodingTarget = nil;
            [movieWriter finishRecording];
            [MixEngine mixImage:_imgFrame videoUrl:movieURL completionHandler:^(NSString *output, AVAssetExportSessionStatus status) {
                [self processMixingWithStatus:status outputURLString:output];
            }];

        }];
        
//        double delayInSeconds = floor(_duration);
//        dispatch_time_t stopTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//        dispatch_after(stopTime, dispatch_get_main_queue(), ^(void){
//            [filter removeTarget:movieWriter];
//            movieFile.audioEncodingTarget = nil;
//            [movieWriter finishRecording];
//            [MixEngine mixImage:_imgFrame videoUrl:movieURL completionHandler:^(NSString *output, AVAssetExportSessionStatus status) {
//                [self processMixingWithStatus:status outputURLString:output];
//            }];
//        });
    }
    else {
        // Static
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
        filter = [[NSClassFromString(_selectedFilter.className) alloc] init];
        
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

        [movieWriter setCompletionBlock:^{
            [filter removeTarget:movieWriter];
            movieFile.audioEncodingTarget = nil;
            [movieWriter finishRecording];
            [MixEngine mixImage:_imgFrame videoUrl:movieURL completionHandler:^(NSString *output, AVAssetExportSessionStatus status) {
                [self processMixingWithStatus:status outputURLString:output];
            }];
            
        }];
        
        [movieWriter setFailureBlock:^(NSError *error) {
            NSLog(@"%@",error);
            [filter removeTarget:movieWriter];
            movieFile.audioEncodingTarget = nil;
            [movieWriter finishRecording];
            [MixEngine mixImage:_imgFrame videoUrl:movieURL completionHandler:^(NSString *output, AVAssetExportSessionStatus status) {
                [self processMixingWithStatus:status outputURLString:output];
            }];
            
        }];
        
//        double delayInSeconds = floor(_duration);
//        dispatch_time_t stopTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//        dispatch_after(stopTime, dispatch_get_main_queue(), ^(void){
//            [filter removeTarget:movieWriter];
//            movieFile.audioEncodingTarget = nil;
//            [movieWriter finishRecording];
//            [MixEngine mixImage:_imgFrame videoUrl:movieURL completionHandler:^(NSString *output, AVAssetExportSessionStatus status) {
//                [self processMixingWithStatus:status outputURLString:output];
//            }];
//        });
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
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [_hud setMode:MBProgressHUDModeAnnularDeterminate];
        _hud.labelText = @"Uploading...";

    });

    
    NSString *latitudeLocal = @"0";
    NSString *longitudeLocal = @"0";
    if (self.shareLocationButton.isSelected) {
        latitudeLocal = [NSString stringWithFormat:@"%f", currentLocation.coordinate.latitude];
        longitudeLocal = [NSString stringWithFormat:@"%f", currentLocation.coordinate.longitude];

    }

    NSLog(@"latitudeLocal %f ",currentLocation.coordinate.latitude);
    NSLog(@"longitudeLocal %f ",currentLocation.coordinate.longitude);
    [MixVideoServices updateMessage:_message?_message:@""
                                key:_mKey
                              frame:@"1"
                               path:_exportUrl
                           latitude:latitudeLocal
                          longitude:longitudeLocal
                       notification:_notificationButton.selected
                           isPublic:self.publicButton.isSelected
                          scheduled:[NSString stringWithFormat:@"%f",[[_scheduleView getSelectedDate] timeIntervalSince1970]]
                          thumbnail:image
                            sussess:^(AFHTTPRequestOperation *operation, id responseObject) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                    [[NSNotificationCenter defaultCenter] postNotificationName:CALL_PUSH_NOTIFICATIONS object:nil];
                                    [self.navigationController popToRootViewControllerAnimated:YES];
                                });
                            }
                            failure:^(NSString *bodyString, NSError *error) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                });
                            _mixed = NO;
                        } progress:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                _hud.progress = (totalBytesWritten*1.0)/(totalBytesExpectedToWrite*1.0);
                                NSLog(@"%f",_hud.progress);
                            });

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
- (IBAction)selectMakePublicButton:(id)sender {
    self.publicButton.selected = !self.publicButton.isSelected;
}
- (IBAction)selectShowLocation:(id)sender {
    self.shareLocationButton.selected = !self.shareLocationButton.isSelected;
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

- (void)didCancelInputMessage{
    
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

#pragma mark - VideoFilterActionView delegate
- (void)didClickFilter:(VideoFilterActionView *)videoFilterActionView
{
    NSLog(@"%s %@",__PRETTY_FUNCTION__,videoFilterActionView.videoFilterTag);
    
    for (VideoFilterActionView * filterAction in _videoFilterActionViewArray) {
        [filterAction showSelectionView:NO];
    }
    [videoFilterActionView showSelectionView:YES];
    
     Filter *currentFilter = [[FiltersModel sharedFilters].filters objectAtIndex:[videoFilterActionView.videoFilterTag intValue]];
    [self changeFilter:currentFilter withVideoFilterTag:videoFilterActionView.videoFilterTag];
}

-(UIColor*)randomColor{
    return [UIColor colorWithRed:((arc4random()%255)*1.0)/255.0 green:((arc4random()%255)*1.0)/255.0 blue:((arc4random()%255)*1.0)/255.0 alpha:1];
}

@end
