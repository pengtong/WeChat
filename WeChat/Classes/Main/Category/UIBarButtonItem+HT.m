//
//  UIBarButtonItem+HHBarButtonItem.m
//  HaHaWeiBo
//
//  Created by Pengtong on 15/6/17.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import "UIBarButtonItem+HT.h"
#import "UIImage+HHImage.h"
#import "UIView+MJ.h"

@implementation UIBarButtonItem (HT)

+ (instancetype) itemWithIcon:(NSString *)icon highIcon:(NSString *)highIcon target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];

    [button setImage:[UIImage imageWithName:icon] forState:UIControlStateNormal];
    [button setImage:[UIImage imageWithName:highIcon] forState:UIControlStateHighlighted];
    button.size = button.currentImage.size;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end
