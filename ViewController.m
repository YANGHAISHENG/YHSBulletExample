//
//  ViewController.m
//  YHSBulletExample
//
//  Created by YANGHAISHENG on 2017/2/26.
//  Copyright © 2017年 YANGHAISHENG. All rights reserved.
//

#import "ViewController.h"
#import "BulletManager.h"
#import "BulletView.h"


@interface ViewController ()
@property (nonatomic,strong) BulletManager *manager;
@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    // 弹幕管理器
    __weak __typeof(&*self)weakSelf = self;
    self.manager = [[BulletManager alloc] init];
    [self.manager setGenerateBulletBlock:^(BulletView *bulletView) {
        [weakSelf addBulletView:bulletView];
    }];

    
    // 开始按钮
    UIButton *startButton = [[self class] createQQUIButtonWithFrame:CGRectMake(60, 60, 100, 40) title:@"开始弹幕"];
    [startButton addTarget:self action:@selector(didClickStart) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startButton];
    
    
    // 结束按钮
    UIButton *stopButton = [[self class] createQQUIButtonWithFrame:CGRectMake(220, 60, 100, 40) title:@"结束弹幕"];
    [startButton addTarget:self action:@selector(didClickStop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopButton];
    
}


-(void)didClickStart
{
    [self.manager start];
}


-(void)didClickStop
{
    [self.manager stop];
}


-(void)addBulletView:(BulletView *)bulletView
{
    CGFloat screenWith = [UIScreen mainScreen].bounds.size.width;
    bulletView.frame = CGRectMake(screenWith,
                                  80 + bulletView.trajectory * 50,
                                  bulletView.frame.size.width,
                                  bulletView.frame.size.height);
    [self.view addSubview:bulletView];
    
    [bulletView startAnimation];
}



#pragma mark - 生成 UIButton 控件
+ (UIButton *)createQQUIButtonWithFrame:(CGRect)frame title:(NSString *)title
{
    // 按钮背景1
    UIImage *buttonImage = [UIImage imageNamed:@"blue.png"];
    buttonImage = [buttonImage stretchableImageWithLeftCapWidth:floorf(buttonImage.size.width/2)
                                                   topCapHeight:floorf(buttonImage.size.height/2)];
    // 按钮背景2
    UIImage *buttonImageselected = [UIImage imageNamed:@"orange.png"];
    buttonImage = [buttonImage stretchableImageWithLeftCapWidth:floorf(buttonImage.size.width/2)
                                                   topCapHeight:floorf(buttonImage.size.height/2)];
    // 创建按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonImageselected forState:UIControlStateHighlighted];
    [button setShowsTouchWhenHighlighted:YES];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];
    [[button titleLabel] setFont:[UIFont boldSystemFontOfSize:20]];
    [[button titleLabel] setTextAlignment:NSTextAlignmentLeft];
    [[button layer] setCornerRadius:10];
    [[button layer] setBorderWidth:0.0];
    [[button layer] setMasksToBounds:YES];
    
    return button;
}


@end










