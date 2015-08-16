//
//  AppDelegate.h
//  WeChat
//
//  Created by Pengtong on 15/8/16.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XMPPResultType)
{
    XMPPResultTypeSuccess,
    XMPPResultTypeFailure,
    XMPPResultTypeNetError
};

typedef void (^XMPPResultBlock)(XMPPResultType type);

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//登录
- (void)xmppLogin:(XMPPResultBlock)block;

//注销登录
- (void)xmpplogout;

@end

