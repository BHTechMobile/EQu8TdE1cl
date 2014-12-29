//
//  VideoPlayerView.h
//  9hug
//
//  Created by Quang Mai Van on 6/24/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerView : UIView{
     UIImageView *_playImageView;
}
@property (weak, nonatomic) IBOutlet UIControl *viewControl;

-(void)preparePlayWithUrl:(NSURL*)url;
-(void)playWithUrl:(NSURL*)url;

-(void)pause;
-(BOOL)isPlaying;
@end
