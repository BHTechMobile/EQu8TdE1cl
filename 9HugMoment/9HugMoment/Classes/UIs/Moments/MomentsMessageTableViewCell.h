//
//  MomentsMessageTableViewCell.h
//  9HugMoment
//

#import <UIKit/UIKit.h>
#import "MessageObject.h"

@interface MomentsMessageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *gpsIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberCountsLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftSpaceDataViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightSpaceDataViewConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *attachment2ImageView;

- (void)setMessageWithMessage:(MessageObject *)message;

@end
