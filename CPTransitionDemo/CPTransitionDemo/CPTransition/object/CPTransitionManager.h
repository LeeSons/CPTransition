//
//  CPTransitionManager.h
//  CPTransition
//
//  Created by 孙登峰 on 2018/3/14.
//  Copyright © 2018年 morplcp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CPPercentDrivenInteractiveTransition.h"

typedef NS_ENUM(NSUInteger, CPTransitionType)
{
    CPTransitionTypeCustom,    // 自定义
    CPTransitionTypeTabDirectionLeft, // tabBar向左滑动
    CPTransitionTypeTabDirectionRight, // tabBar向右滑动
    CPTransitionTypeNavPush,  // push动画
    CPTransitionTypeNavPop,  // pop动画
    CPTransitionTypePresent,  // present动画
    CPTransitionTypeDismiss,  // dismiss动画
};

typedef NS_ENUM(NSUInteger, CPTransitionAnimationType)
{
    CPTransitionAnimationTypeNone,
    CPTransitionAnimationTypeDefault
};

typedef NS_ENUM(NSUInteger, CPTransitionOpenDrawerType)
{
    CPTransitionOpenDrawerTypeLeft, // 左侧抽屉
    CPTransitionOpenDrawerTypeRight // 右侧抽屉
};

@interface CPTransitionManager : NSObject <UIViewControllerAnimatedTransitioning>

+ (instancetype)manager;

@property (nonatomic, strong) CPPercentDrivenInteractiveTransition *interactiveTransition;

@property (nonatomic, assign) CPTransitionType transitionType;
@property (nonatomic, assign) CPTransitionAnimationType transitionAnimationType;

// 是否开启抽屉模式
@property (nonatomic, assign) BOOL drawerMode;
// 抽屉模式打开类型
@property (nonatomic, assign) CPTransitionOpenDrawerType transitionOpenDrawerType;
// 抽屉打开比例 默认0.8
@property (nonatomic, assign) float drawerOpenProportion;

@property (nonatomic, assign) NSTimeInterval animationDuration;
@property (nonatomic, assign) BOOL panOrTap; // 区别是点击tabbar切换的 还是滑动交互切换的 YES的时候是滑动的NO的时候是点击的
@property (nonatomic, copy) void(^customAnimationBlock)(id <UIViewControllerContextTransitioning> transitionContext); // 自定义的动画代码块

@end
