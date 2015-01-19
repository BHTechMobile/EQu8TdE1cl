//
//  FriendRequestTableViewCell.h
//  9HugMoment
//

#import <UIKit/UIKit.h>

@interface FriendRequestTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleFriendRequestLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameRequestLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeRequestLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthUserNameRequestConstraint;


@end
