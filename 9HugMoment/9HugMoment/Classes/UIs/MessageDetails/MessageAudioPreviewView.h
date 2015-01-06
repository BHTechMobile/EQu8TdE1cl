//
//  MessageAudioPreviewView.h
//  9HugMoment
//

#import <UIKit/UIKit.h>
#import "CommentObject.h"
#import "MessageDetailsModel.h"

@class MessageAudioPreviewView;
@protocol MessageAudioPreviewViewDelegate <NSObject>
@optional
- (void)didClickPreviewUserButton:(MessageAudioPreviewView *)messageAudioPreviewView;
@end

@interface MessageAudioPreviewView : UIView

@property (weak, nonatomic) IBOutlet UIButton *previewUserButton;
@property (weak, nonatomic) id<MessageAudioPreviewViewDelegate> delegate;
@property (strong, nonatomic) CommentObject *commentObject;
@property (weak, nonatomic) IBOutlet UIImageView *previewUserImageView;
@property (weak, nonatomic) IBOutlet UIView *currentAudioSelectView;
@property (strong, nonatomic) NSNumber *audioIndex;

- (IBAction)previewUserAction:(id)sender;
- (void)updateAudioData;

@end
