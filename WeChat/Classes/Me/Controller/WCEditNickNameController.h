//
//  WCEditNickNameController.h
//  WeChat
//
//  Created by Pengtong on 15/8/23.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WCEditNickNameController;

@protocol WCEditNickNameControllerDelegate <NSObject>

@optional
- (void)editNickNameDidFinish:(WCEditNickNameController *)editNickNameController;

@end


@interface WCEditNickNameController : UITableViewController

@property (nonatomic, strong) UITableViewCell *cell;
@property (nonatomic, weak) id<WCEditNickNameControllerDelegate> delegate;

@end
