//
//  MomentDetailViewController.h
//  9HugMoment
//

#import <UIKit/UIKit.h>
#import "DownloadVideoView.h"
#import "PlayerView.h"
#import "EnterMessageView.h"
#import "MomentsDetailsModel.h"
#import "UserDetailsObject.h"
#import "UserInfoTableViewCell.h"
#import "MomentsModel.h"
#import "CommentHeaderTableViewCell.h"
#import "CommentMessageTableViewCell.h"
#import "UpvoteMessageTableViewCell.h"
#import "PlayerViewTableViewCell.h"

@interface MomentDetailViewController : UIViewController<DownloadVideoDelegate,EnterMessageDelegate,UITableViewDataSource,UITableViewDelegate, MomentsDetailsModelDelegate, CommentHeaderTableViewCellDelegate, UserInfoTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UITableView *messageContentTableView;

@property (nonatomic,strong) PlayerView* videoPlayer;
@property (weak, nonatomic) NSLayoutConstraint *topPosition;

@property (nonatomic, strong) NSURL *capturePath;
@property (nonatomic, strong) NSString *userLabel;
@property (nonatomic, strong) MessageObject *messageObject;
//@property (nonatomic, strong) UserDetailsObject *userDetailsObject;

- (IBAction)backButtonAction:(id)sender;

@end
