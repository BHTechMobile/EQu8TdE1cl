//
//  FriendTableViewCell.m
//  9HugMoment
//

#import "FriendTableViewCell.h"

@implementation FriendTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [_userImageView.layer setMasksToBounds:YES];
    [_userImageView.layer setCornerRadius:HALF_OF(_userImageView.frame.size.width)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
