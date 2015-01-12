//
//  VideoFilterActionView.m
//  9hug
//
//  Created by Tommy on 10/2/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "VideoFilterActionView.h"

@implementation VideoFilterActionView

- (void)awakeFromNib{
    [super awakeFromNib];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - Custom Methods

- (void)hideDownloadImageView
{
    UIView *parentFilterView = self.superview;
    [self removeFromSuperview];
    self.downloadFilterImageView.hidden = YES;
    [parentFilterView addSubview:self];
}

#pragma mark - Actions

- (IBAction)filterAction:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(didClickFilter:)]) {
        [_delegate performSelector:@selector(didClickFilter:) withObject:self];
    }
}

@end
