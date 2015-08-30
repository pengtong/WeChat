//
//  WCChatViewController.m
//  WeChat
//
//  Created by Pengtong on 15/8/23.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import "WCChatViewController.h"
#import "WCXmppTool.h"
#import "XMPPvCardTempModule.h"

@interface WCChatViewController ()

@end

@implementation WCChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.tabBarController.tabBar.selectedItem.selectedImage = [[UIImage imageNamed:@"tabbar_mainframeHL"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
