//
//  AudioRangerSelectorView.h
//  9hug
//
//  Created by setacinq on 6/30/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AudioRangerSelectorViewDelegate <NSObject>

-(void)audioRangerSelectorViewValueChanged;

@end

@interface AudioRangerSelectorView : UIView

@property(nonatomic,weak)id<AudioRangerSelectorViewDelegate>delegate;

-(void)updateWithDuration:(float)duration;
-(CGFloat)getSecondStartAt;
@property (weak, nonatomic) IBOutlet UIImageView *waveView;

@end
