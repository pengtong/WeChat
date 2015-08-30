//
//  WCUservCard.m
//  WeChat
//
//  Created by Pengtong on 15/8/22.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import "WCUservCard.h"
#import "WCUserInfo.h"

#define WCUservCardFilePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"uservcard.data"]

@implementation WCUservCard

static WCUservCard *_uservCard;

+ (WCUservCard *)sharedUservCard
{
    if (!_uservCard)
    {
        _uservCard = [NSKeyedUnarchiver unarchiveObjectWithFile:WCUservCardFilePath];
        
        if (!_uservCard)
        {
            _uservCard = [[WCUservCard alloc] init];
        }
    }
    return _uservCard;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _uservCard = [super allocWithZone:zone];
    });
    return _uservCard;
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self)
    {
        self.nickname = [decoder decodeObjectForKey:@"nickname"];
        self.photo = [decoder decodeObjectForKey:@"photo"];
        self.number = [decoder decodeObjectForKey:@"number"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.nickname forKey:@"nickname"];
    [encoder encodeObject:self.photo forKey:@"photo"];
    [encoder encodeObject:self.number forKey:@"number"];
}

- (void)setVCordTemp:(XMPPvCardTemp *)vCordTemp
{
    _vCordTemp = vCordTemp;
    self.nickname = [vCordTemp.nickname copy];
    self.photo = vCordTemp.photo;
    self.number = [[WCUserInfo sharedUserInfo].user copy];
}

- (void)saveUservCard
{
    [NSKeyedArchiver archiveRootObject:_uservCard toFile:WCUservCardFilePath];
}

@end
