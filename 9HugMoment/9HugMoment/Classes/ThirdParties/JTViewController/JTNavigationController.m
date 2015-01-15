//
//  JTNavigationController.m
//  Copyright (c) 2013 WeezLabs, Inc. All rights reserved.
//

#import "JTNavigationController.h"

@interface JTNavigationController ()

@end

@implementation JTNavigationController

- (NSUInteger)supportedInterfaceOrientations {
	return [self.topViewController supportedInterfaceOrientations];
}

- (BOOL)shouldAutorotate {
    return self.topViewController.shouldAutorotate;
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
