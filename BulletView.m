//
//  BulletView.m
//  YHSBulletExample
//
//  Created by YANGHAISHENG on 2017/2/26.
//  Copyright © 2017年 YANGHAISHENG. All rights reserved.
//

#import "BulletView.h"

#define Padding 10
#define PhotoSize 30
#define Random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]
#define RandomColor Random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))


@interface BulletView ()
@property (nonatomic, strong) UILabel *bulletLabel;
@property (nonatomic, strong) UIImageView *photoImgView;
@property (nonatomic, assign) BOOL hasDealloc;
@end


@implementation BulletView


/** 初始化弹幕 */
- (instancetype)initWithBulletString:(NSString *)bulletString
{
    self = [super init];
    if (self) {
        // 设置背景
        [self.layer setCornerRadius:PhotoSize/2.0];
        [self setUserInteractionEnabled:NO];
        [self setBackgroundColor:RandomColor];
        
        // 计算弹幕的实际宽度
        NSArray<NSNumber *> *fontSizeArray = @[@9.0, @10.0, @11.0, @12.0, @13.0, @14.0, @15.0, @16.0, @17.0, @18.0, @19.0, @20.0];
        NSInteger index = arc4random()%fontSizeArray.count;
        CGFloat fontSize = fontSizeArray[index].floatValue;
        UIFont *bulletFont = [UIFont systemFontOfSize:fontSize];
        NSDictionary *attr = @{ NSFontAttributeName : bulletFont };
        CGFloat bulletStringWidth = [bulletString sizeWithAttributes:attr].width;
        CGFloat bulletStringHeight = PhotoSize;
        
        // 弹幕标签
        _bulletLabel = [[UILabel alloc] init];
        [_bulletLabel setFont:bulletFont];
        [_bulletLabel setText:bulletString];
        [_bulletLabel setTextColor:[UIColor blackColor]];
        [_bulletLabel setTextAlignment:NSTextAlignmentCenter];
        [_bulletLabel setFrame:CGRectMake(Padding + PhotoSize, 0, bulletStringWidth, bulletStringHeight)];
        [self addSubview:_bulletLabel];
        [self setBounds:CGRectMake(0, 0, bulletStringWidth + 2 * Padding + PhotoSize, bulletStringHeight)];

        // 弹幕头像
        _photoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(-Padding, -Padding/2, PhotoSize + Padding, PhotoSize + Padding)];
        [_photoImgView.layer setBorderWidth:1.0];
        [_photoImgView.layer setBorderColor:[UIColor orangeColor].CGColor];
        [_photoImgView.layer setCornerRadius:(PhotoSize + Padding) / 2.0];
        [_photoImgView setContentMode:UIViewContentModeScaleAspectFill];
        [_photoImgView setBackgroundColor:[UIColor whiteColor]];
        [_photoImgView setClipsToBounds:YES];
        [_photoImgView setImage:[UIImage imageNamed:@"head"]];
        [self addSubview:_photoImgView];
        
    }
    return self;
}


/** 开始动画 */
- (void)startAnimation
{
    // 计算速度以及完全进入屏幕的时间。弹幕越长，动画时间越长, 速度越慢
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat bulletWidth = CGRectGetWidth(self.bounds);
    CGFloat wholeWidth = screenWidth + bulletWidth;
    CGFloat duration = (bulletWidth / (screenWidth / 4)) * 3.0; // 动画时间
    CGFloat speed = wholeWidth / duration; // 弹幕速度
    CGFloat enterDelay = bulletWidth / speed; // 完全进入屏幕的时间
    
    
    // 弹幕开始进入屏幕
    if (self.moveStatusBlock) {
        self.moveStatusBlock(BulletMoveStatusStart);
    }
    
    
    // 弹幕完全进入屏幕
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(enterDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 避免重复，通过变量判断是否已经释放了资源，释放后，不在进行操作
        if (self.hasDealloc) {
            return;
        }
        // duration时间后弹幕完全进入屏幕
        if (self.moveStatusBlock) {
            self.moveStatusBlock(BulletMoveStatusEnter);
        }
    });

    
    // 弹幕完全离开屏幕
    __block CGRect frame = self.frame;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        frame.origin.x = -bulletWidth;
        self.frame = frame;
    } completion:^(BOOL finished) {
        if (self.moveStatusBlock) {
            self.moveStatusBlock(BulletMoveStatusEnd);
        }
        [self removeFromSuperview];
    }];
    
}


/** 结束动画 */
- (void)stopAnimation
{
    self.hasDealloc = YES;
    //
    [self.layer removeAllAnimations];
    [self removeFromSuperview];
}


@end












