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
        id mainVC  = [self viewControllerFromStoryBoard:@"Main" withImage:@"btn_bar_code" withImageSelected:@"btn_bar_code_on" title:@"Code"];
    
        id trendVC  = [self viewControllerFromStoryBoard:kStoryBoardTrending withImage:@"btn_bar_public" withImageSelected:@"btn_bar_public_on" title:@"Public"];
        
        id recentVC = [self viewControllerFromStoryBoard:kStoryBoardRecent withImage:@"btn_bar_me" withImageSelected:@"btn_bar_me_on" title:@"Me"];
        id friendVC = [self viewControllerFromStoryBoard:kStoryBoardFromFriend withImage:@"btn_bar_friends" withImageSelected:@"btn_bar_friends_on" title:@"Friends"];
        id youVC = [self viewControllerFromStoryBoard:kStoryBoardMyMoments withImage:@"btn_bar_messages" withImageSelected:@"btn_bar_messages_on" title:@"Messages"];
        
        self.viewControllers = [NSArray arrayWithObjects:recentVC,friendVC,mainVC,youVC,trendVC, nil];
        self.selectedIndex = 2;
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
