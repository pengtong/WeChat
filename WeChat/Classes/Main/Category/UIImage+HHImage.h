//
//  UIImage+HHImage.h
//  HaHaWeiBo
//
//  Created by Pengtong on 15/6/16.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (HHImage)

+ (instancetype) imageWithName:(NSString *)name;

+ (instancetype) resizeImageWithName:(NSString *)name;

+ (instancetype)resizeImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top;

@end
