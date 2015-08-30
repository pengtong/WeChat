//
//  XHMessageBubbleView.m
//  MessageDisplayExample
//
//  Created by HUAJIE-1 on 14-4-24.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHMessageBubbleView.h"

#import "XHMessageBubbleHelper.h"

#define kXHHaveBubbleMargin 15.0f // 距离气泡上下边的间隙

#define kXHVoiceMargin 20.0f // 语音间隙

#define kXHArrowMarginWidth 9.0f // 箭头宽度

#define kXHLeftTextHorizontalBubblePadding 15.0f // 文本的水平间隙
#define kXHRightTextHorizontalBubblePadding 15.0f // 文本的水平间隙

#define kXHUnReadDotSize 10.0f // 语音未读的红点大小

#define kXHNoneBubblePhotoMargin (kXHHaveBubbleMargin - kXHBubblePhotoMargin) // 在没有气泡的时候，也就是在图片、视频、地理位置的时候，图片内部做了Margin，所以需要减去内部的Margin

@interface XHMessageBubbleView ()

@property (nonatomic, weak, readwrite) SETextView *displayTextView;

@property (nonatomic, weak, readwrite) UIImageView *bubbleImageView;

@property (nonatomic, weak, readwrite) FLAnimatedImageView *emotionImageView;

@property (nonatomic, weak, readwrite) UIImageView *animationVoiceImageView;

@property (nonatomic, weak, readwrite) UIImageView *voiceUnreadDotImageView;

@property (nonatomic, weak, readwrite) XHBubblePhotoImageView *bubblePhotoImageView;

@property (nonatomic, weak, readwrite) UIImageView *videoPlayImageView;

@property (nonatomic, weak, readwrite) UILabel *geolocationsLabel;

@property (nonatomic, strong, readwrite) id <XHMessageModel> message;

@end

@implementation XHMessageBubbleView

#pragma mark - Bubble view

// 获取文本的实际大小
+ (CGFloat)neededWidthForText:(NSString *)text {
    CGSize stringSize;
    NSRange range = [text rangeOfString:@"\n" options:0];
    if (range.length > 0) {
        NSArray *array = [text componentsSeparatedByString:@"\n"];
        stringSize = CGSizeMake(0, 0);
        CGSize temp;
        for (int i = 0; i < array.count; i++) {
            temp = [[array objectAtIndex:i] sizeWithFont:[[XHMessageBubbleView appearance] font] constrainedToSize:CGSizeMake(MAXFLOAT, 20)];
            if (temp.width > stringSize.width) {
                stringSize = temp;
            }
        }
    } else {
        stringSize = [text sizeWithFont:[[XHMessageBubbleView appearance] font]
                      constrainedToSize:CGSizeMake(MAXFLOAT, 20)];
    }
    
    return roundf(stringSize.width);
}

// 计算文本实际的大小
+ (CGSize)neededSizeForText:(NSString *)text {
    CGFloat maxWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]) * (kIsiPad ? 0.8 : (kIs_iPhone_6 ? 0.6 : (kIs_iPhone_6P ? 0.62 : 0.55)));
    
    CGFloat dyWidth = [XHMessageBubbleView neededWidthForText:text];
    
    CGSize textSize = [SETextView frameRectWithAttributtedString:[[XHMessageBubbleHelper sharedMessageBubbleHelper] bubbleAttributtedStringWithText:text]
                                                  constraintSize:CGSizeMake(maxWidth, MAXFLOAT)
                                                     lineSpacing:kXHTextLineSpacing
                                                            font:[[XHMessageBubbleView appearance] font]].size;
    return CGSizeMake((dyWidth > textSize.width ? textSize.width : dyWidth), textSize.height);
}

// 计算图片实际大小
+ (CGSize)neededSizeForPhoto:(UIImage *)photo {
    // 这里需要缩放后的size
    CGSize photoSize = CGSizeMake(140, 140);
    return photoSize;
}

