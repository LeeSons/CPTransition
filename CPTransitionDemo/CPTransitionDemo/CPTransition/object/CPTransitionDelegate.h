//
//  CPTransitionDelegate.h
//  CPTransition
//
//  Created by 孙登峰 on 2018/3/14.
//  Copyright © 2018年 morplcp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPTransitionManager.h"

@interface CPTransitionDelegate : NSObject <UITabBarControllerDelegate, UINavigationControllerDelegate, UIViewControllerTransitioningDelegate>

@property (nonatomic, assign) BOOL interactive;
@property (nonatomic, strong) CPPercentDrivenInteractiveTransition *interactiveTransition;
@property (nonatomic, assign) CPTransitionAnimationType transitionAnimationType;

// 是否开启抽屉模式
@property (nonatomic, assign) BOOL drawerMode;
// 抽屉模式打开类型
@property (nonatomic, assign) CPTransitionOpenDrawerType transitionOpenDrawerType;
// 抽屉打开比例 默认0.8
@property (nonatomic, assign) float drawerOpenProportion;

@property (nonatomic, assign) BOOL panOrTap; // 区别是点击tabbar切换的 还是滑动交互切换的 YES的时候是滑动的NO的时候是点击的

@end
