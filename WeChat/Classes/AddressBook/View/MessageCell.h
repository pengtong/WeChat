//
//  MessageCell.h
//  QQChat
//
//  Created by Pengtong on 14-12-30.
//  Copyright (c) 2014年 Pengtong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageFrame.h"

@interface MessageCell : UITableViewCell

@property (nonatomic, weak) UILabel *timeLabel;

@property (nonatomic, weak) UIButton *iconButton;

@property (nonatomic, weak) UIButton *textButton;

@property (nonatomic, weak) UIImageView *chatImage;

@property (nonatomic, strong) MessageFrame *msgFrame;

+ (instancetype) cellWithTableView:(UITableView *)tableView;
@end
