//
//  WCChatMessageController.h
//  WeChat
//
//  Created by Pengtong on 15/8/26.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageDisplayKit/XHMessageTableViewController.h>
#import "WCChatUserInfo.h"

@interface WCChatMessageController : XHMessageTableViewController

@property (nonatomic, strong) WCChatUserInfo *userInfo;


@end