// 计算语音实际大小
+ (CGSize)neededSizeForVoicePath:(NSString *)voicePath voiceDuration:(NSString *)voiceDuration {
    // 这里的100只是暂时固定，到时候会根据一个函数来计算
    float gapDuration = (!voiceDuration || voiceDuration.length == 0 ? -1 : [voiceDuration floatValue] - 1.0f);
    CGSize voiceSize = CGSizeMake(100 + (gapDuration > 0 ? (120.0 / (60 - 1) * gapDuration) : 0), 42);
    return voiceSize;
}

// 计算Emotion的高度
+ (CGSize)neededSizeForEmotion {
    return CGSizeMake(100, 100);
}

// 计算LocalPostion的高度
+ (CGSize)neededSizeForLocalPostion {
    return CGSizeMake(140, 140);
}

// 计算Cell需要实际Message内容的大小
+ (CGFloat)calculateCellHeightWithMessage:(id <XHMessageModel>)message {
    CGSize size = [XHMessageBubbleView getBubbleFrameWithMessage:message];
    return size.height;
}

// 获取Cell需要的高度
+ (CGSize)getBubbleFrameWithMessage:(id <XHMessageModel>)message {
    CGSize bubbleSize;
    switch (message.messageMediaType) {
        case XHBubbleMessageMediaTypeText: {
            CGSize needTextSize = [XHMessageBubbleView neededSizeForText:message.text];
            bubbleSize = CGSizeMake(needTextSize.width + kXHLeftTextHorizontalBubblePadding + kXHRightTextHorizontalBubblePadding + kXHArrowMarginWidth, needTextSize.height + kXHHaveBubbleMargin * 4); //这里*4的原因是：气泡内部的文本也做了margin，而且margin的大小和气泡的margin一样大小，所以需要加上*2的间隙大小
            break;
        }
        case XHBubbleMessageMediaTypeVoice: {
            // 这里的宽度是不定的，高度是固定的，根据需要根据语音长短来定制啦
            CGSize needVoiceSize = [XHMessageBubbleView neededSizeForVoicePath:message.voicePath voiceDuration:message.voiceDuration];
            bubbleSize = CGSizeMake(needVoiceSize.width, needVoiceSize.height + kXHHaveBubbleMargin * 2);
            break;
        }
        case XHBubbleMessageMediaTypeEmotion: {
            // 是否固定大小呢？
            CGSize emotionSize = [XHMessageBubbleView neededSizeForEmotion];
            bubbleSize = CGSizeMake(emotionSize.width, emotionSize.height + kXHHaveBubbleMargin * 2);
            break;
        }
        case XHBubbleMessageMediaTypePhoto: {
            CGSize needPhotoSize = [XHMessageBubbleView neededSizeForPhoto:message.photo];
            bubbleSize = CGSizeMake(needPhotoSize.width, needPhotoSize.height + kXHNoneBubblePhotoMargin * 2);
            break;
        }
        case XHBubbleMessageMediaTypeVideo: {
            CGSize needVideoConverPhotoSize = [XHMessageBubbleView neededSizeForPhoto:message.videoConverPhoto];
            bubbleSize = CGSizeMake(needVideoConverPhotoSize.width, needVideoConverPhotoSize.height + kXHNoneBubblePhotoMargin * 2);
            break;
        }
        case XHBubbleMessageMediaTypeLocalPosition: {
            // 固定大小，必须的
            CGSize localPostionSize = [XHMessageBubbleView neededSizeForLocalPostion];
            bubbleSize = CGSizeMake(localPostionSize.width, localPostionSize.height + kXHNoneBubblePhotoMargin * 2);
            break;
        }
        default:
            break;
    }
    return bubbleSize;
}

#pragma mark - UIAppearance Getters

- (UIFont *)font {
    if (_font == nil) {
        _font = [[[self class] appearance] font];
    }
    
    if (_font != nil) {
        return _font;
    }
    
    return [UIFont systemFontOfSize:16.0f];
}

