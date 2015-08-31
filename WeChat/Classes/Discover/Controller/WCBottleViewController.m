//
//  WCBottleViewController.m
//  WeChat
//
//  Created by Pengtong on 15/8/31.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import "WCBottleViewController.h"

#import "XHFoundationCommon.h"
#import <MessageDisplayKit/XHMacro.h>

@interface WCBottleViewController ()

@property (nonatomic, strong) UIImageView *pickerMarkImageView;
@property (nonatomic, strong) UIButton *pickerButton;
@property (nonatomic, strong) UIImageView *fishwaterAnimatedImageView;

@property (nonatomic, weak) UIImageView *boardImageView;
@property (nonatomic, weak) UIButton *throwButton;
@property (nonatomic, weak) UIButton *fishButton;
@property (nonatomic, weak) UIButton *mineButton;

@end

@implementation WCBottleViewController

#pragma mark - Action

- (void)boardButtonClicked:(UIButton *)sender
{
    [self showPickerMarkImageView:!self.pickerMarkImageView.alpha];
}

- (void)pickerButtonClicked:(UIButton *)sender
{
    [self showPickerMarkImageView:NO];
    [self showPickerButton:NO];
}

- (void)showPickerButton:(BOOL)show
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.pickerButton.alpha = show;
        self.fishwaterAnimatedImageView.alpha = show;
    } completion:^(BOOL finished) {
        [self.fishwaterAnimatedImageView stopAnimating];
    }];
}

- (void)showResult
{
    [self showPickerButton:YES];
}

- (void)setupResult
{
    NSInteger result = random()%3;
    
    NSString *resultImageName;
    switch (result)
    {
        case 0:
            resultImageName = @"bottleStarfish";
            break;
        case 1:
            resultImageName = @"bottleRecord";
            break;
        case 2:
            resultImageName = @"bottleWriting";
            break;
        default:
            break;
    }
    [self.pickerButton setBackgroundImage:[UIImage imageNamed:resultImageName] forState:UIControlStateNormal];
    
    self.fishwaterAnimatedImageView.alpha = 1.0;
    [self.fishwaterAnimatedImageView startAnimating];
}

#pragma mark - Propertys

- (UIImageView *)pickerMarkImageView
{
    if (!_pickerMarkImageView)
    {
        _pickerMarkImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _pickerMarkImageView.image = [UIImage imageNamed:@"bottleBkgSpotLight"];
        _pickerMarkImageView.alpha = 0.0;
    }
    return _pickerMarkImageView;
}

- (UIButton *)pickerButton
{
    if (!_pickerButton)
    {
        _pickerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 104, 60)];
        [_pickerButton addTarget:self action:@selector(pickerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _pickerButton.center = CGPointMake(CGRectGetWidth(self.pickerMarkImageView.bounds) / 2.0, CGRectGetHeight(self.pickerMarkImageView.bounds) / 2.0);
        _pickerButton.alpha = 0.0;
    }
    return _pickerButton;
}

- (UIImageView *)fishwaterAnimatedImageView
{
    if (!_fishwaterAnimatedImageView)
    {
        _fishwaterAnimatedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 68, 48)];
        _fishwaterAnimatedImageView.alpha = 0.0;
        _fishwaterAnimatedImageView.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"fishwater"], [UIImage imageNamed:@"fishwater2"], [UIImage imageNamed:@"fishwater3"], nil];
        _fishwaterAnimatedImageView.animationDuration = 1.0;
        _fishwaterAnimatedImageView.center = CGPointMake(CGRectGetWidth(self.pickerMarkImageView.bounds) / 1.6, CGRectGetHeight(self.pickerMarkImageView.bounds) / 2.0);
    }
    return _fishwaterAnimatedImageView;
}

- (void)showPickerMarkImageView:(BOOL)show
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.pickerMarkImageView.alpha = show;
        
        self.boardImageView.alpha = !show;
        self.throwButton.alpha = !show;
        self.fishButton.alpha = !show;
        self.mineButton.alpha = !show;
    } completion:^(BOOL finished) {
        if (show) {
            [self setupResult];
            [self performSelector:@selector(showResult) withObject:nil afterDelay:0.5];
        }
    }];
}

#pragma mark - Life Cycle

- (void)initilzer
{
    // duw with backgrounImage form date
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit fromDate:now];
    
    UIImage *backgroundImage;
    if(components.hour > 12)
    {
        backgroundImage = [UIImage imageNamed:@"bottleNightBkg"];
    }
    else
    {
        backgroundImage = [UIImage imageNamed:@"bottleBkg"];
    }
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backgroundImageView.image = backgroundImage;
    [self.view insertSubview:backgroundImageView atIndex:0];
    
    // board
    if (!_boardImageView)
    {
        UIImageView *boardImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds) - 46 - [XHFoundationCommon getAdapterHeight], CGRectGetWidth(self.view.bounds), 46)];
        boardImageView.image = [UIImage imageNamed:@"bottleBoard"];
        [self.view addSubview:boardImageView];
        self.boardImageView = boardImageView;
    }
    
    // buttons
    CGFloat buttonWidth = 76;
    CGFloat buttonHeight = 86;
    CGFloat insets = 23;
    CGFloat paddingX = CGRectGetMidX(self.view.bounds) - insets - buttonWidth * 1.5;
    CGFloat paddingY = CGRectGetHeight(self.view.bounds) - buttonHeight - [XHFoundationCommon getAdapterHeight];
    for (int i = 0; i < 3; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(paddingX + i * (buttonWidth + insets), paddingY, buttonWidth, buttonHeight);
        
        [button addTarget:self action:@selector(boardButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        NSString *imageName;
        switch (i) {
            case 0: {
                imageName = @"bottleButtonThrow";
                self.throwButton = button;
                break;
            }
            case 1: {
                self.fishButton = button;
                imageName = @"bottleButtonFish";
                break;
            }
            case 2:
                self.mineButton = button;
                imageName = @"bottleButtonMine";
                break;
            default:
                break;
        }
        
        [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [self.view addSubview:button];
    }
    
    [self.view addSubview:self.pickerMarkImageView];
    [self.view addSubview:self.pickerButton];
    [self.view addSubview:self.fishwaterAnimatedImageView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"漂流瓶";
    
    [self initilzer];
}

@end
