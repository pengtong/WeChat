//
//  WCLoginViewController.m
//  WeChat
//
//  Created by Pengtong on 15/8/18.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import "WCLoginViewController.h"
#import "WCRegisterViewController.h"
#import "WCNavigationController.h"
#import "UITextField+Extend.h"

@interface WCLoginViewController ()<WCRegisterViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *userLabel;

@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@end

@implementation WCLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.userLabel.text = [WCUserInfo sharedUserInfo].user;
    [self.pwdField addLeftViewWithImage:@"Card_Lock"];
    [self.loginBtn setBackgroundImage:[UIImage imageWithName:@"fts_green_btn"] forState:UIControlStateNormal];
    [self.loginBtn setBackgroundImage:[UIImage imageWithName:@"fts_green_btn_HL"] forState:UIControlStateHighlighted];
    self.loginBtn.enabled = (self.userLabel.text.length && self.pwdField.text.length);
    
    if ([WCUserInfo sharedUserInfo].imageData)
    {
        self.headView.image = [UIImage imageWithData:[WCUserInfo sharedUserInfo].imageData];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.pwdField];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)textChange
{
    self.loginBtn.enabled = (self.userLabel.text.length && self.pwdField.text.length);
}

- (IBAction)login
{
    [WCUserInfo sharedUserInfo].pwd = self.pwdField.text;
    [WCUserInfo sharedUserInfo].user = self.userLabel.text;
    
    [super login];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    WCNavigationController *destVC = (WCNavigationController *)segue.destinationViewController;

    if ([destVC.topViewController isKindOfClass:[WCRegisterViewController class]])
    {
        WCRegisterViewController *registerVC = (WCRegisterViewController *)destVC.topViewController;
        registerVC.delegate = self;
    }
}

#pragma mark --WCRegisterViewControllerDelegate

- (void)registerViewControllerDidFinishRegister
{
    WCLog(@"%@", [NSThread currentThread]);
    dispatch_sync(dispatch_get_main_queue(), ^{
        self.userLabel.text = [WCUserInfo sharedUserInfo].registerUser;
    });
}

@end
