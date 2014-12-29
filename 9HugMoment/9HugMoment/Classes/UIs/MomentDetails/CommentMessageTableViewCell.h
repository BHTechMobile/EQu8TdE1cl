//
//  CommentMessageTableViewCell.h
//  9HugMoment
//

#import <UIKit/UIKit.h>

@interface CommentMessageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userCommentImage;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UILabel *commentTimeLabel;

@end
