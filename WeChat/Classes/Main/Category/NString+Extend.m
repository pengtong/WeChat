//
//  NString+Extend.m
//  QQChat
//
//  Created by Pengtong on 14-12-29.
//  Copyright (c) 2014年 Pengtong. All rights reserved.
//

#import "NString+Extend.h"

@implementation NSString (Extend)


- (CGSize) sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attr = @{NSFontAttributeName : font};
    
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size;
}

+ (instancetype)twoDecimalWithString:(NSString *)string
{
    NSUInteger dotLoc = [string rangeOfString:@"."].location;
    if (dotLoc != NSNotFound)
    {
        if (string.length - dotLoc > 3)
        {
            return [string substringToIndex:dotLoc + 3];
        }
    }
    
    return string;
}

@end
