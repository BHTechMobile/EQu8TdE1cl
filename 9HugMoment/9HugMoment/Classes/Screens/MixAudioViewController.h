//
//  MixAudioViewController.h
//  9HugMoment
//
//  Created by Tommy on 11/24/14.
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "AudioRangerSelectorView.h"
#import "PlayerView.h"
#import "MixEngine.h"
#import "VolumeView.h"

@class MixAudioViewController;
@protocol MixAudioViewControllerDelegate <NSObject>

-(void)mixAudioViewControllerDidCancel;
-(void)mixAudioViewController:(MixAudioViewController*)setupViewController didMixVideoUrl:(NSURL*)mixUrl;

@end

@interface MixAudioViewController : UIViewController<MPMediaPickerControllerDelegate,AudioRangerSelectorViewDelegate,VolumeViewDelegate>

@property(nonatomic,weak)id<MixAudioViewControllerDelegate>delegate;

@property(nonatomic,strong) MPMediaItem* audioItem;
@property(nonatomic,strong) NSURL* capturePath;
@property (weak, nonatomic) IBOutlet UIView *groupView;

@property(nonatomic, strong) IBOutlet AudioRangerSelectorView* rangeSelectorView;
@property(nonatomic, strong) PlayerView* videoPlayer;
@property(nonatomic, strong) NSURL* exportUrl;
@property(nonatomic, strong) IBOutlet VolumeView* audioVolume;
@property(nonatomic, strong) IBOutlet VolumeView* videoVolume;

@property (weak, nonatomic) IBOutlet UIView *playerView;
@property (weak, nonatomic) IBOutlet UILabel *songNamelabel;
@property (weak, nonatomic) IBOutlet UIButton *mixButtonTapped;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

- (IBAction)doneButtonTapped:(id)sender;
- (IBAction)addMusicButtonTapped:(id)sender;
- (IBAction)mixButtonTapped:(id)sender;
- (IBAction)cancelButtonTapped:(id)sender;

@end
