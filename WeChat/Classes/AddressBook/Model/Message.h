//
//  Message.h
//  QQChat
//
//  Created by Pengtong on 14-12-29.
//  Copyright (c) 2014年 Pengtong. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    MessageTypeMe = 0,
    MessageTypeOther
}MessageType;

typedef enum {
    MessageBodyTypeText = 0,
    MessageBodyTypeImage
}MessageBodyType;

@interface Message : NSObject

@property (nonatomic, copy) NSString *text;

@property (nonatomic, copy) NSString *time;

@property (nonatomic, strong) UIImage *iconImage;

@property (nonatomic, assign) BOOL showTime;

@property (nonatomic, assign) MessageType type;

@property (nonatomic, copy) NSString *imageUrl;

@property (nonatomic, assign) MessageBodyType bodyType;


@end
