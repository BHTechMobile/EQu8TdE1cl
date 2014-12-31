//
//  CaptureVideoViewController.h
//  9HugMoment
//
//  Created by Tommy on 11/24/14.
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPUImage.h"
#import "PBJVision.h"

#import "PBJVision.h"
#import "PBJVisionUtilities.h"
#import "NavigationView.h"
#import <GLKit/GLKit.h>

@interface CaptureVideoViewController : UIViewController<PBJVisionDelegate,UIAlertViewDelegate,NavigationCustomViewDelegate>{
    NSArray * changeFrameButtons;
    int _currentFrame;
    BOOL _isRecording;
    AVCaptureVideoPreviewLayer *_previewLayer;
    GLKViewController *_effectsViewController;
    NSInteger _startCount;
    int _imgIndex;
    UIImageView *_cursorImageView;
    UIView *_viewCurrentProgress;
    NSMutableArray *_arrayViewSpeacators;
    NavigationView *navigationView;
}

@property (retain, nonatomic) IBOutlet NSLayoutConstraint *hightViewOffsetConstraint;
@property (weak, nonatomic) IBOutlet UILabel *swipeFrameLabel;
@property (weak, nonatomic) IBOutlet NSString *mKey;

@end
