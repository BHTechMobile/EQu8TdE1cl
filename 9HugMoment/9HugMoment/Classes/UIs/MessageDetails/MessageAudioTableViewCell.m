//
//  MessageAudioTableViewCell.m
//  9HugMoment
//

#import "MessageAudioTableViewCell.h"
#import "MessageDetailsServices.h"

@implementation MessageAudioTableViewCell

#pragma mark - MessageAudioTableViewCell management

- (void)awakeFromNib {
    // Initialization code
    _audioCommentObjectArray = [[NSMutableArray alloc] init];
    _audioDownloadedArray = [[NSMutableArray alloc] init];
    _messageAudioPreviewViewArray = [[NSMutableArray alloc] init];
    [_currentAudioImageView.layer setMasksToBounds:YES];
    [_currentAudioImageView.layer setCornerRadius:HALF_OF(_currentAudioImageView.frame.size.width)];
    isPlayAll = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Actions

- (IBAction)playAudioAction:(id)sender
{
    isPlayAll = NO;
    [self startPlayAudio];
}

- (void)playAllAudioAction{
    isPlayAll = !isPlayAll;
    if (isPlayAll) {
        if (_audioCommentObjectArray.count>0) {
            isPlayAll = YES;
            _currentCommentObject = [_audioCommentObjectArray objectAtIndex:0];
            [self updateCurrentUser];
            [self startPlayAudio];
        }
    }
    else{
        if ([_audioPlayer isPlaying]) {
            [_audioPlayer stop];
        }
        [_playAudioSelectButton setBackgroundImage:[UIImage imageNamed:IMAGE_NAME_ICON_MIX_PLAY] forState:UIControlStateNormal];
        [self updateCurrentUser];
        if (_delegate && [_delegate respondsToSelector:@selector(didStopAudio:)]) {
            [_delegate performSelector:@selector(didStopAudio:) withObject:self];
        }
    }
}

#pragma mark - Custom Methods

- (void)startPlayAudio
{
    if (_currentCommentObject)
    {
        if (_audioPlayer) {
            if ([_audioPlayer isPlaying]) {
                [_audioPlayer pause];
                [_playAudioSelectButton setBackgroundImage:[UIImage imageNamed:IMAGE_NAME_ICON_MIX_PLAY] forState:UIControlStateNormal];
                if (_delegate && [_delegate respondsToSelector:@selector(didStopAudio:)]) {
                    [_delegate performSelector:@selector(didStopAudio:) withObject:self];
                }
            }
            else{
                [self playCurrentAudio];
                [_playAudioSelectButton setBackgroundImage:[UIImage imageNamed:IMAGE_NAME_ICON_MIX_PAUSE] forState:UIControlStateNormal];
                if (isPlayAll) {
                    if (_delegate && [_delegate respondsToSelector:@selector(didPlayAudio:)]) {
                        [_delegate performSelector:@selector(didPlayAudio:) withObject:self];
                    }
                }
            }
        }
    }
}

- (void)showUsersAudio
{
    [_audioScrollView removeAllSubviews];
    [_messageAudioPreviewViewArray removeAllObjects];
    if (((_audioCommentObjectArray != (id)[NSNull null] && [_audioCommentObjectArray isKindOfClass:[NSArray class]])) ) {
        if (_audioCommentObjectArray.count > 0) {
            currentIndexAudioPlay = 0;
            _currentCommentObject = [_audioCommentObjectArray objectAtIndex:currentIndexAudioPlay];
            for (int i = 0; i < _audioCommentObjectArray.count; i++) {
                MessageAudioPreviewView *userPhotoView = [[MessageAudioPreviewView alloc] initWithFrame:CGRectZero];
                CGRect audioPreviewViewFrame = CGRectMake(i * WIGHT_MESSAGE_AUDIO_PREVIEW_VIEW, 0, WIGHT_MESSAGE_AUDIO_PREVIEW_VIEW, HEIGHT_MESSAGE_AUDIO_PREVIEW_VIEW);
                userPhotoView.frame = audioPreviewViewFrame;
                userPhotoView.delegate = self;
                userPhotoView.audioIndex = [NSNumber numberWithInt:i];
                userPhotoView.commentObject = [_audioCommentObjectArray objectAtIndex:i];
                [userPhotoView updateAudioData];
                [_messageAudioPreviewViewArray addObject:userPhotoView];
                [_audioScrollView addSubview:userPhotoView];
            }
            _audioScrollView.contentSize = CGSizeMake((_audioCommentObjectArray.count * WIGHT_MESSAGE_AUDIO_PREVIEW_VIEW), HEIGHT_SCROLL_VIEW_MESSAGE_AUDIO_TABLE_VIEW_CELL);
            [self downloadAudioWithArray:_audioCommentObjectArray];
        }
    }
    
    [self updateCurrentUser];
}

- (void)updateCurrentUser
{
    if (_currentCommentObject) {
        [MessageDetailsModel getUserAvatarWithUserFacebookID:_currentCommentObject.facebookID forImageView:_currentAudioImageView];
        float audioDuration = [self getAudioDurationWithPath:_currentCommentObject.mediaLink];
        _currentAudioTimeLabel.text = [NSString stringWithFormat:@"%@",[Utilities timeFromAudio:audioDuration]];
        _currentAudioUploadTimeLabel.text = [MessageDetailsModel getCurrentDateAudioWithTimeInterval:[_currentCommentObject.sentDate doubleValue]];
        
        [self setUpUrlAudio];
        for (MessageAudioPreviewView *messageAudioPreviewView in _messageAudioPreviewViewArray)
        {
            if ([messageAudioPreviewView.commentObject.commentID isEqualToString:_currentCommentObject.commentID])
            {
                messageAudioPreviewView.currentAudioSelectView.hidden = NO;
                currentIndexAudioPlay = [messageAudioPreviewView.audioIndex intValue];
                [_audioScrollView scrollRectToVisible:messageAudioPreviewView.frame animated:YES];
            }
            else
            {
                messageAudioPreviewView.currentAudioSelectView.hidden = YES;
            }
        }
    }
}


- (UIView *)drawCircleViewWithFrame:(CGRect)rect
{
    UIView *circleView = [[UIView alloc] initWithFrame:rect];
    [circleView.layer setMasksToBounds:YES];
    [circleView.layer setCornerRadius:HALF_OF(rect.size.width)];
    return circleView;
}

#pragma mark - Audio Management

- (void)downloadAudioWithArray:(NSArray *)audioArray
{
    if (!_audioDownloadedArray) {
        _audioDownloadedArray = [[NSMutableArray alloc] init];
    }
    [_audioDownloadedArray removeAllObjects];
    for (CommentObject *commentObject in audioArray) {
        [_audioDownloadedArray addObject:commentObject.mediaLink];
        NSString* fileName = [NSString stringWithFormat:@"Documents/%@",[[commentObject.mediaLink pathComponents] lastObject]];
        NSString *urlOutPut = [NSHomeDirectory() stringByAppendingPathComponent:fileName];
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:urlOutPut];
        if (fileExists) {
            [self calculateTotalDuration];
        }else{
            [MessageDetailsServices downloadAudio:commentObject.mediaLink
                                sussess:^(AFHTTPRequestOperation *operation, id responseObject) {
                [self updateCurrentUser];
                [self calculateTotalDuration];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            } progress:^(float progress) {
                NSLog(@"downoad %lf",progress);
            }];
        }
    }
}

