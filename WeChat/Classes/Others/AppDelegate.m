//
//  AppDelegate.m
//  WeChat
//
//  Created by Pengtong on 15/8/16.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import "AppDelegate.h"
#import "WCXmppTool.h"
#import "DDLog.h"
#import "DDTTYLogger.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)setupTabbarTheme
{
    UITabBarItem *tabbarItem = [UITabBarItem appearance];

    NSMutableDictionary *dictnSelected = [NSMutableDictionary dictionary];
    dictnSelected[NSForegroundColorAttributeName] = [UIColor colorWithRed:14/255.0 green:180/255.0 blue:0 alpha:1.0];
    [tabbarItem setTitleTextAttributes:dictnSelected forState:UIControlStateSelected];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self setupTabbarTheme];
    
    application.statusBarStyle = UIStatusBarStyleLightContent;
    
    [[WCUserInfo sharedUserInfo] loadUserInfo];
    
    if ([WCUserInfo sharedUserInfo].status)
    {
        self.window.rootViewController = [UIStoryboard storyboardWithName:@"Home" bundle:nil].instantiateInitialViewController;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[WCXmppTool XMPPTool] xmppLogin:nil];
        });
    }
    
    if ([[UIDevice currentDevice].systemVersion doubleValue] > 8.0)
    {
        UIUserNotificationSettings *noftSetting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
        
        [application registerUserNotificationSettings:noftSetting];
    }
    
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
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
