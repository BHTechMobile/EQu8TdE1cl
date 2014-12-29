//
//  UpvoteMessageTableViewCell.m
//  9HugMoment
//

#import "UpvoteMessageTableViewCell.h"

@implementation UpvoteMessageTableViewCell

- (void)awakeFromNib
{
    _usersFacebookIDArray = [[NSMutableArray alloc] init];
    _avatarCache = [[NSCache alloc] init];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)showUserPhoto {
    [_userVoteScrollView removeAllSubviews];
    if (_usersFacebookIDArray.count > 0) {
        for (int i = 0; i <_usersFacebookIDArray.count; i++) {
            UserPhotoView *userPhotoView = [[UserPhotoView alloc] initWithFrame:CGRectZero];
            CGFloat xOriginUserPhotoView;
            if (i == 0) {
                xOriginUserPhotoView = MARGIN_LEFT_DEFAULT_UP_VOTE_MESSAGE_TABLE_VIEW_CELL;
            }else {
                xOriginUserPhotoView = MARGIN_LEFT_DEFAULT_UP_VOTE_MESSAGE_TABLE_VIEW_CELL + (i * WIDTH_DEFAULT_USER_PHOTO_VIEW) + (i * MARGIN_RIGHT_DEFAULT_USER_PHOTO_VIEW);
            }
            CGRect userPhotoViewFrame = CGRectMake(xOriginUserPhotoView, MARGIN_TOP_DEFAULT_USER_PHOTO_VIEW, WIDTH_DEFAULT_USER_PHOTO_VIEW, HEIGHT_DEFAULT_USER_PHOTO_VIEW);
            userPhotoView.frame = userPhotoViewFrame;
            [_userVoteScrollView addSubview:userPhotoView];
            
            // Avatar
            UIImage *userAvatar = [_avatarCache objectForKey:[_usersFacebookIDArray objectAtIndex:i]];
            if (!userAvatar) {
                [BaseServices downloadUserImageWithFacebookID:[_usersFacebookIDArray objectAtIndex:i] success:^(AFHTTPRequestOperation *operation, id responseObject){
                    userPhotoView.userPhotoImageView.image = responseObject;
                    [_avatarCache setObject:responseObject forKey:[_usersFacebookIDArray objectAtIndex:i]];
                }failure:^(AFHTTPRequestOperation *operation, NSError *error){
                    NSLog(@"Error get user image from facebook: %@",error);
                }];
            }else {
                userPhotoView.userPhotoImageView.image = userAvatar;
            }
        }
        _userVoteScrollView.contentSize = CGSizeMake(MARGIN_LEFT_DEFAULT_UP_VOTE_MESSAGE_TABLE_VIEW_CELL + (_usersFacebookIDArray.count * WIDTH_DEFAULT_USER_PHOTO_VIEW) + (_usersFacebookIDArray.count * MARGIN_RIGHT_DEFAULT_USER_PHOTO_VIEW), _userVoteScrollView.frame.size.height);

    }
}

@end
