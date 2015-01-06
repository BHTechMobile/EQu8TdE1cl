//
//  UserInfoTableViewCell.h
//  9HugMoment
//

#import <UIKit/UIKit.h>

@interface UserInfoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *timeUploadImageView;
@property (weak, nonatomic) IBOutlet UIImageView *friendStatusImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeUploadLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberMessageLabel;

@end
