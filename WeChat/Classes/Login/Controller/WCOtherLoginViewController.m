//
//  WCOtherLoginViewController.m
//  WeChat
//
//  Created by Pengtong on 15/8/16.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import "WCOtherLoginViewController.h"
#import "MBProgressHUD+MJ.h"
#import "AppDelegate.h"


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
    
    [self.loginBtn setBackgroundImage:[UIImage imageWithName:@"fts_green_btn"] forState:UIControlStateNormal];
    [self.loginBtn setBackgroundImage:[UIImage imageWithName:@"fts_green_btn_HL"] forState:UIControlStateHighlighted];
}

- (void)dealloc
{
    WCLog(@"WCOtherLoginViewController -- dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    self.loginBtn.enabled = (self.userField.text.length && self.pwdField.text.length);
}

- (void)setField:(UITextField *)field forKey:(NSString *)key
{
    if (field.text != nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:field.text forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (IBAction)login
{
    [self setField:self.userField forKey:KeyUser];
    [self setField:self.pwdField forKey:KeyPwd];
    __unsafe_unretained typeof(self)weakSelf = self;
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [MBProgressHUD showMessage:@"正在登录..." toView:self.view];
    [appDelegate xmppLogin:^(XMPPResultType type) {
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
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.view.window.rootViewController = story.instantiateInitialViewController;
}

@end
