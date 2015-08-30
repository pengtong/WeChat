//
//  WCProfileController.h
//  WeChat
//
//  Created by Pengtong on 15/8/23.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WCProfileController;

@protocol WCProfileControllerDelegate <NSObject>

@optional
- (void)profileController:(WCProfileController *)profileController didChangeHeadIcon:(UIImage *)headIcon;

- (void)profileController:(WCProfileController *)profileController didChangeNickName:(NSString *)nickName;
@end


@interface WCProfileController : UITableViewController

@property (nonatomic, weak) id<WCProfileControllerDelegate> delegate;

@end
