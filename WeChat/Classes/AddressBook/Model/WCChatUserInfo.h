//
//  WCChatUserInfo.h
//  WeChat
//
//  Created by Pengtong on 15/8/27.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XMPPJID;

@interface WCChatUserInfo : NSObject
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, weak) UIImage *userIcon;
@property (nonatomic, copy) XMPPJID *jid;
@end
