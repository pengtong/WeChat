//
//  MessageFrame.h
//  QQChat
//
//  Created by Pengtong on 14-12-29.
//  Copyright (c) 2014年 Pengtong. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "NString+Extend.h"

#define kMessageTextFont  [UIFont systemFontOfSize:14]
#define kTextEdgeInsets 20
@class Message;

@interface MessageFrame : NSObject

@property (nonatomic, strong) Message *msg;

@property (nonatomic, assign, readonly) CGRect iconF;

@property (nonatomic, assign, readonly) CGRect timeF;

@property (nonatomic, assign, readonly) CGRect textF;

@property (nonatomic, assign, readonly) CGFloat cellHeight;

@end
