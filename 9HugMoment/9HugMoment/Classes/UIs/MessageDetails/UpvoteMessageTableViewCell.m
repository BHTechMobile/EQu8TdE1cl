//
//  UpvoteMessageTableViewCell.m
//  9HugMoment
//

#import "UpvoteMessageTableViewCell.h"
#import "MessageDetailsServices.h"

@implementation UpvoteMessageTableViewCell

- (void)awakeFromNib
{
    _usersFacebookIDArray = [[NSMutableArray alloc] init];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)showUserPhoto {
    [_userVoteScrollView removeAllSubviews];
    if (_usersFacebookIDArray.count > 0) {
        NSArray *usersFacebookIDSortedArray = _usersFacebookIDArray;
        if (_usersFacebookIDArray.count > 1) {
            usersFacebookIDSortedArray = [_usersFacebookIDArray sortedArrayUsingComparator:^(NSMutableDictionary *obj1,NSMutableDictionary *obj2) {
                NSString *num1 = [NSString stringWithFormat:@"%d",[(NSNumber *)[obj1 objectForKey:KEY_SENT_DATE_2] intValue]];
                NSString *num2 = [NSString stringWithFormat:@"%d",[(NSNumber *)[obj2 objectForKey:KEY_SENT_DATE_2] intValue]];
                return (NSComparisonResult) [num2 compare:num1 options:(NSNumericSearch)];
            }];
        }
        
        for (int i = 0; i <usersFacebookIDSortedArray.count; i++) {
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
            NSDictionary *currentDict = [usersFacebookIDSortedArray objectAtIndex:i];
            UIImage *userAvatar = [[ImageCacheObject shareImageCache].imageCache objectForKey:[currentDict objectForKey:KEY_FACEBOOK_ID]];
            if (!userAvatar) {
                [MessageDetailsServices downloadUserImageWithFacebookID:[currentDict objectForKey:KEY_FACEBOOK_ID] success:^(AFHTTPRequestOperation *operation, id responseObject){
                    userPhotoView.userPhotoImageView.image = responseObject;
                    [[ImageCacheObject shareImageCache].imageCache setObject:responseObject forKey:[currentDict objectForKey:KEY_FACEBOOK_ID]];
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
