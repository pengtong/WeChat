//
//  WCBaseLoginViewController.m
//  WeChat
//
//  Created by Pengtong on 15/8/18.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import "WCBaseLoginViewController.h"
#import "WCXmppTool.h"
#import "MBProgressHUD+MJ.h"

@interface WCBaseLoginViewController ()

@end

@implementation WCBaseLoginViewController

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)login
{
    __unsafe_unretained typeof(self)weakSelf = self;
    
    [self.view endEditing:YES];
    [WCXmppTool XMPPTool].registerUser = NO;
    [MBProgressHUD showMessage:@"正在登录..." toView:self.view];
    [[WCXmppTool XMPPTool] xmppLogin:^(XMPPResultType type) {
        [weakSelf handEventXMPPResultType:type];
    }];
}

- (void)handEventXMPPResultType:(XMPPResultType)type
{
    __unsafe_unretained typeof(self)weakSelf = self;
    [MBProgressHUD hideHUDForView:self.view];
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        switch (type) {
            case XMPPResultTypeSuccess:
                [weakSelf entryMain];
                break;
            case XMPPResultTypeFailure:
                [MBProgressHUD showError:@"用户名或者密码错误" toView:self.view];
                break;
            case XMPPResultTypeNetError:
                [MBProgressHUD showError:@"网络不给力" toView:self.view];
                break;
            default:
                break;
        }
    });
    
}

- (void)entryMain
{
    [WCUserInfo sharedUserInfo].status = YES;
    [[WCUserInfo sharedUserInfo] saveUserInfo];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    [UIApplication sharedApplication].keyWindow.rootViewController = story.instantiateInitialViewController;
}

@end
