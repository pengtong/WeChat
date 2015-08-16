//
//  NSDate+HH.h
//  HaHaWeiBo
//
//  Created by Pengtong on 15/6/29.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (HH)

- (BOOL)isToday;

- (BOOL)isYesterday;

- (BOOL)isThisYear;

- (NSDateComponents *)deltaWithNow;
@end
