//
//  CPTabBarItem.m
//  CPTabBarController
//
//  Created by Morplcp on 2018/11/6.
//  Copyright © 2018 morplcp. All rights reserved.
//

#import "CPTabBarItem.h"
#import "CPTabBar.h"

@interface CPTabBarItem ()

@property (nonatomic, copy) AnimationBlock animationBlock;
@property (nonatomic, copy) AnimationFinishBlock animationFinishBlock;

@property (nonatomic, assign) BOOL stopBadgeAnimation;

@end

@implementation CPTabBarItem

- (void)dealloc
{
    NSLog(@"释放了就很棒");
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.badgeType = CPBadgeTypeNumber;
        self.badgeTitleColor = [UIColor whiteColor];
        self.stopBadgeAnimation = NO;
    }
    return self;
}

- (void)setBadgeType:(CPBadgeType)badgeType
{
    _badgeType = badgeType;
    self.cp_tabBarButton.badgeType = badgeType;
}

- (void)setBadgeNumber:(NSInteger)badgeNumber
{
    _badgeNumber = badgeNumber;
    if (self.badgeType == CPBadgeTypeNumber)
    {
        if (badgeNumber <= 0)
        {
            self.cp_tabBarButton.badgeView.hidden = YES;
            [self.cp_tabBarButton.badgeView setTitle:[NSString stringWithFormat:@"%ld", badgeNumber] forState:UIControlStateNormal];
        }
        else
        {
            self.cp_tabBarButton.badgeView.hidden = NO;
            [self.cp_tabBarButton.badgeView setTitle:[NSString stringWithFormat:@"%ld", badgeNumber] forState:UIControlStateNormal];
        }
    }
}

- (void)setBadgeText:(NSString *)badgeText
{
    _badgeText = badgeText;
    if (self.badgeType == CPBadgeTypeNumber)
    {
        if (badgeText)
        {
            self.cp_tabBarButton.badgeView.hidden = NO;
            [self.cp_tabBarButton.badgeView setTitle:[NSString stringWithFormat:@"%@", badgeText] forState:UIControlStateNormal];
        }
        else
        {
            self.cp_tabBarButton.badgeView.hidden = YES;
            [self.cp_tabBarButton.badgeView setTitle:[NSString stringWithFormat:@"%@", badgeText] forState:UIControlStateNormal];
        }
    }
}

- (void)setShowBadgeDot:(BOOL)showBadgeDot
{
    _showBadgeDot = showBadgeDot;
    if (self.badgeType == CPBadgeTypeDot)
    {
        self.cp_tabBarButton.badgeView.hidden = !showBadgeDot;
    }
}

- (void)setBadgeIcon:(NSString *)badgeIcon
{
    _badgeIcon = badgeIcon;
    if (self.badgeType == CPBadgeTypeDot)
    {
        [self setBadgeBgColor:[UIColor clearColor]]; // 图标角标不需要背景色
        [self.cp_tabBarButton.badgeView setBackgroundImage:[[UIImage imageNamed:badgeIcon] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }
}

// 设置角标动画
- (void)setIconBadgeAnimation:(AnimationBlock(^)(UIView *view))animation complet:(AnimationFinishBlock(^)(UIView *view))complet
{
    if (!animation || !complet)
    {
        return;
    }
    if (self.badgeType != CPBadgeTypeDot)
    {
        return;
    }
    self.animationBlock = animation(self.cp_tabBarButton.badgeView);
    self.animationFinishBlock = complet(self.cp_tabBarButton.badgeView);
}

// 播放角标动画 loop:是否循环播放
- (void)playBadgeAnimation:(NSTimeInterval)duration loop:(BOOL)loop
{
    if (loop)
    {
        __weak typeof(self)weakSelf = self;
        [UIView animateWithDuration:duration animations:self.animationBlock completion:^(BOOL finished) {
            weakSelf.animationFinishBlock(finished);
            [weakSelf playBadgeAnimation:duration loop:loop];
        }];
    }
    else
    {
        [UIView animateWithDuration:duration animations:self.animationBlock completion:self.animationFinishBlock];
    }
}

// 停止播放角标动画
- (void)stopPlayBadgeAnimation
{
    // 添加播放障碍
}

- (void)setBadgeBgColor:(UIColor *)badgeBgColor
{
    self.cp_tabBarButton.badgeView.backgroundColor = badgeBgColor;
}

- (void)setBadgeTitleColor:(UIColor *)badgeTitleColor
{
    _badgeTitleColor = badgeTitleColor;
    [self.cp_tabBarButton.badgeView setTitleColor:badgeTitleColor forState:UIControlStateNormal];
}

@end
