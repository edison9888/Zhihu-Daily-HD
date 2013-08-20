//
//  AppDelegate.m
//  ZhihuDailyHD
//
//  Created by Jiang Chuncheng on 6/29/13.
//  Copyright (c) 2013 SenseForce. All rights reserved.
//

#import "AppDelegate.h"
#import "Constants.h"
#import "MobClick.h"

#import "SloganViewController.h"

#import <GCOLaunchImageTransition/GCOLaunchImageTransition.h>

@interface AppDelegate ()

- (void)configUmeng;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self configUmeng];
    
    self.window.rootViewController = [[SloganViewController alloc] init];
    
	[self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    [GCOLaunchImageTransition transitionWithDuration:0.5f style:GCOLaunchImageTransitionAnimationStyleFade];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Private Metholds

- (void)configUmeng {
    [MobClick startWithAppkey:UmengAppKey];
    [MobClick setAppVersion:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
}

@end
