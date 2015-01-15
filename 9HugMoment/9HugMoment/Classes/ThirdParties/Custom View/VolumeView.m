//
//  VolumeView.m
//  9hug
//
//  Created by Quang Mai Van on 6/30/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "VolumeView.h"

@interface VolumeView ()

@property (weak, nonatomic) IBOutlet UIView *activeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpace;
@end

@implementation VolumeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [self addGestureRecognizer:panRecognizer];
}

-(void)move:(UIPanGestureRecognizer *)recognizer {
    if( ([recognizer state] == UIGestureRecognizerStateBegan) || ([recognizer state] == UIGestureRecognizerStateChanged)){
        CGPoint movement = [recognizer translationInView:self];

        NSLog(@"Move: %f %f",movement.x,movement.y);
        CGRect old_rect = _activeView.frame;
        
        old_rect.origin.y = old_rect.origin.y + movement.y;
        
        if (old_rect.origin.y <= 0) {
            old_rect.origin.y = 0;
        }
        
        if (old_rect.origin.y >= self.frame.size.height) {
            old_rect.origin.y = self.frame.size.height;
        }
        
        [_topSpace setConstant:old_rect.origin.y];
        [recognizer setTranslation:CGPointZero inView:self];
    }
    else if(recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled){

        [self getVolumeValue];

        if (_delegate && [_delegate respondsToSelector:@selector(volumeView:DidValueChanged:)]) {
            [_delegate volumeView:self DidValueChanged:[self getVolumeValue]];
        }
    }
}

-(CGFloat)getVolumeValue
{
    NSLog(@"%s %f %f",__PRETTY_FUNCTION__,_topSpace.constant,self.frame.size.height);
    if (_topSpace.constant>84.0f) {
        return 0.0f;
    }
    else{
        return 1.0 - _topSpace.constant/84.0f;
    }
}
@end
