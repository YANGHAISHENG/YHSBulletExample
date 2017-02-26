//
//  BulletManager.m
//  YHSBulletExample
//
//  Created by YANGHAISHENG on 2017/2/26.
//  Copyright © 2017年 YANGHAISHENG. All rights reserved.
//

#import "BulletManager.h"
#import "BulletView.h"


@interface BulletManager ()
/** 弹幕的数据来源 */
@property (nonatomic,strong) NSMutableArray *dataSource;
/** 弹幕是数组变量 */
@property (nonatomic,strong) NSMutableArray *bulletStrings;
/** 存储弹幕BulletView的数组变量 */
@property (nonatomic,strong) NSMutableArray *bulletViews;
/** 弹幕动画是否结束 */
@property (nonatomic,assign) BOOL bulletAnimationIsStop;
@end


@implementation BulletManager


- (instancetype)init
{
    self = [super init];
    if (self) {
        _bulletAnimationIsStop = YES;
    }
    return self;
}


/** 弹幕开始执行 */
- (void)start
{
    if (!_bulletAnimationIsStop) {
        return;
    }
    
    _bulletAnimationIsStop = NO;
    [self.bulletStrings removeAllObjects];
    [self.bulletStrings addObjectsFromArray:self.dataSource];
    [self initBulletString];
}


/** 弹幕停止执行 */
- (void)stop
{
    if (_bulletAnimationIsStop) {
        return;
    }
    
    _bulletAnimationIsStop = YES;
    for (BulletView *view in self.bulletViews) {
        [view stopAnimation];
    }
    [self.bulletViews removeAllObjects];
}


/** 初始化弹幕,随机分配弹幕轨迹 */
- (void)initBulletString
{
    NSMutableArray *trajectorys = [NSMutableArray arrayWithArray:@[@1, @2, @3, @4, @5, @6, @7, @8, @9, @10]];
    NSUInteger count = trajectorys.count;
    for (int i = 0; i < count; i ++) {
        if (_bulletStrings.count) {
            
            NSInteger index = arc4random()%trajectorys.count;
            int trajectory = [[trajectorys objectAtIndex:index] intValue];
            [trajectorys removeObjectAtIndex:index];
            
            NSString *bulletStr = _bulletStrings.firstObject;
            [_bulletStrings removeObjectAtIndex:0];
            
            [self createBulletView:bulletStr withTrajectory:trajectory];
        }
    }
}


/**
 *  创建弹幕
 *
 *  @param bulletStr 弹幕内容
 *  @param trajectory 弹道位置
 */
-(void)createBulletView:(NSString *)bulletStr withTrajectory:(int)trajectory
{
    if (_bulletAnimationIsStop) {
        return;
    }
    
    // 创建一个弹幕
    BulletView *bulletView = [[BulletView alloc] initWithBulletString:bulletStr];
    bulletView.trajectory = trajectory; // 设置弹道
    
    
    /**
     *  弹幕BulletView的动画过程中的回调状态
     *  BulletMoveStatusStart:创建弹幕在进入屏幕之前
     *  BulletMoveStatusEnter:弹幕完全进入屏幕
     *  BulletMoveStatusEnd:弹幕飞出屏幕后
     */
    __weak typeof(self)weakSelf = self;
    __weak typeof(bulletView)weakBulletView = bulletView;
    bulletView.moveStatusBlock = ^(BulletMoveStatus status) {
        
        if (weakSelf.bulletAnimationIsStop) {
            return ;
        }
        
        switch (status) {
            case BulletMoveStatusStart: {
                // 弹幕开始进入屏幕, 将 bulletView 加入弹幕管理
                [weakSelf.bulletViews addObject:weakBulletView];
                break;
            }
            case BulletMoveStatusEnter:
            {
                // 弹幕完全进入屏幕，判断接下来是否还有内容，如果有则在该弹道轨迹对列中创建弹幕
                NSString *nextBulletStr = [weakSelf nextBulletString];
                if (nextBulletStr) {
                    [weakSelf createBulletView:nextBulletStr withTrajectory:trajectory];
                } else {
                    // 说明到了评论的结尾，已经没有内容了
                }
                break;
            }
            case BulletMoveStatusEnd:
            {
                // 弹幕飞出屏幕后，从弹幕管理 bulletViews 中移除, 释放资源
                if ([weakSelf.bulletViews containsObject:weakBulletView]) {
                    [weakBulletView stopAnimation];
                    [weakSelf.bulletViews removeObject:weakBulletView];
                }
                
                if (0 == weakSelf.bulletViews.count) {
                    // 说明屏幕上没有弹幕了, 开始循环滚动
                    weakSelf.bulletAnimationIsStop = YES;
                    [weakSelf start];
                }
                break;
            }
            default:
                break;
        }

    };

    // 弹幕生成后，传到 UIViewcontroller 进行页面展示
    if (self.generateBulletBlock) {
        self.generateBulletBlock(bulletView);
    }

}


-(NSString *)nextBulletString
{
    if (!self.bulletStrings.count) {
        return nil;
    }
    NSString *bulletStr = self.bulletStrings.firstObject;
    [self.bulletStrings removeObjectAtIndex:0];
    return bulletStr;
}


- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        NSArray *data = @[@"暗恋是一种礼貌，自恋是一种骄傲，明恋是一种格调，不恋是种味道",
                          @"活着就要活出自己的一番风味",
                          @"谁说男人比女人强，有本事让男人生个孩子",
                          @"美女无处不在，老婆无人取代",
                          @"幸福是两个人的事情，分手是一个人的意愿",
                          @"如果人生真的如梦，为何醒不来",
                          @"暗恋就是，一个人写两个人的故事",
                          @"为什么暗恋那么好，因为暗恋从来不会失恋",
                          @"不需要纷乱的尘嚣，只需要一颗同样鲜活着的心，照应着彼此",
                          @"活着是为了与你相遇，离开也是为了能相聚",
                          @"人生最大杯具：美人迟暮，英雄谢顶",
                          @"人生有时就像电脑，说死机就死机没得商量",
                          @"世上唯一不能复制的是时间，唯一不能重演的是人生",
                          @"每个人出生的时候都是原创，可悲的是，很多人渐渐都成了盗版",
                          @"活着的时候想开点，开心点，因为我们要死很久",
                          @"活着是为了与你相遇，离开也是为了能相聚",
                          @"对不起，我不是故意让你暗恋我的",
                          @"不要忘掉别人生气时候说的话，因为往往那才是真相",
                          @"朋友，不是随便叫的，兄弟不是随便说的，所以我的兄弟很少",
                          @"朋友乃平常亲爱，兄弟为患难而生",
                          ];
        
        _dataSource = [NSMutableArray array];
        for (int i =1 ; i <= 100; i ++) {
            NSInteger index = arc4random()%data.count;
            [_dataSource addObject:data[index]];
        }
    }
    return _dataSource;
}


- (NSMutableArray *)bulletStrings
{
    if (!_bulletStrings) {
        _bulletStrings = [NSMutableArray array];
    }
    return _bulletStrings;
}


- (NSMutableArray *)bulletViews
{
    if (!_bulletViews) {
        _bulletViews = [NSMutableArray array];
    }
    return _bulletViews;
}


@end





