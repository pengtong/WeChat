//
//  UIImage+HHImage.m
//  HaHaWeiBo
//
//  Created by Pengtong on 15/6/16.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import "UIImage+HHImage.h"

@implementation UIImage (HHImage)

+ (instancetype) imageWithName:(NSString *)name
{
//    NSString *imageName = [name stringByAppendingString:@"_os7"];
//    UIImage *image = [UIImage imageNamed:imageName];
//    
//    if(image)
//    {
//        return image;
//    }
//    else
//    {
        return [UIImage imageNamed:name];
//    }
}

+ (instancetype) resizeImageWithName:(NSString *)name
{
    return [self resizeImageWithName:name left:0.5f top:0.5f];
}

+ (instancetype)resizeImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top
{
    UIImage *image = [UIImage imageWithName:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * left topCapHeight:image.size.height * top];
}

@end
