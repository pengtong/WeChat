//
//  WCRegisterViewController.m
//  WeChat
//
//  Created by Pengtong on 15/8/18.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import "WCRegisterViewController.h"
#import "WCXmppTool.h"
#import "MBProgressHUD+MJ.h"
#import "UITextField+Extend.h"

@interface WCRegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@end

@implementation WCRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(close)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.userField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.pwdField];
    
    self.registerBtn.enabled = (self.userField.text.length && self.pwdField.text.length);
    [self.registerBtn setBackgroundImage:[UIImage imageWithName:@"fts_green_btn"] forState:UIControlStateNormal];
    [self.registerBtn setBackgroundImage:[UIImage imageWithName:@"fts_green_btn_HL"] forState:UIControlStateHighlighted];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.userField resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)textChange
{
    self.registerBtn.enabled = (self.userField.text.length && self.pwdField.text.length);
}

- (IBAction)registerClick
{
    __unsafe_unretained typeof(self) weakSelf = self;
    
    [self.view endEditing:YES];
    
    if (![self.userField isTelphoneNum])
    {
        [MBProgressHUD showError:@"请输入正确的手机号码" toView:self.view];
        return;
    }
    
    [WCUserInfo sharedUserInfo].registerUser = self.userField.text;
    [WCUserInfo sharedUserInfo].registerPwd = self.pwdField.text;
    [WCXmppTool XMPPTool].registerUser = YES;
    
    [MBProgressHUD showMessage:@"正在注册..." toView:self.view];
    
    [[WCXmppTool XMPPTool] xmppRegister:^(XMPPResultType type) {
        [weakSelf handEventResultType:type];
    }];
}

- (void)handEventResultType:(XMPPResultType)type
{
    [MBProgressHUD hideHUDForView:self.view];
    
    switch (type) {
        case XMPPResultTypeRegisterSuccess:
            [MBProgressHUD showSuccess:@"注册成功" toView:self.view];
            if ([self.delegate respondsToSelector:@selector(registerViewControllerDidFinishRegister)])
            {
                [self.delegate registerViewControllerDidFinishRegister];
            }
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        case XMPPResultTypeRegisterFailure:
            [MBProgressHUD showError:@"用户名已存在" toView:self.view];
            break;
        case XMPPResultTypeNetError:
            [MBProgressHUD showError:@"网络不给力" toView:self.view];
            break;
        default:
            break;
    }
}

@end
