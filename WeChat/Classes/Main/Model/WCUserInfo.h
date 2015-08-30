//
//  WCUserInfo.h
//  WeChat
//
//  Created by Pengtong on 15/8/18.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString* const domin = @"userdemacbook-pro.local";

@interface WCUserInfo : NSObject

@property (nonatomic, copy) NSString *user;
@property (nonatomic, copy) NSString *pwd;
@property (nonatomic, strong) NSData *imageData;
@property (nonatomic, copy) NSString *registerUser;
@property (nonatomic, copy) NSString *registerPwd;

@property (nonatomic, assign) BOOL status;
@property (nonatomic, copy) NSString *jid;

+ (instancetype)sharedUserInfo;

- (void)loadUserInfo;
- (void)saveUserInfo;
@end
