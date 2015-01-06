//
//  RecordView.m
//  9HugMoment
//

#import "RecordView.h"

@implementation RecordView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil] objectAtIndex:0];
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

@end
