//
//  Message.m
//  QQChat
//
//  Created by Pengtong on 14-12-29.
//  Copyright (c) 2014年 Pengtong. All rights reserved.
//

#import "Message.h"

@implementation Message

- (instancetype) initWithDict:(NSDictionary *) dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype) messageWithDict:(NSDictionary *) dict
{
    return [[self alloc] initWithDict:dict];
}
@end
