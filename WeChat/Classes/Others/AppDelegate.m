//
//  AppDelegate.m
//  WeChat
//
//  Created by Pengtong on 15/8/16.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import "AppDelegate.h"
#import "XMPPFramework.h"

@interface AppDelegate ()<XMPPStreamDelegate>
{
    XMPPStream *_xmppStream;
    XMPPResultBlock _resultBlock;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
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

#pragma mark --Xmpp
//1.初始化xmpp
- (void)setupXmppStream
{
    _xmppStream = [[XMPPStream alloc] init];
    
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
}

//2.连接服务器
-(void)connectToHost
{
    if (!_xmppStream)
    {
        [self setupXmppStream];
    }
    
    NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:KeyUser];
    _xmppStream.myJID = [XMPPJID jidWithUser:user domain:@"test.local" resource:@"iphone"];
    _xmppStream.hostName = @"127.0.0.1";
    _xmppStream.hostPort = 5222;
    NSError *error = nil;
    if (![_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
    {
        WCLog(@"%@", error);
    }
}

//3.发送密码到服务器
- (void)sendPwdToHost
{
    NSError *error = nil;
    NSString *pwd = [[NSUserDefaults standardUserDefaults] objectForKey:KeyPwd];
    [_xmppStream authenticateWithPassword:pwd error:&error];
    
    if (error)
    {
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

- (void)xmppLogout
{
    XMPPPresence *offline = [XMPPPresence presenceWithType:@"unavailable"];
    [_xmppStream sendElement:offline];
    
    [_xmppStream disconnect];
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
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    WCLog(@"授权失败%@", error);
    
    if (_resultBlock)
    {
        _resultBlock(XMPPResultTypeFailure);
    }
}
@end
