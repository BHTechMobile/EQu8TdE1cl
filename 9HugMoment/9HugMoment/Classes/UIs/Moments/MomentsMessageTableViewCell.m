//
//  MomentsMessageTableViewCell.m
//  9HugMoment
//

#import "MomentsMessageTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "ImageCacheObject.h"
#import "MyMomentsModel.h"

@interface MomentsMessageTableViewCell ()

@property (nonatomic,strong) MessageObject *message;

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

- (void)setMessageWithMessage:(MessageObject *)message {
    _message = message;
    
    _userNameLabel.text = message.fullName;
    NSString *numberOfVote = message.totalVotes;
    _numberCountsLabel.text = numberOfVote;
    [_attachment2ImageView sd_setImageWithURL:[NSURL URLWithString:message.attachement2] placeholderImage:[UIImage imageNamed:IMAGE_NAME_ATTACHMENT_2_DEFAULT] options:SDWebImageProgressiveDownload completed:NULL];
    if ([message.location isEqualToString:@""] || !message.location) {
        _locationLabel.text = @"Private";
    }else {
        _locationLabel.text = message.location;
    }
    
    UIImage *userAvatar = [[ImageCacheObject shareImageCache] getImageFromCacheWithKey:message.userFacebookID];
    if (!userAvatar) {
        [BaseServices downloadUserImageWithFacebookID:message.userFacebookID success:^(AFHTTPRequestOperation *operation, id responseObject) {
            _thumbnailImageView.image = responseObject;
            [[ImageCacheObject shareImageCache] setImageToCacheWithImage:responseObject andKey:message.userFacebookID];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error get user image from facebook: %@",error);

        }];
    }else {
        _thumbnailImageView.image = userAvatar;
    }
}

@end
