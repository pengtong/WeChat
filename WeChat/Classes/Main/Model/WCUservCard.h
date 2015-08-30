//
//  WCUservCard.h
//  WeChat
//
//  Created by Pengtong on 15/8/22.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPvCardTemp.h"

@interface WCUservCard : NSObject <NSCoding>

@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *number;
@property (nonatomic, strong) NSData *photo;
@property (nonatomic, strong) XMPPvCardTemp *vCordTemp;

+ (WCUservCard *)sharedUservCard;
- (void)saveUservCard;

@end
