//
//  MeScreenViewController.h
//  9HugMoment
//

#import <UIKit/UIKit.h>

@interface MeScreenViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *userPhotoImageView;
@property (weak, nonatomic) IBOutlet UIButton *userPhotoButton;
@property (weak, nonatomic) IBOutlet UITextField *inputStatusTextField;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfCreditsTopContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *creditsTopContentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundStatisticImageView;
//Gifts Sent
@property (weak, nonatomic) IBOutlet UIButton *giftsSentButton;
@property (weak, nonatomic) IBOutlet UILabel *numberOfGiftsSentLabel;
@property (weak, nonatomic) IBOutlet UILabel *giftsSentLabel;
//Request
@property (weak, nonatomic) IBOutlet UIButton *requestsButton;
@property (weak, nonatomic) IBOutlet UILabel *numberOfRequestsLabel;
@property (weak, nonatomic) IBOutlet UILabel *requestsLabel;
//Friends
@property (weak, nonatomic) IBOutlet UIButton *friendsButton;
@property (weak, nonatomic) IBOutlet UILabel *numberOfFriendsLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendsLabel;
//Credits
@property (weak, nonatomic) IBOutlet UIButton *creditsButton;
@property (weak, nonatomic) IBOutlet UILabel *numberOfCreditsLabel;
@property (weak, nonatomic) IBOutlet UILabel *creditsLabel;
//Stickers
@property (weak, nonatomic) IBOutlet UIButton *stickersButton;
@property (weak, nonatomic) IBOutlet UILabel *numberOfStickersLabel;
@property (weak, nonatomic) IBOutlet UILabel *stickersLabel;


- (IBAction)userPhotoAction:(id)sender;
- (IBAction)giftsSentAction:(id)sender;
- (IBAction)requestsAction:(id)sender;
- (IBAction)friendsAction:(id)sender;
- (IBAction)creditsAction:(id)sender;
- (IBAction)stickersAction:(id)sender;
- (IBAction)tapViewAction:(id)sender;

@end
