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
#import <MessageDisplayKit/XHDisplayTextViewController.h>
#import <MessageDisplayKit/XHDisplayMediaViewController.h>
#import <MessageDisplayKit/XHDisplayLocationViewController.h>
#import <MessageDisplayKit/XHAudioPlayerHelper.h>


#define kMyJID [XMPPJID jidWithString:[WCUserInfo sharedUserInfo].jid]


@interface WCChatMessageController () <NSFetchedResultsControllerDelegate, XHAudioPlayerHelperDelegate>
{
    NSFetchedResultsController *_fetchedResultsController;
}
@property (nonatomic, strong) XHMessageTableViewCell *currentSelectedCell;
@property (nonatomic, strong) NSArray *emotionManagers;
@property (nonatomic, strong) NSMutableArray *MesageData;
@property (strong, nonatomic) HttpTool *httpTool;
@end

@implementation WCChatMessageController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.messageSender = [WCUserInfo sharedUserInfo].jid;
    self.title = self.userInfo.userName;
    [self loadThreeData];
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[XHAudioPlayerHelper shareInstance] stopAudio];
}

- (void)dealloc
{
    self.emotionManagers = nil;
    [[XHAudioPlayerHelper shareInstance] setDelegate:nil];
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

- (void)loadThreeData
{
    // 添加第三方接入数据
    NSMutableArray *shareMenuItems = [NSMutableArray array];
    NSArray *plugIcons = @[@"sharemore_pic"];
    NSArray *plugTitle = @[@"照片"];
    
    for (NSString *plugIcon in plugIcons)
    {
        XHShareMenuItem *shareMenuItem = [[XHShareMenuItem alloc] initWithNormalIconImage:[UIImage imageNamed:plugIcon] title:[plugTitle objectAtIndex:[plugIcons indexOfObject:plugIcon]]];
        [shareMenuItems addObject:shareMenuItem];
    }
    
    NSMutableArray *emotionManagers = [NSMutableArray array];
    for (NSInteger i = 0; i < 1; i ++)
    {
        XHEmotionManager *emotionManager = [[XHEmotionManager alloc] init];
        emotionManager.emotionName = [NSString stringWithFormat:@"表情%ld", (long)i];
        NSMutableArray *emotions = [NSMutableArray array];
        for (NSInteger j = 0; j < 16; j ++)
        {
            XHEmotion *emotion = [[XHEmotion alloc] init];
            NSString *imageName = [NSString stringWithFormat:@"section%ld_emotion%ld", (long)i , (long)j % 16];
            emotion.emotionPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"emotion%ld.gif", (long)j] ofType:@""];
            emotion.emotionConverPhoto = [UIImage imageNamed:imageName];
            [emotions addObject:emotion];
        }
        emotionManager.emotions = emotions;
        
        [emotionManagers addObject:emotionManager];
    }
    
    self.emotionManagers = emotionManagers;
    [self.emotionManagerView reloadData];
    
    self.shareMenuItems = shareMenuItems;
    [self.shareMenuView reloadData];
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
#pragma mark - XHAudioPlayerHelper Delegate

- (void)didAudioPlayerStopPlay:(AVAudioPlayer *)audioPlayer
{
    if (!_currentSelectedCell)
    {
        return;
    }
    [_currentSelectedCell.messageBubbleView.animationVoiceImageView stopAnimating];
    self.currentSelectedCell = nil;
}

#pragma mark - XHEmotionManagerView DataSource

- (NSInteger)numberOfEmotionManagers
{
    return self.emotionManagers.count;
}

- (XHEmotionManager *)emotionManagerForColumn:(NSInteger)column
{
    return [self.emotionManagers objectAtIndex:column];
}

- (NSArray *)emotionManagersAtManager
{
    return self.emotionManagers;
}

#pragma mark -- XHMessageTableViewCell delegate

- (void)multiMediaMessageDidSelectedOnMessage:(id<XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath onMessageTableViewCell:(XHMessageTableViewCell *)messageTableViewCell
{
    UIViewController *disPlayViewController;
    switch (message.messageMediaType)
    {
        case XHBubbleMessageMediaTypeVideo:
        case XHBubbleMessageMediaTypePhoto:
        {
            WCLog(@"message : %@", message.photo);
            WCLog(@"message : %@", message.videoConverPhoto);
            XHDisplayMediaViewController *messageDisplayTextView = [[XHDisplayMediaViewController alloc] init];
            messageDisplayTextView.message = message;
            disPlayViewController = messageDisplayTextView;
        }
            break;
        case XHBubbleMessageMediaTypeVoice:
        {
            WCLog(@"message : %@", message.voicePath);
            
            // Mark the voice as read and hide the red dot.
            message.isRead = YES;
            messageTableViewCell.messageBubbleView.voiceUnreadDotImageView.hidden = YES;
            
            [[XHAudioPlayerHelper shareInstance] setDelegate:(id<NSFileManagerDelegate>)self];
            if (_currentSelectedCell)
            {
                [_currentSelectedCell.messageBubbleView.animationVoiceImageView stopAnimating];
            }
            if (_currentSelectedCell == messageTableViewCell)
            {
                [messageTableViewCell.messageBubbleView.animationVoiceImageView stopAnimating];
                [[XHAudioPlayerHelper shareInstance] stopAudio];
                self.currentSelectedCell = nil;
            }
            else
            {
                self.currentSelectedCell = messageTableViewCell;
                [messageTableViewCell.messageBubbleView.animationVoiceImageView startAnimating];
                [[XHAudioPlayerHelper shareInstance] managerAudioWithFileName:message.voicePath toPlay:YES];
            }
            break;
        }
        case XHBubbleMessageMediaTypeEmotion:
            WCLog(@"facePath : %@", message.emotionPath);
            break;
        case XHBubbleMessageMediaTypeLocalPosition:
        {
            WCLog(@"facePath : %@", message.localPositionPhoto);
            XHDisplayLocationViewController *displayLocationViewController = [[XHDisplayLocationViewController alloc] init];
            displayLocationViewController.message = message;
            disPlayViewController = displayLocationViewController;
            break;
        }
        default:
            break;
    }
    
    if (disPlayViewController)
    {
        [self.navigationController pushViewController:disPlayViewController animated:YES];
    }
}

/**
 *  发送文本消息的回调方法
 *
 *  @param text   目标文本字符串
 *  @param sender 发送者的名字
 *  @param date   发送时间
 */
- (void)didSendText:(NSString *)text fromSender:(NSString *)sender onDate:(NSDate *)date
{
    [self sendMsgWithText:text bodyType:@"text"];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeText];
}

