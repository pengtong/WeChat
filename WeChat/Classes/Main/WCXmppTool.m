//
//  WCXmppTool.m
//  WeChat
//
//  Created by Pengtong on 15/8/17.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import "WCXmppTool.h"

#import "XMPPvCardCoreDataStorage.h"
#import "XMPPReconnect.h"
#import "XMPPRoster.h"
#import "XMPPMessageArchiving.h"


@interface WCXmppTool ()<XMPPStreamDelegate>
{
    XMPPResultBlock _resultBlock;
    //电子名片
    XMPPvCardCoreDataStorage *_vCardStorage;
    //自动连接
    XMPPReconnect *_reconnect;
    //聊天
    XMPPMessageArchiving *_msgArchiving;
}

@end

static WCXmppTool *_xmppTool;

@implementation WCXmppTool

+ (WCXmppTool *)XMPPTool
{
    if (!_xmppTool)
    {
        _xmppTool = [[WCXmppTool alloc] init];
    }
    return _xmppTool;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _xmppTool = [super allocWithZone:zone];
    });
    return _xmppTool;
}

#pragma mark --Xmpp
//1.初始化xmpp
- (void)setupXmppStream
{
    _xmppStream = [[XMPPStream alloc] init];
    
    _vCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
    _vCard = [[XMPPvCardTempModule alloc] initWithvCardStorage:_vCardStorage];
    [_vCard activate:_xmppStream];
    
    _avatar = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:_vCard];
    [_avatar activate:_xmppStream];
    
    _reconnect = [[XMPPReconnect alloc] init];
    [_reconnect activate:_xmppStream];
    
    _rosterStorge = [[XMPPRosterCoreDataStorage alloc] init];
    _roster = [[XMPPRoster alloc] initWithRosterStorage:_rosterStorge];
    [_roster activate:_xmppStream];
    
    _msgStorge = [[XMPPMessageArchivingCoreDataStorage alloc] init];
    _msgArchiving = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:_msgStorge];
    [_msgArchiving activate:_xmppStream];
    
    _xmppStream.enableBackgroundingOnSocket = YES;
    
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
}

