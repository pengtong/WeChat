//
//  WCNavigationController.m
//  WeChat
//
//  Created by Pengtong on 15/8/17.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import "WCNavigationController.h"

@interface WCNavigationController ()

@end

@implementation WCNavigationController

+ (void)initialize
{
    UINavigationBar *navBar = [UINavigationBar appearance];
    
    [navBar setBackgroundImage:[UIImage imageWithName:@"topbarbg_ios7"] forBarMetrics:UIBarMetricsDefault];
    NSMutableDictionary *navAttr = [NSMutableDictionary dictionary];
    navAttr[NSForegroundColorAttributeName] = [UIColor whiteColor];
    navAttr[NSFontAttributeName] = [UIFont systemFontOfSize:20];
    [navBar setTitleTextAttributes:navAttr];
    navBar.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *barButtonItem = [UIBarButtonItem appearance];
    [barButtonItem setTintColor:[UIColor whiteColor]];
    NSMutableDictionary *buttonAttr = [NSMutableDictionary dictionary];
    buttonAttr[NSForegroundColorAttributeName] = [UIColor whiteColor];
    buttonAttr[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    [barButtonItem setTitleTextAttributes:buttonAttr forState:UIControlStateNormal];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    viewController.hidesBottomBarWhenPushed = YES;
 
    [super pushViewController:viewController animated:YES];
}

@end
