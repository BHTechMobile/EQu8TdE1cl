//
//  FriendHeaderView.m
//  9HugMoment
//

#import "FriendHeaderView.h"

@implementation FriendHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil] objectAtIndex:0];
    return self;
}

- (void)layoutSubviews
{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
