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
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UIImage* tabBarBackground = [UIImage imageNamed:@"bgr_bottom_bar_white"];
    [[UITabBar appearance] setBackgroundImage:[Utilities imageWithImage:tabBarBackground scaledToRatio:[[UIScreen mainScreen] scale]==3?1.3:1]];
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
