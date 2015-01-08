//
//  MixVideoViewController.h
//  9HugMoment
//
//  Created by Tommy on 11/24/14.
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationView.h"
#import "MixAudioViewController.h"
#import "ScheduleView.h"
#import "MixVideoServices.h"
#import "EnterMessageView.h"
#import "Frame.h"
#import "FramesModel.h"

@interface MixVideoViewController : UIViewController<MPMediaPickerControllerDelegate,UIAlertViewDelegate,AVAudioPlayerDelegate,GPUImageMovieDelegate,NavigationCustomViewDelegate,MixAudioViewControllerDelegate,CLLocationManagerDelegate, EnterMessageDelegate>{
    NSMutableArray *_changeFrameButtons;
    NSArray *qrCode;
    GPUImageMovie *movieFile;
    GPUImageMovie *filterMovie;
    GPUImageOutput<GPUImageInput> *filter;
    GPUImageMovieWriter *movieWriter;
    AVAudioPlayer * _audioPlayer;
    BOOL _isPlaying;
    NSString *_currentFilterClassString;
    NavigationView *_navigationView;
    
    CLLocation *currentLocation;
    BOOL needShowEnterMessageView;
}

@property (weak, nonatomic) IBOutlet UIButton *touchPublicVideoButton;
@property (weak, nonatomic) IBOutlet UIView *navigationCustomView;
@property (strong, nonatomic) IBOutlet GPUImageView *playerView;
@property (weak, nonatomic) IBOutlet UIImageView *imvFrame;
@property (weak, nonatomic) IBOutlet UIScrollView *selectFrameScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *videoFilterScrollView;
@property (weak, nonatomic) IBOutlet UIButton *btnPlay;
@property (weak, nonatomic) IBOutlet UIImageView *imvPlay;
@property (weak, nonatomic) IBOutlet UIButton *btnFrames;
@property (weak, nonatomic) IBOutlet UIButton *btnVideoFilters;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *hightImageViewOffsetConstraint;
@property (weak, nonatomic) IBOutlet UIView *contentMixView;

// Utilities
@property (weak, nonatomic) IBOutlet UIButton *calendatButton;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;
@property (weak, nonatomic) IBOutlet UIButton *frameInputButton;
@property (weak, nonatomic) IBOutlet UIButton *notificationButton;
@property (weak, nonatomic) IBOutlet UIButton *tagButton;

@property (nonatomic, assign) CLLocationCoordinate2D currenLocations;
@property (strong, nonatomic) LocationManagement *locationManagement;
@property (nonatomic, strong) NSURL *capturePath;
@property (nonatomic, strong) UIImage* imgFrame;
@property (nonatomic, assign) NSInteger indexFrame;
@property (nonatomic) CGFloat duration;
@property (nonatomic, strong) NSString* mKey;

@property (nonatomic, strong) NSString *tokenAuto;
@property (nonatomic, strong) MPMediaItem* audioItem;
@property (nonatomic, strong) NSURL* exportUrl;
@property (nonatomic, assign) BOOL mixed;
@property (nonatomic, strong) NSString* message;
@property (nonatomic, weak) NSLayoutConstraint *topPosition;
@property (nonatomic, strong) NSDictionary *postParams;
@property (weak, nonatomic) ScheduleView *scheduleView;
@property (weak, nonatomic) EnterMessageView *enterMessageView;

- (IBAction)publicVideoButtonAction:(id)sender;
- (IBAction)calendarAction:(id)sender;
- (IBAction)messageAction:(id)sender;
- (IBAction)frameInputAction:(id)sender;
- (IBAction)notificationAction:(id)sender;
- (IBAction)tagAction:(id)sender;

-(void)locationManager: (CLLocationManager *)manager didChangeAuthorizationStatus: (CLAuthorizationStatus)status;

@end