/**
 *  发送图片消息的回调方法
 *
 *  @param photo  目标图片对象，后续有可能会换
 *  @param sender 发送者的名字
 *  @param date   发送时间
 */
- (void)didSendPhoto:(UIImage *)photo fromSender:(NSString *)sender onDate:(NSDate *)date
{
    NSString *user = [WCUserInfo sharedUserInfo].user;
    
    NSDateFormatter *dataFormatter = [[NSDateFormatter alloc] init];
    dataFormatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *timeStr = [dataFormatter stringFromDate:[NSDate date]];
    NSString *fileName = [user stringByAppendingString:timeStr];
    
    NSString *uploadUrl = [@"http://localhost:8080/imfileserver/Upload/Image/" stringByAppendingString:fileName];
    
    // HTTP put 上传
#warning 服务器只接接收jpg
    [self.httpTool uploadData:UIImageJPEGRepresentation(photo, 0.75) url:[NSURL URLWithString:uploadUrl] progressBlock:nil completion:^(NSError *error) {
        
        if (!error)
        {
            NSLog(@"上传成功");
            [self sendMsgWithText:uploadUrl bodyType:@"image"];
        }
    }];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypePhoto];
}

/**
 *  发送视频消息的回调方法
 *
 *  @param videoPath 目标视频本地路径
 *  @param sender    发送者的名字
 *  @param date      发送时间
 */
- (void)didSendVideoConverPhoto:(UIImage *)videoConverPhoto videoPath:(NSString *)videoPath fromSender:(NSString *)sender onDate:(NSDate *)date {
    XHMessage *videoMessage = [[XHMessage alloc] initWithVideoConverPhoto:videoConverPhoto videoPath:videoPath videoUrl:nil sender:sender timestamp:date];
    videoMessage.avatar = [UIImage imageNamed:@"avatar"];
    videoMessage.avatarUrl = @"http://www.pailixiu.com/jack/meIcon@2x.png";
    [self addMessage:videoMessage];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeVideo];
}

/**
 *  发送语音消息的回调方法
 *
 *  @param voicePath        目标语音本地路径
 *  @param voiceDuration    目标语音时长
 *  @param sender           发送者的名字
 *  @param date             发送时间
 */
- (void)didSendVoice:(NSString *)voicePath voiceDuration:(NSString *)voiceDuration fromSender:(NSString *)sender onDate:(NSDate *)date
{
    XHMessage *voiceMessage = [[XHMessage alloc] initWithVoicePath:voicePath voiceUrl:nil voiceDuration:voiceDuration sender:self.userInfo.jid.bare timestamp:date];
    voiceMessage.avatar =  [UIImage imageWithData:[[WCXmppTool XMPPTool].avatar photoDataForJID:kMyJID]];;
    voiceMessage.bubbleMessageType = XHBubbleMessageTypeSending;
    [self addMessage:voiceMessage];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeVoice];
}

/**
 *  发送第三方表情消息的回调方法
 *
 *  @param facePath 目标第三方表情的本地路径
 *  @param sender   发送者的名字
 *  @param date     发送时间
 */
- (void)didSendEmotion:(NSString *)emotionPath fromSender:(NSString *)sender onDate:(NSDate *)date
{
    XHMessage *emotionMessage = [[XHMessage alloc] initWithEmotionPath:emotionPath sender:[WCUserInfo sharedUserInfo].jid timestamp:[NSDate date]];
    emotionMessage.avatar = self.userInfo.userIcon;
    emotionMessage.bubbleMessageType = XHBubbleMessageTypeReceiving;
    [self addMessage:emotionMessage];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeEmotion];
}

- (BOOL)shouldPreventScrollToBottomWhileUserScrolling
{
    return YES;
}

- (BOOL)shouldDisplayTimestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 1)
    {
        XHMessage *messagePre = self.messages[indexPath.row - 1];
        XHMessage *messageNext = self.messages[indexPath.row];
        
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"MM-dd HH:mm";
        NSString *dataPre = [fmt stringFromDate:messagePre.timestamp];
        NSString *dateNext = [fmt stringFromDate:messageNext.timestamp];
        
        if ([dataPre isEqualToString:dateNext])
        {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark -- NSFetchedResultsControllerDelegate
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self addMessageModel];
}
@end
