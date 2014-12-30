//
//  CodeViewController.h
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZXingObjC/ZXingObjC.h>
#import "MessageObject.h"
#import "QuartzCore/CALayer.h"
#import "DownloadVideoView.h"
#import "VolumeView.h"
#import <FacebookSDK/FacebookSDK.h>
#import <QuartzCore/QuartzCore.h>

#define NICEHUG_DOMAIN @"www.9hug.com"

@interface CodeViewController : UIViewController<ZXCaptureDelegate,DownloadVideoDelegate,UITextFieldDelegate,AVCaptureMetadataOutputObjectsDelegate>{
    int _yesSwipe;
}

@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet UIView *centerView;
@property (strong, nonatomic) IBOutlet UIButton *checkCodeButton;
@property (strong, nonatomic) IBOutlet UIView *scanRectView;
@property (strong, nonatomic) IBOutlet UIView *enterCodeView;
@property (strong, nonatomic) IBOutlet UITextField *enterCodeTextField;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UILabel *lblSwipe;
@property (strong, nonatomic) IBOutlet UIImageView *imvAvatar;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UIImageView *scannerSquareImv;
@property (nonatomic, strong) DownloadVideoView *downloadView;

@property (nonatomic, strong) ZXCapture *capture;
@property (nonatomic, strong) MessageObject *message;
@property (nonatomic, strong) NSString *mKey;
@property (nonatomic, assign) BOOL scaned;
@property (nonatomic, strong) AVCaptureSession *session;

- (IBAction)checkCodeButtonTapped:(UIButton *)sender;
- (IBAction)okButtonTapped:(id)sender;
@end
