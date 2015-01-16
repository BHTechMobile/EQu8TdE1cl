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

@property (weak, nonatomic) id<VideoFilterActionViewDelegate> delegate;

@property (strong, nonatomic) NSNumber *videoFilterTag;

- (void)setFilterName:(NSString *)filterName;
- (void)setThumbnailImage:(UIImage *)thumbnailImage;
- (void)hideDownloadImageView:(BOOL)yesOrNo;
- (void)showSelectionView:(BOOL)yesOrNo;

- (void)clickMe;

@end
