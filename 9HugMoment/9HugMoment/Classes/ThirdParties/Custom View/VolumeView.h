//
//  VolumeView.h
//  9hug
//
//  Created by Quang Mai Van on 6/30/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VolumeView;
@protocol VolumeViewDelegate <NSObject>

-(void)volumeView:(VolumeView*)volumeView DidValueChanged:(CGFloat)value;

@end

@interface VolumeView : UIView

@property(nonatomic,weak)id<VolumeViewDelegate>delegate;

-(CGFloat)getVolumeValue;
@end
