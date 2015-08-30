//
//  MessageFrame.m
//  QQChat
//
//  Created by Pengtong on 14-12-29.
//  Copyright (c) 2014年 Pengtong. All rights reserved.
//

#import "MessageFrame.h"
#import "Message.h"

#define kTimeH   20
#define kIconWH  40
#define kTextW   200

#define kImageHW  80

@implementation MessageFrame


- (void) setMsg:(Message *)msg
{
    _msg = msg;
    
    CGFloat padding = 10;
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    
    if (_msg.showTime) {
        CGFloat timeX = 0;
        CGFloat timeY = 0;
        CGFloat timeW = screenW;
        CGFloat timeH = kTimeH;
        
        _timeF = CGRectMake(timeX, timeY, timeW, timeH);
    }
    
    
    CGFloat iconY = CGRectGetMaxY(_timeF) + padding;
    CGFloat iconW = kIconWH;
    CGFloat iconH = kIconWH;
    CGFloat iconX;
    if (_msg.type == MessageTypeOther) {
        iconX = padding;
    }else {
        iconX = screenW - padding - kIconWH;
    }
    _iconF = CGRectMake(iconX, iconY, iconW, iconH);
    
    if (_msg.bodyType == MessageBodyTypeText)
    {
        CGSize textSize = [_msg.text sizeWithFont:kMessageTextFont maxSize:CGSizeMake(kTextW, MAXFLOAT)];
        CGSize textBtnSize = CGSizeMake(textSize.width + kTextEdgeInsets * 2, textSize.height + kTextEdgeInsets * 2);
        CGFloat textY = iconY;
        CGFloat textX;
        
        if (_msg.type == MessageTypeOther) {
            textX = CGRectGetMaxX(_iconF) + padding;
        }else {
            textX = iconX - padding - textBtnSize.width;
        }
        _textF = CGRectMake(textX, textY, textBtnSize.width, textBtnSize.height);
        
        CGFloat iconMaxY = CGRectGetMaxY(_iconF);
        CGFloat textMaxY = CGRectGetMaxY(_textF);
        _cellHeight = MAX(iconMaxY, textMaxY) + padding;
    }
    else if (_msg.bodyType == MessageBodyTypeImage)
    {
        CGFloat imageY = iconY;
        CGFloat imageX = 0;
        
        if (_msg.type == MessageTypeOther) {
            imageX = CGRectGetMaxX(_iconF) + padding;
        }else {
            imageX = iconX - padding - kImageHW;
        }
        _imageF = CGRectMake(imageX, imageY, kImageHW, kImageHW);
        
        CGFloat iconMaxY = CGRectGetMaxY(_iconF);
        CGFloat imageMaxY = CGRectGetMaxY(_imageF);
        _cellHeight = MAX(iconMaxY, imageMaxY) + padding;
    }
}

@end