#pragma mark - Getters

// 获取气泡的位置以及大小，比如有文字的气泡，语音的气泡，图片的气泡，地理位置的气泡，Emotion的气泡，视频封面的气泡
- (CGRect)bubbleFrame {
    // 1.先得到MessageBubbleView的实际大小
    CGSize bubbleSize = [XHMessageBubbleView getBubbleFrameWithMessage:self.message];
    
    // 2.计算起泡的大小和位置
    CGFloat paddingX = 0.0f;
    if (self.message.bubbleMessageType == XHBubbleMessageTypeSending) {
        paddingX = CGRectGetWidth(self.bounds) - bubbleSize.width;
    }
    
    // 最终减去上下边距的像素就可以得到气泡的位置以及大小
    return CGRectIntegral(
                          CGRectMake(paddingX,
                                     kXHHaveBubbleMargin,
                                     bubbleSize.width,
                                     bubbleSize.height - kXHHaveBubbleMargin * 2)
                          );
}

#pragma mark - Configure Methods

- (void)configureCellWithMessage:(id <XHMessageModel>)message {
    _message = message;
    
    [self configureBubbleImageView:message];
    
    [self configureMessageDisplayMediaWithMessage:message];
}

- (void)configureBubbleImageView:(id <XHMessageModel>)message {
    XHBubbleMessageMediaType currentType = message.messageMediaType;
    
    _voiceDurationLabel.hidden = YES;
    _voiceUnreadDotImageView.hidden = YES;
    switch (currentType) {
        case XHBubbleMessageMediaTypeVoice: {
            _voiceDurationLabel.hidden = NO;
            _voiceUnreadDotImageView.hidden = message.isRead;
        }
        case XHBubbleMessageMediaTypeText:
        case XHBubbleMessageMediaTypeEmotion: {
            _bubbleImageView.image = [XHMessageBubbleFactory bubbleImageViewForType:message.bubbleMessageType style:XHBubbleImageViewStyleWeChat meidaType:message.messageMediaType];
            // 只要是文本、语音、第三方表情，背景的气泡都不能隐藏
            _bubbleImageView.hidden = NO;
            
            // 只要是文本、语音、第三方表情，都需要把显示尖嘴图片的控件隐藏了
            _bubblePhotoImageView.hidden = YES;
            
            
            if (currentType == XHBubbleMessageMediaTypeText) {
                // 如果是文本消息，那文本消息的控件需要显示
                _displayTextView.hidden = NO;
                // 那语言的gif动画imageView就需要隐藏了
                _animationVoiceImageView.hidden = YES;
                _emotionImageView.hidden = YES;
            } else {
                // 那如果不文本消息，必须把文本消息的控件隐藏了啊
                _displayTextView.hidden = YES;
                
                // 对语音消息的进行特殊处理，第三方表情可以直接利用背景气泡的ImageView控件
                if (currentType == XHBubbleMessageMediaTypeVoice) {
                    [_animationVoiceImageView removeFromSuperview];
                    _animationVoiceImageView = nil;
                    
                    UIImageView *animationVoiceImageView = [XHMessageVoiceFactory messageVoiceAnimationImageViewWithBubbleMessageType:message.bubbleMessageType];
                    [self addSubview:animationVoiceImageView];
                    _animationVoiceImageView = animationVoiceImageView;
                    _animationVoiceImageView.hidden = NO;
                } else {
                    _emotionImageView.hidden = NO;
                    
                    _bubbleImageView.hidden = YES;
                    _animationVoiceImageView.hidden = YES;
                }
            }
            break;
        }
        case XHBubbleMessageMediaTypePhoto:
        case XHBubbleMessageMediaTypeVideo:
        case XHBubbleMessageMediaTypeLocalPosition: {
            // 只要是图片和视频消息，必须把尖嘴显示控件显示出来
            _bubblePhotoImageView.hidden = NO;
            
            _videoPlayImageView.hidden = (currentType != XHBubbleMessageMediaTypeVideo);
            
            _geolocationsLabel.hidden = (currentType != XHBubbleMessageMediaTypeLocalPosition);
            
            // 那其他的控件都必须隐藏
            _displayTextView.hidden = YES;
            _bubbleImageView.hidden = YES;
            _animationVoiceImageView.hidden = YES;
            _emotionImageView.hidden = YES;
            break;
        }
        default:
            break;
    }
}

