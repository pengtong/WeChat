//
//  WCMessageViewController.m
//  WeChat
//
//  Created by Pengtong on 15/8/27.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import "WCMessageViewController.h"
#import "WCXmppTool.h"
#import "Message.h"
#import "MessageCell.h"
#import "MessageFrame.h"
#import "XMPPMessage.h"
#import "WCUservCard.h"

#define kMyJID [XMPPJID jidWithString:[WCUserInfo sharedUserInfo].jid]

@interface WCMessageViewController () <UITextViewDelegate, UITableViewDataSource,UITableViewDelegate, NSFetchedResultsControllerDelegate>
{
    NSFetchedResultsController *_fetchedResultsController;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttomConstraint;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic, strong) NSMutableArray *MesageData;

@end

@implementation WCMessageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.userInfo.userName;
    self.tableView.allowsSelection = NO;
    self.tableView.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1.0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self loadData];
    
    WCLog(@"%@", self.userInfo);
}

- (void)keyboardShow:(NSNotification *)notfication
{
    WCLog(@"%@", notfication);
    
    CGRect keyboardRect = [notfication.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    self.buttomConstraint.constant = keyboardRect.size.height;
    
    [self scrollToTableBottom];
}

- (void)keyboardHide:(NSNotification *)notfication
{
    WCLog(@"%@", notfication);
    
    CGRect keyboardRect = [notfication.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    self.buttomConstraint.constant -= keyboardRect.size.height;
}

- (NSMutableArray *)MesageData
{
    if (!_MesageData)
    {
        _MesageData = [NSMutableArray array];
    }
    return _MesageData;
}

//- (void)loadData2
//{
//    // 上下文
//    NSManagedObjectContext *context = [WCXmppTool XMPPTool].msgStorge.mainThreadManagedObjectContext;
//    // 请求对象
//    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Message_CoreDataObject"];
//    
//    
//    // 过滤、排序
//    // 1.当前登录用户的JID的消息
//    // 2.好友的Jid的消息
//    NSPredicate *pre = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@ AND bareJidStr = %@",[WCUserInfo sharedUserInfo].jid,self.userInfo.jid];
//    NSLog(@"%@",pre);
//    request.predicate = pre;
//    
//    // 时间升序
//    NSSortDescriptor *timeSort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
//    request.sortDescriptors = @[timeSort];
//    
//    // 查询
//    _resultsContr = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
//    
//    NSError *err = nil;
//    // 代理
//    _resultsContr.delegate = self;
//    
//    [_resultsContr performFetch:&err];
//    
//    NSLog(@"%@",_resultsContr.fetchedObjects);
//    if (err) {
//        WCLog(@"%@",err);
//    }
//}

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
    [self scrollToTableBottom];
    if (error)
    {
        WCLog(@"WCMessageViewController = %@", error);
    }
}

- (void)addMessageModel
{
    [self.MesageData removeAllObjects];
    
    for (XMPPMessageArchiving_Message_CoreDataObject *msgStorage in _fetchedResultsController.fetchedObjects)
    {
        MessageFrame *msgFrame = [[MessageFrame alloc] init];
        MessageFrame *lastFrame = [self.MesageData lastObject];
        Message *message = [[Message alloc] init];
        message.text = msgStorage.body;
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"MM-dd HH:mm";
        message.time = [fmt stringFromDate:msgStorage.timestamp];
        UIImage *meIcon = [UIImage imageWithData:[[WCXmppTool XMPPTool].avatar photoDataForJID:kMyJID]];
        message.iconImage = [msgStorage.outgoing boolValue] ? meIcon : self.userInfo.userIcon;
        message.showTime = [lastFrame.msg.time isEqualToString:message.time] ? NO : YES;
        message.type = [msgStorage.outgoing boolValue] ? MessageTypeMe : MessageTypeOther;
        msgFrame.msg = message;
        [self.MesageData addObject:msgFrame];
    }
}

-(void)scrollToTableBottom
{
    NSInteger lastRow = self.MesageData.count - 1;
    
    if (lastRow < 0)
    {
        //行数如果小于0，不能滚动
        return;
    }
    
    NSIndexPath *lastPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
    
    [self.tableView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
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

#pragma mark --UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UITableView class]])
    {
//        [self.textView resignFirstResponder];
    }
}

#pragma mark --NSFetchedResultsControllerDelegate
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self addMessageModel];
    [self.tableView reloadData];
    [self scrollToTableBottom];
}

#pragma mark --UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    WCLog(@"%@", textView.text);
    
    if ([textView.text rangeOfString:@"\n"].length != 0)
    {
        NSString *text = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [self sendMsgWithText:text bodyType:@"text"];
        textView.text = @"";
        [self.textView resignFirstResponder];
    }
}
#pragma mark --UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.MesageData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageCell *cell = [MessageCell cellWithTableView:tableView];
    cell.msgFrame = self.MesageData[indexPath.row];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageFrame *msgFrame = self.MesageData[indexPath.row];
    
    return msgFrame.cellHeight;
}

@end
