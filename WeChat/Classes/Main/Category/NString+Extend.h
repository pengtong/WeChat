//
//  NString+Extend.h
//  QQChat
//
//  Created by Pengtong on 14-12-29.
//  Copyright (c) 2014年 Pengtong. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface NSString (Extend)

- (CGSize) sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

+ (instancetype)twoDecimalWithString:(NSString *)string;

@end
