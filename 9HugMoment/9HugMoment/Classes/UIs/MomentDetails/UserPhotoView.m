//
//  UserPhotoView.m
//  9HugMoment
//

#import "UserPhotoView.h"

@implementation UserPhotoView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil] objectAtIndex:0];
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_userPhotoImageView.layer setMasksToBounds:YES];
    [_userPhotoImageView.layer setCornerRadius:HALF_OF(_userPhotoImageView.frame.size.width)];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)userPhotoAction:(id)sender {
    //TODO: User did click
}

@end
