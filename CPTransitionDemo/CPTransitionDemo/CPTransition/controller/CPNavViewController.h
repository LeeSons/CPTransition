//
//  CPNavViewController.h
//  zent
//
//  Created by Morplcp on 2018/11/7.
//  Copyright © 2018 zentcm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPTransitionManager.h"
#import "CPNavigationBar.h"

@interface UIViewController (CPNavViewController)

@property (nonatomic, assign) BOOL needNavBar; // 是否需要导航栏 默认不需要
@property (nonatomic, strong) CPNavigationBar * _Nullable cp_navBar;

/**
 push页面

 @param type 动画类型
 @param complete 完成回调
 */
- (void)cp_pushWithAnimationType:(CPTransitionAnimationType)type complete:(void(^_Nullable)(void))complete;

/**
 侧面打开页面

 @param type 类型（左侧、右侧）
 @param complete 完成回调
 */
- (void)cp_openDrawerWithType:(CPTransitionOpenDrawerType)type complete:(void(^_Nullable)(void))complete;

/**
 侧面打开页面

 @param type 类型（左侧、右侧）
 @param proportion 页面宽度比例 默认0.8
 @param complete 完成回调
 */
- (void)cp_openDrawerWithType:(CPTransitionOpenDrawerType)type proportion:(float)proportion complete:(void(^_Nullable)(void))complete;

@end