- (void)calculateTotalDuration{
    float totalDuraion = 0;
    for (NSString *strPathAudio in _audioDownloadedArray) {
        totalDuraion += [self getAudioDurationWithPath:strPathAudio];
    }
    _audioTotalTimeLabel.text = [NSString stringWithFormat:@"%@",[Utilities timeFromAudio:totalDuraion]];
}

- (float)getAudioDurationWithPath:(NSString *)audioPath
{
    NSArray *parts = [audioPath componentsSeparatedByString:@"/"];
    NSString* fileName = [NSString stringWithFormat:@"Documents/%@",[parts objectAtIndex:[parts count]-1]];
    NSString *urlOutPut = [NSHomeDirectory() stringByAppendingPathComponent:fileName];
    AVAudioPlayer *audioTemp =  [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:urlOutPut]
                                                                       error:nil];
    return audioTemp.duration;
}

- (void)setUpUrlAudio{
    if (_currentCommentObject.mediaLink != (id)[NSNull null] && ![_currentCommentObject.mediaLink isEqualToString: @""])
    {
        NSString* fileName = [NSString stringWithFormat:@"Documents/%@",[[_currentCommentObject.mediaLink pathComponents] lastObject]];
        NSLog(@"file name = %@",fileName);
        NSString *urlOutPut = [NSHomeDirectory() stringByAppendingPathComponent:fileName];
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:urlOutPut];
        if (fileExists) {
            _audioPlayer = nil;
            NSError *err;
            _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:urlOutPut]
                                                                 error:nil];
            if (err)
            {
                NSLog(@"Error in audioPlayer: %@",
                      [err localizedDescription]);
            } else {
                _audioPlayer.delegate = self;
                [_audioPlayer prepareToPlay];
                [self createPlayerTimer];
            }
        }
    }
}

