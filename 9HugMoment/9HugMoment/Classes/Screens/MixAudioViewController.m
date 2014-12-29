//
//  MixAudioViewController.m
//  9HugMoment
//
//  Created by Tommy on 11/24/14.
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import "MixAudioViewController.h"
#import "AudioRangerSelectorView.h"

@interface MixAudioViewController ()

@end

@implementation MixAudioViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createUI
{
    _rangeSelectorView = [AudioRangerSelectorView fromNib];
    _rangeSelectorView.delegate = self;
    [_groupView addSubview:_rangeSelectorView];
    [_rangeSelectorView updateWithDuration:[[NSString stringWithFormat:@"%@", [_audioItem valueForProperty: MPMediaItemPropertyPlaybackDuration]] floatValue]];
    [_rangeSelectorView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:40];
    [_rangeSelectorView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:40];
    [_rangeSelectorView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:40];
    [_rangeSelectorView autoSetDimension:ALDimensionHeight toSize:_rangeSelectorView.frame.size.height];
    
    _audioVolume = [VolumeView fromNib];
    _audioVolume.delegate =self;
    [_groupView addSubview:_audioVolume];
    [_audioVolume autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:20];
    [_audioVolume autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [_audioVolume autoSetDimensionsToSize:CGSizeMake(84, 112)];
    
    _videoVolume = [VolumeView fromNib];
    _videoVolume.delegate = self;
    [_groupView addSubview:_videoVolume];
    [_videoVolume autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:20];
    [_videoVolume autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [_videoVolume autoSetDimensionsToSize:CGSizeMake(84, 112)];
    
    //        [self.view bringSubviewToFront:_bottomView];
    //        [_groupView bringSubviewToFront:_doneButton];
    _videoPlayer = [PlayerView fromNib];
    
    if (IS_IPHONE_4) {
        [_videoPlayer setFrame:CGRectMake(0, 0, 240, 240)];
    }else if (IS_IPHONE_5){
        [_videoPlayer setFrame:CGRectMake(0, 0, 240, 240)];
    }else if (IS_IPHONE_6){
        [_videoPlayer setFrame:CGRectMake(0, 0, 295, 295)];
    }else if (IS_IPHONE_6_PLUS){
        [_videoPlayer setFrame:CGRectMake(0, 0, 334, 334)];
    }
    
//    [_videoPlayer setFrame:CGRectMake(0, 0, CGRectGetWidth(self.playerView.frame), CGRectGetHeight(self.playerView.frame))];
    
    [_playerView insertSubview:_videoPlayer atIndex:0];
    [_videoPlayer preparePlayWithUrl:_capturePath];
    _songNamelabel.text = [_audioItem valueForProperty:MPMediaItemPropertyTitle];
    _mixButtonTapped.hidden = NO;
    
}

-(void)audioRangerSelectorViewValueChanged
{
    [_videoPlayer pause];
    
    _mixButtonTapped.hidden = NO;
}

-(void)volumeView:(VolumeView *)volumeView DidValueChanged:(CGFloat)value
{
    [_videoPlayer pause];
    _mixButtonTapped.hidden = NO;
}


- (IBAction)doneButtonTapped:(id)sender {
    
    [_videoPlayer pause];
    
    if (_exportUrl) {
        if (_delegate && [_delegate respondsToSelector:@selector(mixAudioViewController:didMixVideoUrl:)]) {
            [_delegate mixAudioViewController:self didMixVideoUrl:_exportUrl];
        }
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [MixEngine mixAudio:[_audioItem valueForProperty:MPMediaItemPropertyAssetURL]
                 volume:[_audioVolume getVolumeValue]
          startAtSecond:[_rangeSelectorView getSecondStartAt]
               videoUrl:_capturePath
                 volume:[_videoVolume getVolumeValue]
      completionHandler:^(NSString *output, AVAssetExportSessionStatus status) {
          dispatch_async(dispatch_get_main_queue(), ^{
              [MBProgressHUD hideHUDForView:self.view animated:YES];
          });
          switch (status){
              case AVAssetExportSessionStatusFailed:
              {
                  
                  break;
              }
              case AVAssetExportSessionStatusCompleted:
              {
                  _exportUrl = [NSURL URLWithString:output];
                  if (_delegate && [_delegate respondsToSelector:@selector(mixAudioViewController:didMixVideoUrl:)]) {
                      [_delegate mixAudioViewController:self didMixVideoUrl:_exportUrl];
                  }
                  
                  break;
              }
          }
      }];
}

- (IBAction)addMusicButtonTapped:(id)sender {
    MPMediaPickerController *picker =
    [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeMusic];
    picker.delegate						= self;
    picker.allowsPickingMultipleItems	= NO;
    //    picker.prompt						= NSLocalizedString (@"Add song", "Prompt in media item picker");
    picker.navigationController.navigationBarHidden = YES;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)mixButtonTapped:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [MixEngine mixAudio:[_audioItem valueForProperty:MPMediaItemPropertyAssetURL]
                 volume:[_audioVolume getVolumeValue]
          startAtSecond:[_rangeSelectorView getSecondStartAt]
               videoUrl:_capturePath
                 volume:[_videoVolume getVolumeValue]
      completionHandler:^(NSString *output, AVAssetExportSessionStatus status) {
          
          [MBProgressHUD hideHUDForView:self.view animated:YES];
          switch (status)
          {
              case AVAssetExportSessionStatusFailed:
              {
                  
                  break;
              }
              case AVAssetExportSessionStatusCompleted:
              {
                  _mixButtonTapped.hidden = YES;
                  _exportUrl = [NSURL URLWithString:output];
                  dispatch_async(dispatch_get_main_queue(), ^{
                      
                      [_videoPlayer playWithUrl:_exportUrl];
                  });
                  
                  break;
              }
          }
      }];
}

- (IBAction)cancelButtonTapped:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(mixAudioViewControllerDidCancel)]) {
        [_videoPlayer pause];
        [_delegate mixAudioViewControllerDidCancel];
    }
}

#pragma mark Media item picker delegate methods________

- (void) mediaPicker: (MPMediaPickerController *) mediaPicker didPickMediaItems: (MPMediaItemCollection *) mediaItemCollection {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleDefault animated: YES];
    
    if ([[mediaItemCollection items] count] == 0) {
        return;
    }
    
    MPMediaItem* audioItem = [[mediaItemCollection items] objectAtIndex:0];
    
    if (!audioItem || ![audioItem valueForProperty:MPMediaItemPropertyAssetURL]) {
        [UIAlertView showMessage:@"invalid"];
        return;
    }
    
    _audioItem = audioItem;
    
    _songNamelabel.text = [_audioItem valueForProperty:MPMediaItemPropertyTitle];
    
    [_rangeSelectorView updateWithDuration:[[NSString stringWithFormat:@"%@", [_audioItem valueForProperty: MPMediaItemPropertyPlaybackDuration]] floatValue]];
    
    [_videoPlayer pause];
    
    _mixButtonTapped.hidden = NO;
}

// Invoked when the user taps the Done button in the media item picker having chosen zero
//		media items to play
- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker {
    [self dismissViewControllerAnimated:YES completion:nil];
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleDefault animated: YES];
}


@end
