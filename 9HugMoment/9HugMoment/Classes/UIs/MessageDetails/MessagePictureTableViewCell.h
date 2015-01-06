//
//  MessagePictureTableViewCell.h
//  9HugMoment
//

#import <UIKit/UIKit.h>
#import "MessagePicturePreviewView.h"
#import "SlideImageViewController.h"

@class MessagePictureTableViewCell;
@protocol MessagePictureTableViewCellDelegate <NSObject>
@optional
- (void)willShowSlideImageView:(SlideImageViewController *)slideImageViewController withCell:(MessagePictureTableViewCell *)messagePictureTableViewCell;

@end

@interface MessagePictureTableViewCell : UITableViewCell<MessagePicturePreviewViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *picturesScrollView;
@property (nonatomic, strong) NSMutableArray *pictureCommentObjectArray;
@property (weak, nonatomic) id<MessagePictureTableViewCellDelegate> delegate;

- (void)showPictures;

@end
