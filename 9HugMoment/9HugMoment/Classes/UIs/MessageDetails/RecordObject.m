//
//  RecordObject.m
//  9HugMoment
//

#import "RecordObject.h"

@implementation RecordObject

- (void)showRecordView:(UIView *)recordView withParentView:(UIView *)parentView
{
    _isRecordSuccess = NO;
    [self createRecordTimer];
    CGRect fRecord = recordView.frame;
    [recordView.layer setCornerRadius:5.0f];
    [recordView.layer setMasksToBounds:YES];
    [self vibrate];
    
    fRecord.origin.y = (CGRectGetHeight(parentView.frame) - CGRectGetHeight(recordView.frame))/2;
    [recordView setFrame:fRecord];
    recordView.transform = CGAffineTransformMakeScale(1, 1);
    recordView.alpha = 1;
    recordView.hidden = NO;
    
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        if (granted) {
            [self prepareRecord];
            if (!_audioRecorder.recording) {
                AVAudioSession *session = [AVAudioSession sharedInstance];
                [session setActive:YES error:nil];
                [self.audioRecorder record];
            }
        }
        else {
            [UIAlertView showTitle:@"Microphone Access Denied" message:@"You must allow microphone access in Settings > Privacy > Microphone"];
        }
    }];
}

- (void)hideRecordView:(UIView *)recordView
{
    recordView.alpha = 1;
    [UIView animateWithDuration:TIME_TO_SHOW_HIDE_RECORD_VIEW animations:^{
        recordView.transform = CGAffineTransformMakeScale(1.3, 1.3);
        recordView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self resetRecord];
        if (finished) {
        }
    }];
    _isRecordSuccess = ((floorf)(_audioRecorder.currentTime) >= MIN_TIME_RECORD_TO_POST)?YES:NO;
//    [self resetRecord];
}

- (void)createRecordTimer{
    _recordTimmer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(updateTimeFor) userInfo:nil repeats:YES];
}

- (void)updateTimeFor{
    if (_delegate && [_delegate respondsToSelector:@selector(updateCurrentTimeRecord:withRecorObject:)])
    {
        [_delegate performSelector:@selector(updateCurrentTimeRecord:withRecorObject:) withObject:[Utilities timeFromAudio:(floorf)(_audioRecorder.currentTime)] withObject:self];
    }
}

- (void)vibrate
{
    NSLog(@"Vibrate");
    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
}

- (void)prepareRecord
{
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:[self arrComponent]];
    
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    self.audioRecorder = nil;
    self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:nil];
    self.audioRecorder.delegate = self;
    self.audioRecorder.meteringEnabled = YES;
    [self.audioRecorder prepareToRecord];
}

- (NSArray *)arrComponent{
    NSString *str = [NSString stringWithFormat:RECORD_MESSAGE_SOUNDS_NAME];
    return [NSArray arrayWithObjects:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject], str, nil];
}

- (void)resetRecord
{
    if (_recordTimmer)
    {
        [_recordTimmer invalidate];
        _recordTimmer = nil;
    }
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
    _isRecordSuccess = ((floorf)(_audioRecorder.currentTime) >= MIN_TIME_RECORD_TO_POST)?YES:NO;
}

#pragma mark - AVAudioRecorder delegate

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    _isRecordSuccess = ((floorf)(_audioRecorder.currentTime) >= MIN_TIME_RECORD_TO_POST)?YES:NO;
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error {
    NSLog(@"Encode Error occurred");
    _isRecordSuccess = NO;
}

#pragma mark - Custom Methods

- (void)uploadAudioMessageWithMessageID:(NSString *)messageID completed:(UploadBlock)finished
{
    if (_isRecordSuccess) {
        NSDictionary *dicParam = @{KEY_TOKEN:[[UserData currentAccount] strFacebookToken],
                                   KEY_MESSAGE_ID:messageID,
                                   KEY_TYPE:[NSString stringWithFormat:@"%d",(int)MessageTypeVoice],
                                   KEY_USER_ID:[UserData currentAccount].strId};
        
        [BaseServices uploadAudioWithToken:dicParam
                                      path:URL_RECORD
                                   sussess:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       if (finished) {
                                           finished(responseObject, nil);
                                       }
                                   } failure:^(NSString *bodyString, NSError *error) {
                                       if (finished) {
                                           finished(bodyString ,error);
                                       }
                                   }];
    }
}

@end
