//
//  WCDiscoverController.m
//  WeChat
//
//  Created by Pengtong on 15/8/31.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import "WCDiscoverController.h"
#import "WCShakeViewController.h"
#import "WCQRCodeViewController.h"
#import "WCBottleViewController.h"

@interface WCDiscoverController ()

@end

@implementation WCDiscoverController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"发现";
    self.tabBarController.tabBar.selectedItem.selectedImage = [[UIImage imageNamed:@"tabbar_discoverHL"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section)
    {
        case 1:
        {
            if (indexPath.row)
            {
                [self.navigationController pushViewController:[[WCShakeViewController alloc] init] animated:YES];
            }
            else
            {
                [self.navigationController pushViewController:[[WCQRCodeViewController alloc] init] animated:YES];
            }
            break;
        }
        case 2:
        {
            if (indexPath.row)
            {
                [self.navigationController pushViewController:[[WCBottleViewController alloc] init] animated:YES];
            }
            break;
        }
        default:
            break;
    }
}
@end