- (void)playCurrentAudio{
    [self createPlayerTimer];
    [_audioPlayer play];
}

- (void)createPlayerTimer{
    playTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(tick) userInfo:nil repeats:YES];
}

-(void)tick{
    [self setFrameCurrentAudio:(_audioPlayer.currentTime*1.0)/(1.0*_audioPlayer.duration)*CGRectGetWidth(self.audioProcessView.frame)];
    _currentAudioTimeRunLabel.text = [Utilities timeFromAudio:_audioPlayer.currentTime];
    
}

- (void)setFrameCurrentAudio :(float)with{
    CGRect frame = self.audioProcessCurrentView.frame;
    frame.size.width = with;
    frame.origin.x = 0;
    [self.audioProcessCurrentView setFrame:frame];
}

#pragma mark - AVAudioPlayer delegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [self setFrameCurrentAudio:0];
    [_currentAudioTimeRunLabel setText:@""];
    if (playTimer) {
        [playTimer invalidate];
        playTimer = nil;
    }
    
    if (isPlayAll) {
        currentIndexAudioPlay++;
        if (currentIndexAudioPlay < _audioCommentObjectArray.count) {
            _currentCommentObject = [_audioCommentObjectArray objectAtIndex:currentIndexAudioPlay];
            [self updateCurrentUser];
            [self startPlayAudio];
        }
        else {
            [_playAudioSelectButton setBackgroundImage:[UIImage imageNamed:IMAGE_NAME_ICON_MIX_PLAY] forState:UIControlStateNormal];
            if (_delegate && [_delegate respondsToSelector:@selector(didStopAudio:)]) {
                [_delegate performSelector:@selector(didStopAudio:) withObject:self];
            }
        }
    }
    else{
        [_playAudioSelectButton setBackgroundImage:[UIImage imageNamed:IMAGE_NAME_ICON_MIX_PLAY] forState:UIControlStateNormal];
        if (_delegate && [_delegate respondsToSelector:@selector(didStopAudio:)]) {
            [_delegate performSelector:@selector(didStopAudio:) withObject:self];
        }
    }
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    [self setFrameCurrentAudio:0];
    
    if (playTimer) {
        [playTimer invalidate];
        playTimer = nil;
    }
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player{
    [self setFrameCurrentAudio:0];
    if (playTimer) {
        [playTimer invalidate];
        playTimer = nil;
    }
}

#pragma mark - MessageAudioPreviewView delegate
- (void)didClickPreviewUserButton:(MessageAudioPreviewView *)messageAudioPreviewView
{
    isPlayAll = NO;
    [_playAudioSelectButton setBackgroundImage:[UIImage imageNamed:IMAGE_NAME_ICON_MIX_PLAY] forState:UIControlStateNormal];
    if (_delegate && [_delegate respondsToSelector:@selector(didStopAudio:)]) {
        [_delegate performSelector:@selector(didStopAudio:) withObject:self];
    }
    _currentCommentObject = [_audioCommentObjectArray objectAtIndex:[messageAudioPreviewView.audioIndex integerValue]];
    [self updateCurrentUser];
}

@end