//2.连接服务器
-(void)connectToHost
{
    NSString *user = nil;
    NSError *error = nil;
    
    if (!_xmppStream)
    {
        [self setupXmppStream];
    }
    
    [self postStatusChangeNotification:XMPPResultTypeConnect];
    
    if (self.registerUser)
    {
        user = [WCUserInfo sharedUserInfo].registerUser;
    }
    else
    {
        user = [WCUserInfo sharedUserInfo].user;
    }

    _xmppStream.myJID = [XMPPJID jidWithUser:user domain:@"userdemacbook-pro.local" resource:@"iphone"];
    _xmppStream.hostName = @"127.0.0.1";
    _xmppStream.hostPort = 5222;
    
    if (![_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
    {
        WCLog(@"%@", error);
        [self postStatusChangeNotification:XMPPResultTypeFailure];
    }
}

//3.发送密码到服务器
- (void)sendPwdToHost
{
    NSError *error = nil;
    NSString *pwd = nil;
    
    if (self.registerUser)
    {
        pwd = [WCUserInfo sharedUserInfo].registerPwd;
        [_xmppStream registerWithPassword:pwd error:&error];
    }
    else
    {
        pwd = [WCUserInfo sharedUserInfo].pwd;
        [_xmppStream authenticateWithPassword:pwd error:&error];
    }
    
    if (error)
    {
        [self postStatusChangeNotification:XMPPResultTypeFailure];
        WCLog(@"%@", error);
    }
}

//4.授权成功发送在线消息到服务器
- (void)sendOnlineToHost
{
    XMPPPresence *presence = [XMPPPresence presence];
    
    [_xmppStream sendElement:presence];
}

- (void)xmppLogin:(XMPPResultBlock)block
{
    _resultBlock = block;
    
    [_xmppStream disconnect];
    
    [self connectToHost];
}

- (void)xmppRegister:(XMPPResultBlock)block
{
    _resultBlock = block;
    
    [self connectToHost];
}

- (void)xmpplogout
{
    XMPPPresence *offline = [XMPPPresence presenceWithType:@"unavailable"];
    [_xmppStream sendElement:offline];
    [_xmppStream disconnect];
    [WCUserInfo sharedUserInfo].status = NO;
    [[WCUserInfo sharedUserInfo] saveUserInfo];
}

-(void)teardownXmpp
{
    [_xmppStream removeDelegate:self];
    
    [_vCard deactivate];
    [_avatar deactivate];
    [_reconnect deactivate];
    [_roster deactivate];
    [_msgArchiving deactivate];
    
    [_xmppStream disconnect];
    
    _reconnect = nil;
    _vCard = nil;
    _vCardStorage = nil;
    _avatar = nil;
    _roster = nil;
    _rosterStorge = nil;
    _msgStorge = nil;
    _msgArchiving = nil;
    _xmppStream = nil;
}

- (void)dealloc
{
    [self teardownXmpp];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)postStatusChangeNotification: (XMPPResultType )resultType
{
    NSDictionary *info = @{WCXmppToolStatusKey : @(resultType)};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:WCXmppToolStatusChangeNotification object:nil userInfo:info];
}

#pragma mark --XMPPStreamDelegate
- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    WCLog(@"连接主机成功!");
    [self sendPwdToHost];
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    WCLog(@"与主机断开连接%@", error);
    
    if (error && _resultBlock)
    {
        _resultBlock(XMPPResultTypeNetError);
        [self postStatusChangeNotification:XMPPResultTypeFailure];
    }
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    WCLog(@"授权成功");

    [self sendOnlineToHost];
    
    if (_resultBlock)
    {
        _resultBlock(XMPPResultTypeSuccess);
    }
    [self postStatusChangeNotification:XMPPResultTypeSuccess];
//    WCUservCard *uservCard = [WCUservCard sharedUservCard];
//
//    uservCard.vCordTemp = self.vCard.myvCardTemp;
//    [uservCard saveUservCard];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    WCLog(@"授权失败%@", error);
    
    if (_resultBlock)
    {
        _resultBlock(XMPPResultTypeFailure);
        [self postStatusChangeNotification:XMPPResultTypeFailure];
    }
}

- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
    WCLog(@"注册成功");
    if (_resultBlock)
    {
        _resultBlock(XMPPResultTypeRegisterSuccess);
    }
    
}

- (void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error
{
    WCLog(@"注册失败%@", error);
    if (_resultBlock)
    {
        _resultBlock(XMPPResultTypeRegisterFailure);
    }
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    NSInteger count = [[UIApplication sharedApplication] applicationIconBadgeNumber];
    if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive)
    {
        UILocalNotification *localNoti = [[UILocalNotification alloc] init];
        NSRange fromRange = [message.fromStr rangeOfString:@"@"];
        NSString *fromName = [message.fromStr substringToIndex:fromRange.location];
        localNoti.alertBody = [NSString stringWithFormat:@"%@: %@", fromName, message.body];
        localNoti.soundName = @"default";
        localNoti.fireDate = [NSDate date];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:++count];
        [[UIApplication sharedApplication] scheduleLocalNotification:localNoti];
    }
}

//- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
//{
//    if([UIApplication sharedApplication].applicationState != UIApplicationStateActive)
//    {
//        UILocalNotification *localNoti = [[UILocalNotification alloc] init];
//        
//        localNoti.alertBody = [NSString stringWithFormat:@"%@\n%@",message.fromStr,message.body];
//        
//        localNoti.fireDate = [NSDate date];
//        
//        localNoti.soundName = @"default";
//        
//        [[UIApplication sharedApplication] scheduleLocalNotification:localNoti];
//        
//        //{"aps":{'alert':"zhangsan\n have dinner":'sound':'default',badge:'12'}}
//    }
//}

@end
