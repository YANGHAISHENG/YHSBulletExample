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
    UIButton *startButton = ({
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(60, 60, 100, 40)];
        [[button layer] setCornerRadius:10];
        [[button layer] setBorderWidth:1.0];
        [[button layer] setMasksToBounds:YES];
        [button setTitle:@"开始弹幕" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(didClickStart) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.view addSubview:startButton];
    
    
    // 结束按钮
    UIButton *stopButton = ({
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(220, 60, 100, 40)];
        [[button layer] setCornerRadius:10];
        [[button layer] setBorderWidth:1.0];
        [[button layer] setMasksToBounds:YES];
        [button setTitle:@"结束弹幕" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(didClickStop) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
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


@end










