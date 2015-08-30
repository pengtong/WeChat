//
//  WCOtherLoginViewController.m
//  WeChat
//
//  Created by Pengtong on 15/8/16.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import "WCOtherLoginViewController.h"
#import "MBProgressHUD+MJ.h"
#import "WCXmppTool.h"


@interface WCOtherLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation WCOtherLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(close)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.userField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.pwdField];
    
    self.loginBtn.enabled = (self.userField.text.length && self.pwdField.text.length);
    [self.loginBtn setBackgroundImage:[UIImage imageWithName:@"fts_green_btn"] forState:UIControlStateNormal];
    [self.loginBtn setBackgroundImage:[UIImage imageWithName:@"fts_green_btn_HL"] forState:UIControlStateHighlighted];
}

- (void)dealloc
{
    WCLog(@"WCOtherLoginViewController -- dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)textChange
{
    self.loginBtn.enabled = (self.userField.text.length && self.pwdField.text.length);
}

- (IBAction)login
{
    [WCUserInfo sharedUserInfo].user = self.userField.text;
    [WCUserInfo sharedUserInfo].pwd = self.pwdField.text;
    
    [super login];
}



@end
