//
//  VideoFilterActionView.h
//  9hug
//
//  Created by Tommy on 10/2/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoFilterActionView;
@protocol VideoFilterActionViewDelegate <NSObject>
@optional
- (void)didClickFilter:(VideoFilterActionView *)videoFilterActionView;

@end

@interface VideoFilterActionView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *filterNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *downloadFilterImageView;
@property (weak, nonatomic) IBOutlet UIButton *filterButton;
@property (weak, nonatomic) id<VideoFilterActionViewDelegate> delegate;
@property (strong, nonatomic) NSNumber *videoFilterTag;

- (IBAction)filterAction:(id)sender;
- (void)hideDownloadImageView;

@end
