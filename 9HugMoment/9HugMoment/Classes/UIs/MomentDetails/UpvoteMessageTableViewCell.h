//
//  UpvoteMessageTableViewCell.h
//  9HugMoment
//

#import <UIKit/UIKit.h>
#import "UserPhotoView.h"

@interface UpvoteMessageTableViewCell : UITableViewCell {
    NSCache *_avatarCache;
}

@property (weak, nonatomic) IBOutlet UILabel *voteCountLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *userVoteScrollView;
@property (strong, nonatomic) NSMutableArray *usersFacebookIDArray;

- (void)showUserPhoto;

@end
