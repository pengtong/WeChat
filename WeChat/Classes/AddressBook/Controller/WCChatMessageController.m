//
//  WCChatMessageController.m
//  WeChat
//
//  Created by Pengtong on 15/8/26.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import "WCChatMessageController.h"
#import "WCXmppTool.h"
#import "XMPPMessage.h"
#import "WCUservCard.h"
#import "HttpTool.h"

#define kMyJID [XMPPJID jidWithString:[WCUserInfo sharedUserInfo].jid]


@interface WCChatMessageController () <NSFetchedResultsControllerDelegate>
{
    NSFetchedResultsController *_fetchedResultsController;
}

@property (nonatomic, strong) NSMutableArray *MesageData;
@property (strong, nonatomic) HttpTool *httpTool;
@end

@implementation WCChatMessageController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.messageSender = [WCUserInfo sharedUserInfo].jid;
    self.title = self.userInfo.userName;
    
    [self loadData];
}

- (NSMutableArray *)MesageData
{
    if (!_MesageData)
    {
        _MesageData = [NSMutableArray array];
    }
    return _MesageData;
}

- (HttpTool *)httpTool
{
    if (!_httpTool)
    {
        _httpTool = [[HttpTool alloc] init];
    }
    return _httpTool;
}

- (void)loadData
{
    NSManagedObjectContext *context = [WCXmppTool XMPPTool].msgStorge.mainThreadManagedObjectContext;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Message_CoreDataObject"];
    NSString *jidStr = [WCUserInfo sharedUserInfo].jid;
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@ AND bareJidStr = %@", jidStr, self.userInfo.jid.bare];
    WCLog(@"WCMessageViewController = %@ = %@", jidStr , self.userInfo.jid.bare);
    request.predicate = pre;
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    request.sortDescriptors = @[sort];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    _fetchedResultsController.delegate = self;
    
    NSError *error = nil;
    [_fetchedResultsController performFetch:&error];
    
    [self addMessageModel];
    
    if (error)
    {
        WCLog(@"WCMessageViewController = %@", error);
    }
}

- (void)addMessageModel
{
    [self.MesageData removeAllObjects];
    [self.messages removeAllObjects];
    
    for (XMPPMessageArchiving_Message_CoreDataObject *msgStorage in _fetchedResultsController.fetchedObjects)
    {
        NSString *chatType = [msgStorage.message attributeStringValueForName:@"bodyType"];
        UIImage *meIcon = [UIImage imageWithData:[[WCXmppTool XMPPTool].avatar photoDataForJID:kMyJID]];
        NSString *msgReceivName = [msgStorage.outgoing boolValue] ? [WCUserInfo sharedUserInfo].jid : self.userInfo.jid.bare;
        
        if ([chatType isEqualToString:@"image"])
        {
            XHMessage *photoMessage = [[XHMessage alloc] initWithPhoto:[UIImage imageNamed:@"placeholderImage"] thumbnailUrl:msgStorage.body originPhotoUrl:nil sender:msgReceivName timestamp:msgStorage.timestamp];
            photoMessage.avatar = [msgStorage.outgoing boolValue] ? meIcon : self.userInfo.userIcon;
            photoMessage.bubbleMessageType = [msgStorage.outgoing boolValue] ? XHBubbleMessageTypeSending : XHBubbleMessageTypeReceiving;
            
            [self.MesageData addObject:photoMessage];
        }
        else if ([chatType isEqualToString:@"voice"])
        {
        
        }
        else if ([chatType isEqualToString:@"video"])
        {
        
        }
        else
        {
            XHMessage *textMessage = [[XHMessage alloc] initWithText:msgStorage.body sender:msgReceivName timestamp:msgStorage.timestamp];
            textMessage.avatar = [msgStorage.outgoing boolValue] ? meIcon : self.userInfo.userIcon;
            textMessage.bubbleMessageType = [msgStorage.outgoing boolValue] ? XHBubbleMessageTypeSending : XHBubbleMessageTypeReceiving;
            [self.MesageData addObject:textMessage];
        }
    }
    self.messages = self.MesageData;
    [self.messageTableView reloadData];
    [self scrollToBottomAnimated:NO];
}


- (void)sendMsgWithText:(NSString *)text bodyType:(NSString *)bodyType
{
    
    XMPPMessage *msg = [XMPPMessage messageWithType:@"chat" to:self.userInfo.jid];
    //text 纯文本
    //image 图片
    [msg addAttributeWithName:@"bodyType" stringValue:bodyType];
    
    [msg addBody:text];
    
    [[WCXmppTool XMPPTool].xmppStream sendElement:msg];
}

- (BOOL)shouldPreventScrollToBottomWhileUserScrolling {
    return YES;
}

#pragma mark --NSFetchedResultsControllerDelegate
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self addMessageModel];
}
@end
