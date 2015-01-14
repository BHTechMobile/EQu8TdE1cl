//
//  MixAudioViewController.h
//  9HugMoment
//
//  Created by Tommy on 11/24/14.
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MixAudioViewController;
@protocol MixAudioViewControllerDelegate <NSObject>

-(void)mixAudioViewControllerDidCancel;
-(void)mixAudioViewController:(MixAudioViewController*)setupViewController didMixVideoUrl:(NSURL*)mixUrl;

@end

@interface MixAudioViewController : UIViewController

@property(nonatomic,weak) id<MixAudioViewControllerDelegate> delegate;

@property(nonatomic, strong) MPMediaItem* audioItem;
@property(nonatomic, strong) NSURL* capturePath;
@property(nonatomic, strong) NSURL* exportUrl;

@end