- (void)configureMessageDisplayMediaWithMessage:(id <XHMessageModel>)message {
    switch (message.messageMediaType) {
        case XHBubbleMessageMediaTypeText:
            _displayTextView.attributedText = [[XHMessageBubbleHelper sharedMessageBubbleHelper] bubbleAttributtedStringWithText:[message text]];
            break;
        case XHBubbleMessageMediaTypePhoto:
            [_bubblePhotoImageView configureMessagePhoto:message.photo thumbnailUrl:message.thumbnailUrl originPhotoUrl:message.originPhotoUrl onBubbleMessageType:self.message.bubbleMessageType];
            break;
        case XHBubbleMessageMediaTypeVideo:
            [_bubblePhotoImageView configureMessagePhoto:message.videoConverPhoto thumbnailUrl:message.thumbnailUrl originPhotoUrl:message.originPhotoUrl onBubbleMessageType:self.message.bubbleMessageType];
            break;
        case XHBubbleMessageMediaTypeVoice:
            break;
        case XHBubbleMessageMediaTypeEmotion:
            // 直接设置GIF
            if (message.emotionPath) {
                NSData *animatedData = [NSData dataWithContentsOfFile:message.emotionPath];
                FLAnimatedImage *animatedImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:animatedData];
                _emotionImageView.animatedImage = animatedImage;
            }
            break;
        case XHBubbleMessageMediaTypeLocalPosition:
            [_bubblePhotoImageView configureMessagePhoto:message.localPositionPhoto thumbnailUrl:nil originPhotoUrl:nil onBubbleMessageType:self.message.bubbleMessageType];
            
            _geolocationsLabel.text = message.geolocations;
            break;
        default:
            break;
    }
    
    [self setNeedsLayout];
}

- (void)configureVoiceDurationLabelFrameWithBubbleFrame:(CGRect)bubbleFrame {
    CGRect voiceFrame = _voiceDurationLabel.frame;
    voiceFrame.origin.x = (self.message.bubbleMessageType == XHBubbleMessageTypeSending ? bubbleFrame.origin.x - CGRectGetWidth(voiceFrame) : bubbleFrame.origin.x + bubbleFrame.size.width);
    _voiceDurationLabel.frame = voiceFrame;
    _voiceDurationLabel.textAlignment = (self.message.bubbleMessageType == XHBubbleMessageTypeSending ? NSTextAlignmentRight : NSTextAlignmentLeft);
}

- (void)configureVoiceUnreadDotImageViewFrameWithBubbleFrame:(CGRect)bubbleFrame {
    CGRect voiceUnreadDotFrame = _voiceUnreadDotImageView.frame;
    voiceUnreadDotFrame.origin.x = (self.message.bubbleMessageType == XHBubbleMessageTypeSending ? bubbleFrame.origin.x + kXHUnReadDotSize : CGRectGetMaxX(bubbleFrame) - kXHUnReadDotSize * 2);
    voiceUnreadDotFrame.origin.y = CGRectGetMidY(bubbleFrame) - kXHUnReadDotSize / 2.0;
    _voiceUnreadDotImageView.frame = voiceUnreadDotFrame;
}

#pragma mark - Life cycle

