//
//  CommentMessageTableViewCell.m
//  9HugMoment
//

#import "CommentMessageTableViewCell.h"

@implementation CommentMessageTableViewCell

- (void)awakeFromNib
{
    [_userCommentImage.layer setMasksToBounds:YES];
    [_userCommentImage.layer setCornerRadius:HALF_OF(_userCommentImage.frame.size.width)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
