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

- (IBAction)voteButtonAction:(id)sender {
    int numberOfVote;
    @try {
        numberOfVote = [_voteNumberLabel.text intValue];
        if (_isUserVoted) {
            // Minus
            if (numberOfVote > 0) {
                numberOfVote--;
            }
            _isUserVoted = NO;
        }
        else {
            // Plus
            numberOfVote++;
            _isUserVoted = YES;
        }
    }
    @catch (NSException *exception) {
        numberOfVote = 0;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(didUserClickVoteButton:)]) {
        [_delegate performSelector:@selector(didUserClickVoteButton:) withObject:self];
    }
}

@end
