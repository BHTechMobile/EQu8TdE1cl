//
//  DownloadVideoView.h
//  9hug
//
//  Created by Quang Mai Van on 6/29/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageObject.h"

@class DownloadVideoView;
@protocol DownloadVideoDelegate <NSObject>
@optional
- (void)downloadVideoSuccess:(MessageObject *)message;
- (void)downloadVideoFailure:(MessageObject *)message;
@end

@interface DownloadVideoView : UIView

@property(nonatomic,weak)id<DownloadVideoDelegate>delegate;

- (void)downloadVideoByMessage:(MessageObject *)message;
- (void)setFrameDownloadVideo:(UIView *)ctView;
+(DownloadVideoView*)downloadVideoViewWithDelegate:(id)delgate;

@end
