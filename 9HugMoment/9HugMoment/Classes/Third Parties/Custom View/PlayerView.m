//
//  VideoPlayerView.m
//  9hug
//
//  Created by Quang Mai Van on 6/24/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "PlayerView.h"
#import "VideoPlayerKit.h"

@interface PlayerView ()<VideoPlayerDelegate>

@property (nonatomic, strong) VideoPlayerKit *videoPlayerKit;
@property (nonatomic, strong) NSURL *videoUrl;


- (IBAction)tap:(id)sender;
@end

@implementation PlayerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _videoPlayerKit.allowPortraitFullscreen = NO;
        _videoPlayerKit.showStaticEndTime = NO;
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
}

-(void)createUI
{
    
    [self createVideoPlayer];

}

-(void)createVideoPlayer
{
    _videoPlayerKit.allowPortraitFullscreen = NO;
    _videoPlayerKit.showStaticEndTime = NO;
    if (!_videoPlayerKit) {
        _videoPlayerKit = [VideoPlayerKit videoPlayerWithContainingViewController:nil optionalTopView:nil hideTopViewWithControls:YES];
        _videoPlayerKit.view.backgroundColor = [UIColor blackColor];
        _videoPlayerKit.delegate = self;
        _videoPlayerKit.allowPortraitFullscreen = NO;
        _videoPlayerKit.showStaticEndTime = NO;
        _videoPlayerKit.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
//        _videoPlayerKit.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.viewControl.frame), CGRectGetHeight(self.viewControl.frame));
        [self insertSubview:_videoPlayerKit.view atIndex:0];
        _playImageView = [[UIImageView alloc]initWithFrame:_videoPlayerKit.view.frame];
        [_playImageView setImage:[UIImage imageNamed:@"btn_play_hover_white"]];
        [self insertSubview:_playImageView aboveSubview:_videoPlayerKit.view];
    }
}

-(void)preparePlayWithUrl:(NSURL*)url
{
    _videoPlayerKit.allowPortraitFullscreen = NO;
    _videoPlayerKit.showStaticEndTime = NO;
    
    _videoUrl = url;

//    [self createUI];
    [self createVideoPlayer];
    
//    [_videoPlayerKit playVideoWithTitle:@""
//                                    URL:_videoUrl
//                                videoID:nil
//                               shareURL:nil
//                            isStreaming:NO
//                       playInFullScreen:NO];
    [_videoPlayerKit playVideoWithTitle:@""
                                    URL:_videoUrl
                                videoID:nil
                            isStreaming:NO
                       playInFullScreen:NO];
    
    //    _playImageView.hidden = YES;
    
}

-(void)playWithUrl:(NSURL*)url
{
    [self preparePlayWithUrl:url];
    [self tap:nil];
}

- (IBAction)tap:(id)sender
{
    _playImageView.hidden = ![_videoPlayerKit isPlaying];
    [_videoPlayerKit playPauseHandler];
}

-(void)pause
{
    if ([_videoPlayerKit isPlaying]) {
        [_videoPlayerKit playPauseHandler];
        _playImageView.hidden = NO;
    }
}

-(BOOL)isPlaying
{
    return [_videoPlayerKit isPlaying];
}

-(void)trackEvent:(NSString *)event videoID:(NSString *)videoID title:(NSString *)title
{
    if ([event isEqualToString:kTrackEventVideoComplete]) {
        _playImageView.hidden = NO;
    }
}
@end