- (instancetype)initWithFrame:(CGRect)frame
                      message:(id <XHMessageModel>)message {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _message = message;
        
        // 1、初始化气泡的背景
        if (!_bubbleImageView) {
            //bubble image
            FLAnimatedImageView *bubbleImageView = [[FLAnimatedImageView alloc] init];
            bubbleImageView.frame = self.bounds;
            bubbleImageView.userInteractionEnabled = YES;
            [self addSubview:bubbleImageView];
            _bubbleImageView = bubbleImageView;
        }
        
        // 2、初始化显示文本消息的TextView
        if (!_displayTextView) {
            SETextView *displayTextView = [[SETextView alloc] initWithFrame:CGRectZero];
            displayTextView.textColor = [UIColor colorWithWhite:0.143 alpha:1.000];
            displayTextView.backgroundColor = [UIColor clearColor];
            displayTextView.selectable = NO;
            displayTextView.lineSpacing = kXHTextLineSpacing;
            displayTextView.font = [[XHMessageBubbleView appearance] font];
            displayTextView.showsEditingMenuAutomatically = NO;
            displayTextView.highlighted = NO;
            [self addSubview:displayTextView];
            _displayTextView = displayTextView;
        }
        
        // 3、初始化显示图片的控件
        if (!_bubblePhotoImageView) {
            XHBubblePhotoImageView *bubblePhotoImageView = [[XHBubblePhotoImageView alloc] initWithFrame:CGRectZero];
            [self addSubview:bubblePhotoImageView];
            _bubblePhotoImageView = bubblePhotoImageView;
            
            if (!_videoPlayImageView) {
                UIImageView *videoPlayImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MessageVideoPlay"]];
                [bubblePhotoImageView addSubview:videoPlayImageView];
                _videoPlayImageView = videoPlayImageView;
            }
            
            if (!_geolocationsLabel) {
                UILabel *geolocationsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
                geolocationsLabel.numberOfLines = 0;
                geolocationsLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                geolocationsLabel.textColor = [UIColor whiteColor];
                geolocationsLabel.backgroundColor = [UIColor clearColor];
                geolocationsLabel.font = [UIFont systemFontOfSize:12];
                [bubblePhotoImageView addSubview:geolocationsLabel];
                _geolocationsLabel = geolocationsLabel;
            }
        }
        
        // 4、初始化显示语音时长的label
        if (!_voiceDurationLabel) {
            UILabel *voiceDurationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 30, 30)];
            voiceDurationLabel.textColor = [UIColor colorWithWhite:0.579 alpha:1.000];
            voiceDurationLabel.backgroundColor = [UIColor clearColor];
            voiceDurationLabel.font = [UIFont systemFontOfSize:13.f];
            voiceDurationLabel.textAlignment = NSTextAlignmentRight;
            voiceDurationLabel.hidden = YES;
            [self addSubview:voiceDurationLabel];
            _voiceDurationLabel = voiceDurationLabel;
        }
        
        // 5、初始化显示gif表情的控件
        if (!_emotionImageView) {
            FLAnimatedImageView *emotionImageView = [[FLAnimatedImageView alloc] initWithFrame:CGRectZero];
            [self addSubview:emotionImageView];
            _emotionImageView = emotionImageView;
        }
        
        // 6. 初始化显示语音未读标记的imageview
        if (!_voiceUnreadDotImageView) {
            UIImageView *voiceUnreadDotImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kXHUnReadDotSize, kXHUnReadDotSize)];
            voiceUnreadDotImageView.image = [UIImage imageNamed:@"msg_chat_voice_unread"];
            voiceUnreadDotImageView.hidden = YES;
            [self addSubview:voiceUnreadDotImageView];
            _voiceUnreadDotImageView = voiceUnreadDotImageView;
        }
    }
    return self;
}

