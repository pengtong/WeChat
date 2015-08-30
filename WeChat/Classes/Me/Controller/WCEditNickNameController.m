//
//  WCEditNickNameController.m
//  WeChat
//
//  Created by Pengtong on 15/8/23.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import "WCEditNickNameController.h"

@interface WCEditNickNameController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation WCEditNickNameController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"名字";
    [self setuptextField];
    [self setupBarButtonItem];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.textField becomeFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)setuptextField
{
    UIView *view = [[UIView alloc] init];
    view.width = 10;
    view.height = self.textField.height;
    self.textField.leftView = view;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChangeValue) name:UITextFieldTextDidChangeNotification object:self.textField];
    
    self.textField.text = self.cell.detailTextLabel.text;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupBarButtonItem
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveNickName)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:14/255.0 green:180/255.0 blue:0 alpha:1.0];
}

- (void)textChangeValue
{
    self.navigationItem.rightBarButtonItem.enabled = self.textField.text.length;
}

- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveNickName
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    self.cell.detailTextLabel.text = self.textField.text;
    if ([self.delegate respondsToSelector:@selector(editNickNameDidFinish:)])
    {
        [self.delegate editNickNameDidFinish:self];
    }
}
@end
