//
//  WCAddressBookController.m
//  WeChat
//
//  Created by Pengtong on 15/8/24.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import "WCAddressBookController.h"
#import "WCXmppTool.h"
#import "WCUserInfo.h"
#import "WCMessageViewController.h"
#import "WCChatMessageController.h"
#import "WCChatUserInfo.h"
#import "WCFriendCell.h"

@interface WCAddressBookController ()<NSFetchedResultsControllerDelegate>
{
    NSFetchedResultsController *_fetchedResultsController;
}
@end

@implementation WCAddressBookController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
     self.tabBarController.tabBar.selectedItem.selectedImage = [[UIImage imageNamed:@"tabbar_contactsHL"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self loadData];
}


- (void)loadData
{
    NSManagedObjectContext *context = [WCXmppTool XMPPTool].rosterStorge.mainThreadManagedObjectContext;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPUserCoreDataStorageObject"];
    NSString *jidStr = [WCUserInfo sharedUserInfo].jid;
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@", jidStr];
    request.predicate = pre;
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    request.sortDescriptors = @[sort];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    _fetchedResultsController.delegate = self;
    
    NSError *error = nil;
    [_fetchedResultsController performFetch:&error];
    
    if (error)
    {
        WCLog(@"WCAddressBookController = %@", error);
    }
}

#pragma mark --NSFetchedResultsControllerDelegate
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _fetchedResultsController.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WCFriendCell*cell = [tableView dequeueReusableCellWithIdentifier:@"contact" forIndexPath:indexPath];
   
    XMPPUserCoreDataStorageObject *userStorage = _fetchedResultsController.fetchedObjects[indexPath.row];
    NSRange range = [userStorage.jidStr rangeOfString:@"@"];
    NSString *name = [userStorage.jidStr substringToIndex:range.location];
    cell.nameLabel.text = userStorage.nickname ? userStorage.nickname : name;
    
    UIImage *image = [UIImage imageWithData:[[WCXmppTool XMPPTool].avatar photoDataForJID:userStorage.jid]];
    
    if (image)
    {
        cell.iconImage.image = image;
    }
    else
    {
        cell.iconImage.image = [UIImage imageWithName:@"DefaultHead"];
    }
    
    return cell;
}

#pragma mark --UITableViewDelegate
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        XMPPUserCoreDataStorageObject *userStorage = _fetchedResultsController.fetchedObjects[indexPath.row];
        
        XMPPJID *jid = userStorage.jid;
        [[WCXmppTool XMPPTool].roster removeUser:jid];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
//    WCChatMessageController *chatMagVC = [[WCChatMessageController alloc] init];
//    [self.navigationController pushViewController:chatMagVC animated:YES];
    WCFriendCell *cell = (WCFriendCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    XMPPUserCoreDataStorageObject *friendStorage = _fetchedResultsController.fetchedObjects[indexPath.row];
    WCChatUserInfo *userInfo = [[WCChatUserInfo alloc] init];
    
    userInfo.userName = cell.nameLabel.text;
    userInfo.userIcon = cell.iconImage.image;
    userInfo.jid = friendStorage.jid;
    [self performSegueWithIdentifier:@"chatmsg" sender:userInfo];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(WCChatUserInfo *)sender
{
    id destVC = segue.destinationViewController;
    if ([destVC isKindOfClass:[WCMessageViewController class]])
    {
        WCMessageViewController *msgVC = (WCMessageViewController *)destVC;
        msgVC.userInfo = sender;
    }
}

@end
