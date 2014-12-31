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

@interface MixVideoViewController : UIViewController<MPMediaPickerControllerDelegate,UIAlertViewDelegate,AVAudioPlayerDelegate,GPUImageMovieDelegate,NavigationCustomViewDelegate,MixAudioViewControllerDelegate,CLLocationManagerDelegate>{
    NSArray * changeFrameButtons;
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
}
-(void)locationManager: (CLLocationManager *)manager didChangeAuthorizationStatus: (CLAuthorizationStatus)status;

@property (nonatomic, assign) CLLocationCoordinate2D currenLocations;
@property (strong, nonatomic) LocationManagement *locationManagement;
@property (nonatomic, strong) NSURL *capturePath;
@property (nonatomic, strong) UIImage* imgFrame;
@property (nonatomic, assign) NSInteger indexFrame;
@property (nonatomic) CGFloat duration;
@property (nonatomic, strong) NSString* mKey;

@end
