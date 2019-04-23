//
//  CPTabBarController.h
//  CPTabBarController
//
//  Created by 孙登峰 on 2018/3/12.
//  Copyright © 2018年 morplcp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPTabBar.h"
#import "CPTabBarItem.h"
#import "CPFrameworkMacro.h"
#import "CPTransitionDelegate.h"

@interface CPTabBarController : UITabBarController

@property (nonatomic, readwrite, copy) NSArray<NSDictionary *> * _Nullable cp_tabBarItemsAttributes;

@property (nonatomic, copy) BOOL (^ _Nullable cp_tabBarDidSelectIndex)(NSInteger index);

@property (nonatomic, readonly) CPTabBar * _Nullable cp_tabBar;

- (void)cp_setSelectedIndex:(NSUInteger)selectedIndex;

@end

@interface UIViewController (CPTabBar)

@property (nonatomic, readonly, weak) CPTabBarController * _Nullable cp_tabBarController;
@property (nonatomic, readonly, weak) CPTabBar * _Nullable cp_tabBar;
@property (null_resettable, nonatomic, strong) CPTabBarItem *cp_tabBarItem;

@end

