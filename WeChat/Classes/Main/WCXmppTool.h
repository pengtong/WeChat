//
//  WCXmppTool.h
//  WeChat
//
//  Created by Pengtong on 15/8/17.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPvCardTempModule.h"
#import "XMPPRosterCoreDataStorage.h"
#import "XMPPvCardAvatarModule.h"
#import "XMPPMessageArchivingCoreDataStorage.h"

#define WCXmppToolStatusChangeNotification @"WCXmppToolStatusChangeNotification"
#define WCXmppToolStatusKey @"loginStatus"

@interface WCXmppTool : NSObject

typedef NS_ENUM(NSInteger, XMPPResultType)
{
    XMPPResultTypeConnect,
    XMPPResultTypeSuccess,
    XMPPResultTypeFailure,
    XMPPResultTypeRegisterSuccess,
    XMPPResultTypeRegisterFailure,
    XMPPResultTypeNetError
};

typedef void (^XMPPResultBlock)(XMPPResultType type);

//电子名片
@property (nonatomic, strong) XMPPvCardTempModule *vCard;

//花名册
@property (nonatomic, strong) XMPPRoster *roster;

@property (nonatomic, strong) XMPPRosterCoreDataStorage *rosterStorge;

@property (nonatomic, strong) XMPPStream *xmppStream;
//头像
@property (nonatomic, strong) XMPPvCardAvatarModule *avatar;
//聊天
@property (nonatomic, strong) XMPPMessageArchivingCoreDataStorage *msgStorge;

@property (nonatomic, assign, getter=IsRegisterUser) BOOL registerUser;

+ (instancetype)XMPPTool;

//登录
- (void)xmppLogin:(XMPPResultBlock)block;
//注册
- (void)xmppRegister:(XMPPResultBlock)block;
//注销登录
- (void)xmpplogout;
@end
