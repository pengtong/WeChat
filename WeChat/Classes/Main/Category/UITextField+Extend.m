//
//  UITextField+Extend.m
//  WeChat
//
//  Created by Pengtong on 15/8/19.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import "UITextField+Extend.h"

@implementation UITextField (Extend)

-(void)addLeftViewWithImage:(NSString *)image{
    
    
    UIImageView *lockIv = [[UIImageView alloc] init];

    CGRect imageBound = self.bounds;
    imageBound.size.width = imageBound.size.height;
    lockIv.bounds = imageBound;
    lockIv.image = [UIImage imageNamed:image];
    lockIv.contentMode = UIViewContentModeCenter;
    self.leftView = lockIv;
    self.leftViewMode = UITextFieldViewModeAlways;
}


-(BOOL)isTelphoneNum{
    
    NSString *telRegex = @"^1[3578]\\d{9}$";
    NSPredicate *prediate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", telRegex];
    return [prediate evaluateWithObject:self.text];
}
@end
