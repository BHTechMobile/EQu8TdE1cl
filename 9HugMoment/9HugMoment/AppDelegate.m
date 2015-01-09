//
//  AppDelegate.m
//  9HugMoment
//
//  Created by Tommy on 11/24/14.
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import "AppDelegate.h"
#import "FacebookManager.h"
#import <FacebookSDK/FacebookSDK.h>
#import "JTTabBarController.h"
#import "FramesModel.h"
#import "FiltersModel.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [FiltersModel sharedFilters];
    [FramesModel sharedFrames];
    
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    
    UIImage* tabBarBackground = [UIImage imageNamed:IMAGE_NAME_BACKGROUND_BOTTOM_BAR_WHITE];
    [[UITabBar appearance] setBackgroundImage:[Utilities imageWithImage:tabBarBackground scaledToRatio:width/320.0f]];
    [[UITabBar appearance] setBarStyle:UIBarStyleBlack];
    
    JTTabBarController *tabBarController = [[JTTabBarController alloc] init];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    _session = [FBSession activeSession];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBAppEvents activateApp];
    [FBAppCall handleDidBecomeActiveWithSession:self.session];
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication withSession:self.session];
}
@end
