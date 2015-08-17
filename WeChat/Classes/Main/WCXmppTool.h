//
//  WCXmppTool.h
//  WeChat
//
//  Created by Pengtong on 15/8/17.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCXmppTool : NSObject

typedef NS_ENUM(NSInteger, XMPPResultType)
{
    XMPPResultTypeSuccess,
    XMPPResultTypeFailure,
    XMPPResultTypeNetError
};

typedef void (^XMPPResultBlock)(XMPPResultType type);


//登录
- (void)xmppLogin:(XMPPResultBlock)block;

//注销登录
- (void)xmpplogout;
@end
