//
//  MessageAudioTableViewCell.h
//  9HugMoment
//

#import <UIKit/UIKit.h>
#import "MessageAudioPreviewView.h"
#import "CommentObject.h"
#import "MessageDetailsModel.h"
#import "MessageDetailsModel.h"

@interface MessageAudioTableViewCell : UITableViewCell<MessageAudioPreviewViewDelegate, AVAudioPlayerDelegate>
{
    AVAudioPlayer *audioPlayer;
    NSTimer *playTimer;
    BOOL isPlayAll;
    int currentIndexAudioPlay;
}

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *currentAudioImageView;
@property (weak, nonatomic) IBOutlet UIButton *currentAudioButton;
@property (weak, nonatomic) IBOutlet UIView *audioProcessView;
@property (weak, nonatomic) IBOutlet UIView *audioProcessCurrentView;
@property (weak, nonatomic) IBOutlet UILabel *currentAudioUploadTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentAudioTimeRunLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentAudioTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *playAudioSelectButton;
@property (weak, nonatomic) IBOutlet UIScrollView *audioScrollView;
@property (weak, nonatomic) IBOutlet UILabel *audioTotalTimeLabel;
@property (nonatomic, strong) NSMutableArray *audioCommentObjectArray;
@property (strong, nonatomic) CommentObject *currentCommentObject;
@property (strong, nonatomic) NSMutableArray *audioDownloadedArray;
@property (strong, nonatomic) NSMutableArray *messageAudioPreviewViewArray;

- (IBAction)playAudioAction:(id)sender;
- (void)showUsersAudio;
- (void)playAllAudioAction;

@end
