//
//  CPTabBarItem.h
//  CPTabBarController
//
//  Created by Morplcp on 2018/11/6.
//  Copyright © 2018 morplcp. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AnimationBlock)(void); // 动画块
typedef void(^AnimationFinishBlock)(BOOL finished); // 动画完成块

@class CPTabBar, CPTabBarButton;
typedef NS_ENUM(NSUInteger, CPBadgeType) {
    CPBadgeTypeNumber,
    CPBadgeTypeDot
};

@interface CPTabBarItem : UITabBarItem

@property (nonatomic, weak) CPTabBar *cp_tabBar;
@property (nonatomic, weak) CPTabBarButton *cp_tabBarButton;
@property (nonatomic, weak) UIViewController *viewController;

@property (nonatomic, assign) CPBadgeType badgeType;
@property (nonatomic, assign) NSInteger badgeNumber;
@property (nonatomic, copy) NSString *badgeText;
@property (nonatomic, copy) NSString *badgeIcon;
@property (nonatomic, strong) UIColor *badgeBgColor;
@property (nonatomic, strong) UIColor *badgeTitleColor;
@property (nonatomic, assign) BOOL showBadgeDot;

// 设置角标动画
- (void)setIconBadgeAnimation:(AnimationBlock(^)(UIView *view))animation complet:(AnimationFinishBlock(^)(UIView *view))complet;

// 播放角标动画 loop:是否循环播放
- (void)playBadgeAnimation:(NSTimeInterval)duration loop:(BOOL)loop;

// 停止播放角标动画
- (void)stopPlayBadgeAnimation;

@end
