//
//  BulletManager.h
//  YHSBulletExample
//
//  Created by YANGHAISHENG on 2017/2/26.
//  Copyright © 2017年 YANGHAISHENG. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BulletView;


@interface BulletManager : NSObject


@property (nonatomic, copy) void(^generateBulletBlock)(BulletView *view);


/** 弹幕开始执行 */
- (void)start;


/** 弹幕停止执行 */
- (void)stop;


@end


