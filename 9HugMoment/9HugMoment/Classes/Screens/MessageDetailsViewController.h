//
//  MessageDetailsViewController.h
//  9HugMoment
//

#import <UIKit/UIKit.h>
#import "PlayerViewTableViewCell.h"
#import "PlayerView.h"
#import "UserInfoTableViewCell.h"
#import "MessageCaptionTableViewCell.h"
#import "MessageAudioTableViewCell.h"
#import "MessagePictureTableViewCell.h"
#import "MessageDetailsModel.h"
#import "MessageObject.h"
#import "ImageCacheObject.h"
#import "SquareCamViewController.h"
#import "RecordObject.h"
#import "UpvoteMessageTableViewCell.h"

@interface MessageDetailsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MessageDetailsModelDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, CameraDelegate, MessagePictureTableViewCellDelegate, RecordObjectDelegate>
{
    CGFloat heightMessageCaptionCell;
    CGFloat heightMessageUpVoteCell;
    MessageDetailsModel *_messageDetailsModel;
    MBProgressHUD *_hud;
    UIImagePickerController *_imagePicker;
    UIActionSheet *_imageSourceActionSheet;
    MPMoviePlayerController *_moviePlayerStreaming;
    
    MessageAudioTableViewCell *_messageAudioTableViewCell;
    RecordObject *_recordObject;
}

@property (weak, nonatomic) IBOutlet UITableView *messageDetailsTableView;
@property (weak, nonatomic) IBOutlet UIButton *cancelRecordButton;
@property (weak, nonatomic) IBOutlet UIButton *sendPhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *playAudioButton;
@property (weak, nonatomic) IBOutlet UIButton *addPhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIView *recordView;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeRecordLabel;

@property (nonatomic, strong) MessageObject *messageObject;
@property (nonatomic, strong) AVAudioRecorder *audioRecorder;

- (IBAction)cancelRecordAction:(id)sender;
- (IBAction)sendPhotoAction:(id)sender;
- (IBAction)playAudioAction:(id)sender;
- (IBAction)addPhotoAction:(id)sender;
- (IBAction)recordAction:(id)sender;
- (IBAction)backAction:(id)sender;
- (IBAction)likeAction:(id)sender;
- (IBAction)holdAndRecordAction:(id)sender;

@end
