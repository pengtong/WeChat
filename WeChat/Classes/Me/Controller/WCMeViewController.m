//
//  WCMeViewController.m
//  WeChat
//
//  Created by Pengtong on 15/8/17.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import "WCMeViewController.h"
#import "WCXmppTool.h"
#import "XMPPvCardTempModule.h"
#import "XMPPvCardTemp.h"
#import "WCProfileController.h"
#import "WCNavigationController.h"
#import "WCUserInfo.h"

@interface WCMeViewController ()<WCProfileControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *headBgView;
@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end

@implementation WCMeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我";
    
    [self setupContnetView];
}

- (void)setupContnetView
{
    self.headBgView.layer.cornerRadius = 5;
    self.headBgView.layer.borderWidth = 1;
    self.headBgView.layer.borderColor = [UIColor grayColor].CGColor;
    
    XMPPvCardTemp *vCardTemp = [WCXmppTool XMPPTool].vCard.myvCardTemp;
    
    if (vCardTemp.photo)
    {
        self.headView.image = [UIImage imageWithData:vCardTemp.photo];
    }
    self.nicknameLabel.text = vCardTemp.nickname ? vCardTemp.nickname : [WCUserInfo sharedUserInfo].user;
    self.numberLabel.text = [NSString stringWithFormat:@"微信号: %@", [WCUserInfo sharedUserInfo].user];
    
    [WCUserInfo sharedUserInfo].imageData = UIImagePNGRepresentation(self.headView.image);
    [[WCUserInfo sharedUserInfo] saveUserInfo];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.selectedItem.selectedImage = [[UIImage imageNamed:@"tabbar_meHL"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    id destVC = segue.destinationViewController;
    
    if ([destVC isKindOfClass:[WCProfileController class]])
    {
        WCProfileController *profileVC = (WCProfileController *)destVC;
        profileVC.delegate = self;
    }
    
}

- (void)awakeFromNib
{

}
#pragma mark --UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.tag == 1)
    {
        [self performSegueWithIdentifier:@"profileHeadIcon" sender:nil];
    }
}

#pragma mark --WCProfileControllerDelegate
- (void)profileController:(WCProfileController *)profileController didChangeHeadIcon:(UIImage *)headIcon
{
    self.headView.image = headIcon;
    [WCUserInfo sharedUserInfo].imageData = UIImagePNGRepresentation(headIcon);
    [[WCUserInfo sharedUserInfo] saveUserInfo];
}

- (void)profileController:(WCProfileController *)profileController didChangeNickName:(NSString *)nickName
{
    self.nicknameLabel.text = nickName;
}
@end
