//
//  WCUserInfo.m
//  WeChat
//
//  Created by Pengtong on 15/8/18.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import "WCUserInfo.h"

static NSString* const KeyUser = @"KeyUser";
static NSString* const KeyPwd = @"pwd";
static NSString* const KeyStatus = @"KeyStatus";
static NSString* const KeyImageData = @"KeyImageData";


static WCUserInfo *_userInfo;

@implementation WCUserInfo

+ (instancetype)sharedUserInfo
{
    if (!_userInfo)
    {
        _userInfo = [[WCUserInfo alloc] init];
    }
    return _userInfo;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _userInfo = [super allocWithZone:zone];
    });
    return _userInfo;
}

- (void)loadUserInfo
{
    self.user = [[NSUserDefaults standardUserDefaults] objectForKey:KeyUser];
    self.pwd = [[NSUserDefaults standardUserDefaults] objectForKey:KeyPwd];
    self.status = [[NSUserDefaults standardUserDefaults] boolForKey:KeyStatus];
    self.imageData = [[NSUserDefaults standardUserDefaults] dataForKey:KeyImageData];
}

- (void)saveUserInfo
{
    [[NSUserDefaults standardUserDefaults] setObject:self.user forKey:KeyUser];
    [[NSUserDefaults standardUserDefaults] setObject:self.pwd forKey:KeyPwd];
    [[NSUserDefaults standardUserDefaults] setBool:self.status forKey:KeyStatus];
    [[NSUserDefaults standardUserDefaults] dataForKey:KeyImageData];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)jid
{
    return [NSString stringWithFormat:@"%@@%@", self.user, domin];
}

@end
