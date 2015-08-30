//
//  WCProfileController.m
//  WeChat
//
//  Created by Pengtong on 15/8/23.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import "WCProfileController.h"
#import "XMPPvCardTemp.h"
#import "WCNavigationController.h"
#import "WCEditNickNameController.h"
#import "WCXmppTool.h"

@interface WCProfileController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, WCEditNickNameControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *headBgView;
@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end

@implementation WCProfileController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"个人信息";

    [self loadvCard];
}

- (void)loadvCard
{
    XMPPvCardTemp *vCardTemp = [WCXmppTool XMPPTool].vCard.myvCardTemp;
    
    if (vCardTemp.photo)
    {
        self.headView.image = [UIImage imageWithData:vCardTemp.photo];
    }
    self.nicknameLabel.text = vCardTemp.nickname ? vCardTemp.nickname : [WCUserInfo sharedUserInfo].user;
    self.numberLabel.text = [WCUserInfo sharedUserInfo].user;
    
    self.headBgView.layer.cornerRadius = 5;
    self.headBgView.layer.borderWidth = 1;
    self.headBgView.layer.borderColor = [UIColor grayColor].CGColor;
}

- (void)setupAlertComtroller
{
    __unsafe_unretained typeof(self) weakSelf = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIImagePickerController *imagePick = [[UIImagePickerController alloc] init];
    imagePick.delegate = self;
    imagePick.allowsEditing = YES;
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        imagePick.sourceType = UIImagePickerControllerSourceTypeCamera;
        [weakSelf presentViewController:imagePick animated:YES completion:nil];
    }];
    UIAlertAction *alumAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        imagePick.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [weakSelf presentViewController:imagePick animated:YES completion:nil];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:cameraAction];
    [alertController addAction:alumAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell *)sender
{
    WCNavigationController *destVC = (WCNavigationController *)segue.destinationViewController;
    
    if ([destVC.topViewController isKindOfClass:[WCEditNickNameController class]])
    {
        WCEditNickNameController *editNickNameVC = (WCEditNickNameController *)destVC.topViewController;
        editNickNameVC.delegate = self;
        editNickNameVC.cell = sender;
    }
}

#pragma mark --WCEditNickNameControllerDelegate
- (void)editNickNameDidFinish:(WCEditNickNameController *)editNickNameController
{
    XMPPvCardTemp *vCardTemp = [WCXmppTool XMPPTool].vCard.myvCardTemp;
    vCardTemp.nickname = editNickNameController.cell.detailTextLabel.text;
    [[WCXmppTool XMPPTool].vCard updateMyvCardTemp:vCardTemp];
    
    if ([self.delegate respondsToSelector:@selector(profileController:didChangeNickName:)])
    {
        [self.delegate profileController:self didChangeNickName:vCardTemp.nickname];
    }
}

#pragma mark --UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    if (1 == cell.tag)
    {
        [self setupAlertComtroller];
    }
    else
    {
        [self performSegueWithIdentifier:@"editnickname" sender:cell];
    }
}

#pragma mark --UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.headView.image = info[UIImagePickerControllerEditedImage];
    
    if ([self.delegate respondsToSelector:@selector(profileController:didChangeHeadIcon:)])
    {
        [self.delegate profileController:self didChangeHeadIcon:self.headView.image];
    }
    
    XMPPvCardTemp *vCardTemp = [WCXmppTool XMPPTool].vCard.myvCardTemp;
    vCardTemp.photo = UIImagePNGRepresentation(self.headView.image);
    [[WCXmppTool XMPPTool].vCard updateMyvCardTemp:vCardTemp];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
