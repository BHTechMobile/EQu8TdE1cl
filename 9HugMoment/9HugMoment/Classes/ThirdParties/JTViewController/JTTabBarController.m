//
//  JTTabBarController.m
//  Copyright (c) 2013 WeezLabs, Inc. All rights reserved.
//

#import "JTTabBarController.h"
#import "JTNavigationController.h"

@interface JTTabBarController (){
    int numberIndex;
}

@end

#define kStoryBoardTrending @"Trending"
#define kStoryBoardRecent @"Recent"
#define kStoryBoardFromFriend @"FromFriends"
#define kStoryBoardMyMoments @"MyMoments"
#define kStoryBoardMain @"Main"
#define kImageTabbarTrend @"trending_grey"
#define kImageTabbarTrendHighlight @"trending_red"
#define kImageTabbarRecent @"recent_grey"
#define kImageTabbarRecentHightlight @"recent_red"
#define kImageTabbarMyMoment @"you_grey"
#define kImageTabbarMyMomentHightlight @"you_red"
#define kImageTabbarFromFriend @"from_friend_grey"
#define kImageTabbarFromFriendHightlight @"from_friend_red"

@implementation JTTabBarController

- (id)init{
    if (self = [super init]) {
        id mainVC  = [self viewControllerFromStoryBoard:kStoryBoardMain
                                              withImage:IMAGE_NAME_BAR_CODE
                                      withImageSelected:IMAGE_NAME_BAR_CODE_ON
                                                  title:@"Code"];
        id trendVC  = [self viewControllerFromStoryBoard:kStoryBoardTrending
                                               withImage:IMAGE_NAME_BAR_PUBLIC
                                       withImageSelected:IMAGE_NAME_BAR_PUBLIC_ON
                                                   title:@"Public"];
        id meVC = [self viewControllerFromStoryBoard:kStoryBoardMain
                                           andBundle:BUNDLE_IDENTIFIER_ME_SCREEN_VIEW_CONTROLLER
                                           withImage:IMAGE_NAME_BAR_ME
                                   withImageSelected:IMAGE_NAME_BAR_ME_ON
                                               title:@"Me"];
        id friendVC = [self viewControllerFromStoryBoard:kStoryBoardMain
                                               andBundle:BUNDLE_IDENTIFIER_FRIENDS_SCREEN_VIEW_CONTROLLER
                                               withImage:IMAGE_NAME_BAR_FRIENDS
                                       withImageSelected:IMAGE_NAME_BAR_FRIENDS_ON
                                                   title:@"Friends"];
        id youVC = [self viewControllerFromStoryBoard:kStoryBoardMyMoments
                                            withImage:IMAGE_NAME_BAR_MESSAGES
                                    withImageSelected:IMAGE_NAME_BAR_MESSAGES_ON
                                                title:@"Messages"];
        
        self.viewControllers = [NSArray arrayWithObjects:meVC,friendVC,mainVC,youVC,trendVC, nil];
        self.selectedIndex = INDEX_DEFAULT_SELECTED;
    }
    return self;
}

- (JTNavigationController *)viewControllerFromStoryBoard :(NSString *)storyBoardName withImage:(NSString *)nameImage withImageSelected:(NSString *)nameImageSelected title:(NSString*)title{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:storyBoardName bundle:nil];
    JTNavigationController *viewController = [storyboard instantiateInitialViewController];
    UIImage *imageNormal = [UIImage imageNamed:nameImage];
    UIImage *imageSelected = [UIImage imageNamed:nameImageSelected];
    
    imageNormal = [imageNormal imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    imageSelected = [imageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    viewController.tabBarItem = [[UITabBarItem alloc]initWithTitle:title image:imageNormal selectedImage:imageSelected];
    [viewController.tabBarItem setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor colorWithRed:119.0f/255.0f green:200.0f/255.0f blue:1 alpha:1.0]} forState:UIControlStateSelected];
    

    if ([title isEqualToString:@"Code"]) {
        [viewController.tabBarItem setImageInsets:UIEdgeInsetsMake(-7, 0, 7, 0)];

        
    }
//    [viewController.tabBarItem setImageInsets:UIEdgeInsetsMake(7, 0, -7, 0)];
    return viewController;
}

- (JTNavigationController *)viewControllerFromStoryBoard :(NSString *)storyBoardName
                                                andBundle:(NSString *)bundleName
                                                withImage:(NSString *)nameImage
                                        withImageSelected:(NSString *)nameImageSelected
                                                    title:(NSString*)title
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:storyBoardName bundle:nil];
    JTNavigationController *viewController = [storyboard instantiateViewControllerWithIdentifier:bundleName];
    UIImage *imageNormal = [UIImage imageNamed:nameImage];
    UIImage *imageSelected = [UIImage imageNamed:nameImageSelected];
    
    imageNormal = [imageNormal imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    imageSelected = [imageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    viewController.tabBarItem = [[UITabBarItem alloc]initWithTitle:title image:imageNormal selectedImage:imageSelected];
    [viewController.tabBarItem setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor colorWithRed:119.0f/255.0f green:200.0f/255.0f blue:1 alpha:1.0]} forState:UIControlStateSelected];
    
    
    if ([title isEqualToString:@"Code"]) {
        [viewController.tabBarItem setImageInsets:UIEdgeInsetsMake(-7, 0, 7, 0)];
        
        
    }
    //    [viewController.tabBarItem setImageInsets:UIEdgeInsetsMake(7, 0, -7, 0)];
    return viewController;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setDelegate:self];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    }

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// You do not need this method if you are not supporting earlier iOS Versions
	return [self.selectedViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

- (NSUInteger)supportedInterfaceOrientations {
	return [self.selectedViewController supportedInterfaceOrientations];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldAutorotate {
	return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
