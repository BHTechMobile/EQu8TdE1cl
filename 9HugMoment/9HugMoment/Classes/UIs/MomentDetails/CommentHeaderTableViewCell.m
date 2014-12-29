//
//  CommentHeaderTableViewCell.m
//  9HugMoment
//

#import "CommentHeaderTableViewCell.h"

@implementation CommentHeaderTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)addCommentButtonAction:(id)sender {
    if (_delegate &&[_delegate respondsToSelector:@selector(didClickAddCommentButton)]) {
        [_delegate performSelector:@selector(didClickAddCommentButton)];
    }
}

@end
