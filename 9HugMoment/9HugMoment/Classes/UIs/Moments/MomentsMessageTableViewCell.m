//
//  MomentsMessageTableViewCell.m
//  9HugMoment
//

#import "MomentsMessageTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MyMomentsModel.h"
#import <SDWebImage/SDImageCache.h>

@interface MomentsMessageTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *voteButton;
@property (weak, nonatomic) IBOutlet UIImageView *statusVoteImageView;

@end

@implementation MomentsMessageTableViewCell

#pragma mark - MomentsMessageTableViewCell management

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self = [[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil] objectAtIndex:0];
        [_thumbnailImageView.layer setMasksToBounds:YES];
        [_thumbnailImageView.layer setCornerRadius:HALF_OF(_thumbnailImageView.frame.size.width)];
;
    }
    return self;
}

#pragma mark - Actions

- (IBAction)voteAction:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(didClickVote:withMessage:)]) {
        [_delegate performSelector:@selector(didClickVote:withMessage:) withObject:self withObject:_message];
    }
}

#pragma mark - Custom Methods

- (void)setMessageWithMessage:(MessageObject *)message {
    _message = message;
    _userNameLabel.text = message.fullName;
    NSString *numberOfVote = message.totalVotes;
    _numberCountsLabel.text = numberOfVote;
    self.statusVoteImageView.image = ([message isUserVotedMessage])?[UIImage imageNamed:IMAGE_NAME_ICON_CARET_RED]:[UIImage imageNamed:IMAGE_NAME_ICON_CARET_GRAY];
    
    //location
    if ([message.location isEqualToString:@""] || !message.location) {
        _locationLabel.text = @"Private";
    }else {
        _locationLabel.text = message.location;
    }
    
    //user avatar
    _thumbnailImageView.image = nil;
    NSString * avatarURLString = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square",message.userFacebookID];
    
    UIImage *userAvatar = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:avatarURLString];
    if (userAvatar) {
        NSLog(@"Cached avatar");
        _thumbnailImageView.image = userAvatar;
    }
    else{
        NSLog(@"Download avatar");
        NSURL *imageURL = [NSURL URLWithString:avatarURLString];
        [_thumbnailImageView sd_setImageWithURL:imageURL placeholderImage:nil options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                [[SDImageCache sharedImageCache] storeImage:image forKey:avatarURLString];
            }
        }];
    }
    
    //attachment2
    
    NSString * attachement2URLString = message.attachement2;
    _attachment2ImageView.image = nil;
    UIImage *attachment2 = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:attachement2URLString];
    
    if (attachment2) {
        NSLog(@"Cached attachment2");
        _attachment2ImageView.image = attachment2;
    }
    else{
        NSLog(@"Download attachment2");

        NSURL *imageURL = [NSURL URLWithString:attachement2URLString];
        [_attachment2ImageView sd_setImageWithURL:imageURL placeholderImage:nil options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                [[SDImageCache sharedImageCache] storeImage:image forKey:attachement2URLString];
            }
        }];
    }
}

@end
