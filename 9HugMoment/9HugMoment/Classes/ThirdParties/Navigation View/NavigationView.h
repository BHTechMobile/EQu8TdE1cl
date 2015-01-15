//
//  NavigationView.h
//  9HugMoment
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserProfileView;
@protocol NavigationCustomViewDelegate <NSObject>

@optional

- (void)backNvgAction;
- (void)twitterNvgAction;
- (void)facebookNvgAction;
- (void)ggPlusNvgAction;

@end

@interface NavigationView : UIView

@property (nonatomic, weak) id<NavigationCustomViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *backNvgButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookNvgButton;
@property (weak, nonatomic) IBOutlet UIButton *twitterNvgButton;
@property (weak, nonatomic) IBOutlet UIButton *ggPlusNvgButton;
@property (weak, nonatomic) IBOutlet UILabel *titleNvgLabel;

- (IBAction)backNvgButtonAction:(id)sender;
- (IBAction)twitterNvgButtonAction:(id)sender;
- (IBAction)facebookNvgButtonAction:(id)sender;
- (IBAction)ggPlusNvgButtonAction:(id)sender;

@end
