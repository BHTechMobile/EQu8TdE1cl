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
        id trendVC  = [self viewControllerFromStoryBoard:kStoryBoardTrending withImage:kImageTabbarTrend withImageSelected:kImageTabbarTrendHighlight];
        id recentVC = [self viewControllerFromStoryBoard:kStoryBoardRecent withImage:kImageTabbarRecent withImageSelected:kImageTabbarRecentHightlight];
        id friendVC = [self viewControllerFromStoryBoard:kStoryBoardFromFriend withImage:kImageTabbarFromFriend withImageSelected:kImageTabbarFromFriendHightlight];
        id youVC = [self viewControllerFromStoryBoard:kStoryBoardMyMoments withImage:kImageTabbarMyMoment withImageSelected:kImageTabbarMyMomentHightlight];
        self.viewControllers = [NSArray arrayWithObjects:trendVC,recentVC,friendVC,youVC, nil];
        self.selectedIndex = 0;
    }
    return self;
}

- (JTNavigationController *)viewControllerFromStoryBoard :(NSString *)storyBoardName withImage:(NSString *)nameImage withImageSelected:(NSString *)nameImageSelected{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:storyBoardName bundle:nil];
    JTNavigationController *viewController = [storyboard instantiateInitialViewController];
    UIImage *imageNormal = [UIImage imageNamed:nameImage];
    UIImage *imageSelected = [UIImage imageNamed:nameImageSelected];
    
    imageNormal = [imageNormal imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    imageSelected = [imageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    viewController.tabBarItem = [[UITabBarItem alloc]initWithTitle:nil image:imageNormal selectedImage:imageSelected];
    [viewController.tabBarItem setImageInsets:UIEdgeInsetsMake(7, 0, -7, 0)];
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
