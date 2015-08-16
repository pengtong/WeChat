//
//  UIBarButtonItem+HHBarButtonItem.h
//  HaHaWeiBo
//
//  Created by Pengtong on 15/6/17.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (HT)

+ (instancetype) itemWithIcon:(NSString *)icon highIcon:(NSString *)highIcon target:(id)target action:(SEL)action;

@end
