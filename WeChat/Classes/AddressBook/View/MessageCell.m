//
//  MessageCell.m
//  QQChat
//
//  Created by Pengtong on 14-12-30.
//  Copyright (c) 2014年 Pengtong. All rights reserved.
//

#import "MessageCell.h"
#import "Message.h"

@implementation MessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self != nil) {
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = [UIFont systemFontOfSize:10];
        timeLabel.textColor = [UIColor grayColor];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:timeLabel];
        _timeLabel = timeLabel;
        
        UIButton *iconButton = [[UIButton alloc] init];
        [self.contentView addSubview:iconButton];
        _iconButton = iconButton;
        
        UIButton *textButton = [[UIButton alloc] init];
        textButton.titleLabel.numberOfLines = 0;
        textButton.titleLabel.font = kMessageTextFont;
        textButton.contentEdgeInsets = UIEdgeInsetsMake(kTextEdgeInsets, kTextEdgeInsets, kTextEdgeInsets, kTextEdgeInsets);
        [textButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.contentView addSubview:textButton];
        _textButton = textButton;
        
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void) setMessageFrameData
{
    self.timeLabel.text = _msgFrame.msg.time;
    self.timeLabel.frame = _msgFrame.timeF;
    
//    if (_msgFrame.msg.type == MessageTypeOther) {
//        [self.iconButton setImage:[UIImage imageNamed:@"other"] forState:UIControlStateNormal];
//    }else{
//        [self.iconButton setImage:[UIImage imageNamed:@"me"] forState:UIControlStateNormal];
//    }
    if (_msgFrame.msg.iconImage)
    {
        [self.iconButton setImage:_msgFrame.msg.iconImage forState:UIControlStateNormal];
    }
    else
    {
        [self.iconButton setImage:[UIImage imageNamed:@"DefaultHead"] forState:UIControlStateNormal];
    }
    
    self.iconButton.frame = _msgFrame.iconF;
    
    [self.textButton setTitle:_msgFrame.msg.text forState:UIControlStateNormal];
    
    if (_msgFrame.msg.type == MessageTypeOther) {
        UIImage *normalImage = [UIImage imageNamed:@"chat_recive_nor"];
        UIImage *lastImage = [normalImage stretchableImageWithLeftCapWidth:normalImage.size.width * 0.5 topCapHeight:normalImage.size.height * 0.5];
        
        [self.textButton setBackgroundImage:lastImage forState:UIControlStateNormal];
    }else {
        
        UIImage *normalImage = [UIImage imageNamed:@"chat_send_nor"];
        UIImage *lastImage = [normalImage stretchableImageWithLeftCapWidth:normalImage.size.width * 0.5 topCapHeight:normalImage.size.height * 0.5];
        
        [self.textButton setBackgroundImage:lastImage forState:UIControlStateNormal];
//        self.textButton.backgroundColor = [UIColor redColor];
        
    }
    
    self.textButton.frame = _msgFrame.textF;
}

- (void) setMsgFrame:(MessageFrame *)msgFrame
{
    _msgFrame = msgFrame;
    [self setMessageFrameData];
}

+ (instancetype) cellWithTableView:(UITableView *)tableView
{
    static NSString *cellId = @"MSG";
    
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    return cell;
}


@end
