//
//  NSDate+HH.m
//  HaHaWeiBo
//
//  Created by Pengtong on 15/6/29.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import "NSDate+HH.h"

@implementation NSDate (HH)

- (BOOL)isToday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *nowComps = [calendar components:unit fromDate:[NSDate date]];
    NSDateComponents *selfComps = [calendar components:unit fromDate:self];
    
    return (nowComps.year == selfComps.year)
            &&(nowComps.month == selfComps.month)
            &&(nowComps.day == nowComps.day);
}

- (BOOL)isYesterday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *createString = [fmt stringFromDate:self];
    NSString *nowString = [fmt stringFromDate:[NSDate date]];
    
    NSDate *createDate = [fmt dateFromString:createString];
    NSDate *nowDate = [fmt dateFromString:nowString];
    
    NSDateComponents *cmps = [calendar components:unit fromDate:createDate toDate:nowDate options:0];
    
    return (cmps.year == 0)&&(cmps.month == 0)&&(cmps.day == 1);
    
//    NSTimeInterval secondsPerDay = 24 * 60 * 60;
//    NSDate *yesterday = [[NSDate date] dateByAddingTimeInterval:-secondsPerDay];
//    NSString *dateString = [[self description] substringToIndex:10];
//    NSString *yesterdayString = [[yesterday description] substringToIndex:10];
//    
//    return ([dateString isEqualToString:yesterdayString]);
}

- (BOOL)isThisYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitYear;
    NSDateComponents *nowComps = [calendar components:unit fromDate:[NSDate date]];
    NSDateComponents *selfComps = [calendar components:unit fromDate:self];
  
    return (nowComps.year == selfComps.year);
}

- (NSDateComponents *)deltaWithNow
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    return [calendar components:unit fromDate:self toDate:[NSDate date] options:0];
}
@end
