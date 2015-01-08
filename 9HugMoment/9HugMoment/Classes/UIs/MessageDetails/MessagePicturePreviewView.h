//
//  MessagePicturePreviewView.h
//  9HugMoment
//

#import <UIKit/UIKit.h>
#import "CommentObject.h"

@class MessagePicturePreviewView;
@protocol MessagePicturePreviewViewDelegate <NSObject>
@optional
- (void)didClickPreviewImageButton:(MessagePicturePreviewView *)messagePicturePreviewView pictureIndex:(NSNumber *)pictureIndex;
@end

@interface MessagePicturePreviewView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *previewImageView;
@property (weak, nonatomic) IBOutlet UIButton *previewButton;
@property (strong, nonatomic) CommentObject *commentObject;
@property (weak, nonatomic) id<MessagePicturePreviewViewDelegate> delegate;
@property (strong, nonatomic) NSNumber *pictureIndex;

- (IBAction)previewAction:(id)sender;
- (void)updatePictureData;

@end
