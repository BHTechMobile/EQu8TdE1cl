//
//  UserInfoTableViewCell.m
//  9HugMoment
//

#import "UserInfoTableViewCell.h"

@implementation UserInfoTableViewCell

- (void)awakeFromNib
{
    [_userImageView.layer setMasksToBounds:YES];
    [_userImageView.layer setCornerRadius:HALF_OF(_userImageView.frame.size.width)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