- (void)dealloc {
    _message = nil;
    
    _displayTextView = nil;
    
    _bubbleImageView = nil;
    
    _bubblePhotoImageView = nil;
    
    _animationVoiceImageView = nil;
    
    _voiceUnreadDotImageView = nil;
    
    _voiceDurationLabel = nil;
    
    _emotionImageView = nil;
    
    _videoPlayImageView = nil;
    
    _geolocationsLabel = nil;
    
    _font = nil;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    XHBubbleMessageMediaType currentType = self.message.messageMediaType;
    
    switch (currentType) {
        case XHBubbleMessageMediaTypeText:
        case XHBubbleMessageMediaTypeVoice:
        case XHBubbleMessageMediaTypeEmotion: {
            // 获取实际气泡的大小
            CGRect bubbleFrame = [self bubbleFrame];
            self.bubbleImageView.frame = bubbleFrame;
            
            CGFloat textX = CGRectGetMinX(bubbleFrame) + kXHRightTextHorizontalBubblePadding;
            if (self.message.bubbleMessageType == XHBubbleMessageTypeReceiving) {
                textX = CGRectGetMinX(bubbleFrame) + kXHArrowMarginWidth + kXHLeftTextHorizontalBubblePadding;
            }
            
            CGRect textFrame = CGRectMake(textX,
                                          CGRectGetMinY(bubbleFrame) + kXHHaveBubbleMargin,
                                          CGRectGetWidth(bubbleFrame) - kXHLeftTextHorizontalBubblePadding - kXHRightTextHorizontalBubblePadding - kXHArrowMarginWidth,
                                          bubbleFrame.size.height - kXHHaveBubbleMargin * 2);
            
            self.displayTextView.frame = CGRectIntegral(textFrame);
            
            CGRect animationVoiceImageViewFrame = self.animationVoiceImageView.frame;
            CGFloat voiceImagePaddingX = CGRectGetMaxX(bubbleFrame) - kXHVoiceMargin - CGRectGetWidth(animationVoiceImageViewFrame);
            if (self.message.bubbleMessageType == XHBubbleMessageTypeReceiving) {
                voiceImagePaddingX = CGRectGetMinX(bubbleFrame) + kXHVoiceMargin;
            }
            animationVoiceImageViewFrame.origin = CGPointMake(voiceImagePaddingX, CGRectGetMidY(textFrame) - CGRectGetHeight(animationVoiceImageViewFrame) / 2);  // 垂直居中
            self.animationVoiceImageView.frame = animationVoiceImageViewFrame;
            
            [self configureVoiceDurationLabelFrameWithBubbleFrame:bubbleFrame];
            [self configureVoiceUnreadDotImageViewFrameWithBubbleFrame:bubbleFrame];
            
            CGRect emotionImageViewFrame = bubbleFrame;
            emotionImageViewFrame.size = [XHMessageBubbleView neededSizeForEmotion];
            self.emotionImageView.frame = emotionImageViewFrame;
            break;
        }
        case XHBubbleMessageMediaTypePhoto:
        case XHBubbleMessageMediaTypeVideo:
        case XHBubbleMessageMediaTypeLocalPosition: {
            CGSize needPhotoSize = [XHMessageBubbleView neededSizeForPhoto:self.message.photo];
            CGFloat paddingX = 0.0f;
            if (self.message.bubbleMessageType == XHBubbleMessageTypeSending) {
                paddingX = CGRectGetWidth(self.bounds) - needPhotoSize.width;
            }
            CGRect photoImageViewFrame = CGRectMake(paddingX, kXHNoneBubblePhotoMargin, needPhotoSize.width, needPhotoSize.height);
            
            self.bubblePhotoImageView.frame = photoImageViewFrame;
            
            self.videoPlayImageView.center = CGPointMake(CGRectGetWidth(photoImageViewFrame) / 2.0, CGRectGetHeight(photoImageViewFrame) / 2.0);
            
            CGRect geolocationsLabelFrame = CGRectMake(11, CGRectGetHeight(photoImageViewFrame) - 47, CGRectGetWidth(photoImageViewFrame) - 20, 40);
            self.geolocationsLabel.frame = geolocationsLabelFrame;
            
            break;
        }
        default:
            break;
    }
}

@end
