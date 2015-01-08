//
//  UpvoteMessageTableViewCell.h
//  9HugMoment
//

#import <UIKit/UIKit.h>
#import "UserPhotoView.h"
#import "ImageCacheObject.h"

@interface UpvoteMessageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *voteCountLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *userVoteScrollView;
@property (strong, nonatomic) NSMutableArray *usersFacebookIDArray;

- (void)showUserPhoto;

@end
