//
//  WCRegisterViewController.h
//  WeChat
//
//  Created by Pengtong on 15/8/18.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WCRegisterViewController;

@protocol WCRegisterViewControllerDelegate <NSObject>

@optional
- (void)registerViewControllerDidFinishRegister;
@end

@interface WCRegisterViewController : UIViewController

@property (nonatomic, weak) id<WCRegisterViewControllerDelegate> delegate;

@end
