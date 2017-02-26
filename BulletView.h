//
//  BulletView.h
//  YHSBulletExample
//
//  Created by YANGHAISHENG on 2017/2/26.
//  Copyright © 2017年 YANGHAISHENG. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, BulletMoveStatus) {
    BulletMoveStatusStart,
    BulletMoveStatusEnter,
    BulletMoveStatusEnd,
};


@interface BulletView : UIView

/** 弹道 */
@property (nonatomic,assign) int trajectory;
/** 弹幕状态回调 */
@property (nonatomic,copy) void(^moveStatusBlock)(BulletMoveStatus status);


/** 初始化弹幕 */
- (instancetype)initWithBulletString:(NSString *)string;
/** 开始动画 */
- (void)startAnimation;
/** 结束动画 */
- (void)stopAnimation;

@end



