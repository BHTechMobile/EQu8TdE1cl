//
//  UserPhotoView.h
//  9HugMoment
//

#import <UIKit/UIKit.h>

@interface UserPhotoView : UIView

@property (weak, nonatomic) IBOutlet UIButton *userPhotoButton;
@property (weak, nonatomic) IBOutlet UIImageView *userPhotoImageView;
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *userKey;

- (IBAction)userPhotoAction:(id)sender;

@end
