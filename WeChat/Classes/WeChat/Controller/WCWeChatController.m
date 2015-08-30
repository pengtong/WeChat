//
//  WCWeChatController.m
//  WeChat
//
//  Created by Pengtong on 15/8/30.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import "WCWeChatController.h"
#import "WCXmppTool.h"

@interface WCWeChatController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation WCWeChatController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tabBarController.tabBar.selectedItem.selectedImage = [[UIImage imageNamed:@"tabbar_mainframeHL"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xmppToolStatusChange:) name:WCXmppToolStatusChangeNotification object:nil];
}

- (void)xmppToolStatusChange:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        switch ([notification.userInfo[WCXmppToolStatusKey] integerValue])
        {
                
            case XMPPResultTypeConnect:
                [self.activityView startAnimating];
                self.titleLabel.text = @"连接中...";
                break;
            case XMPPResultTypeSuccess:
                [self.activityView stopAnimating];
                self.titleLabel.text = @"微信";
                break;
            case XMPPResultTypeFailure:
                [self.activityView stopAnimating];
                self.titleLabel.text = @"微信(未连接)";
                break;
            default:
                break;
        }
    });

}

@end
