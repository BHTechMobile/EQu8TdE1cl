//
//  JTViewController.m
//  Copyright (c) 2013 WeezLabs, Inc. All rights reserved.
//

#import "JTViewController.h"

@interface JTViewController ()

@end

@implementation JTViewController

#pragma mark - Config Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return interfaceOrientation == UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate {
	return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
	return UIInterfaceOrientationMaskPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
