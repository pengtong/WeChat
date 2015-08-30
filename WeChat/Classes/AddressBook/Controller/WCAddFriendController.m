//
//  WCAddFriendController.m
//  WeChat
//
//  Created by Pengtong on 15/8/25.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import "WCAddFriendController.h"
#import "UITextField+Extend.h"
#import "MBProgressHUD+MJ.h"
#import "WCXmppTool.h"
#import "WCUserInfo.h"
#import "XMPPJID.h"

@interface WCAddFriendController ()<UIScrollViewDelegate, UITextFieldDelegate, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation WCAddFriendController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"添加朋友";
    
    [self.textField addLeftViewWithImage:@"add_friend_searchicon"];
}

#pragma mark --UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    
    NSString *jid = [NSString stringWithFormat:@"%@@%@", textField.text, domin];
    XMPPJID *friendJID = [XMPPJID jidWithString:jid];
    
    if ([[WCXmppTool XMPPTool].rosterStorge userExistsWithJID:friendJID xmppStream:[WCXmppTool XMPPTool].xmppStream])
    {
        [MBProgressHUD showError:@"不能添加自己做好友" toView:self.view];
        return YES;
    }
    
    [[WCXmppTool XMPPTool].roster subscribePresenceToUser:friendJID];
    
    
    return YES;
}

#pragma mark --UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

@end
