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
//返回2位小说
+ (instancetype)twoDecimalWithString:(NSString *)string;

/**
 添加文件输入框左边的View,添加图片
 */
-(void)addLeftViewWithImage:(NSString *)image;

/**
 * 判断是否为手机号码
 */
-(BOOL)isTelphoneNum;

@end
