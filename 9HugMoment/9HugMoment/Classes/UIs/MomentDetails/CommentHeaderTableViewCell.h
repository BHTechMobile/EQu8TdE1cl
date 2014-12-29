//
//  CommentHeaderTableViewCell.h
//  9HugMoment
//

#import <UIKit/UIKit.h>
@class CommentHeaderTableViewCell;

@protocol CommentHeaderTableViewCellDelegate <NSObject>
@optional
- (void)didClickAddCommentButton;
@end

@interface CommentHeaderTableViewCell : UITableViewCell

@property (nonatomic,assign) id<CommentHeaderTableViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *addCommentButton;

- (IBAction)addCommentButtonAction:(id)sender;

@end
