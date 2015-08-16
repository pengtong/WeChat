//
//  WCCommon.h
//  WeChat
//
//  Created by Pengtong on 15/8/16.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//
#ifndef WeChat_WCCommon_h
#define WeChat_WCCommon_h

#import <Foundation/Foundation.h>

#import "UIView+MJ.h"
#import "NString+Extend.h"
#import "UIImage+HHImage.h"
#import "UIBarButtonItem+HT.h"
#import "NSDate+HH.h"
#import "UIView+AutoLayout.h"

#ifdef DEBUG
#define WCLog(...) NSLog(__VA_ARGS__)
#else
#define WCLog(...) nil
#endif

extern NSString* const KeyUser;
extern NSString* const KeyPwd;
#endif
