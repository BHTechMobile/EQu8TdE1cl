//
//  MomentsMessageTableViewCell.m
//  9HugMoment
//

#import "MomentsMessageTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MyMomentsModel.h"
#import <SDWebImage/SDImageCache.h>
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
    NSLog(@"%s %@",__PRETTY_FUNCTION__,message.messageID);
    _message = message;
    
    _userNameLabel.text = message.fullName;
    NSString *numberOfVote = message.totalVotes;
    _numberCountsLabel.text = numberOfVote;

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
        [[SDWebImageManager sharedManager] downloadImageWithURL:imageURL options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize){
        }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL){
            if (!error) {
                if (image) {
                    [[SDImageCache sharedImageCache] storeImage:image forKey:avatarURLString];
                
                    dispatch_async(dispatch_get_main_queue(), ^{
                        _thumbnailImageView.image = image;
                    });
                }
            }
            else {
                NSLog(@"%@",error.localizedDescription);
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
        [[SDWebImageManager sharedManager] downloadImageWithURL:imageURL options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize){
        }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL){
            if (!error) {
                if (image) {
                    [[SDImageCache sharedImageCache] storeImage:image forKey:attachement2URLString];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        _attachment2ImageView.image = image;
                    });
                }
            }
            else {
                NSLog(@"%@",error.localizedDescription);
            }
        }];
    }
    
}

@end
