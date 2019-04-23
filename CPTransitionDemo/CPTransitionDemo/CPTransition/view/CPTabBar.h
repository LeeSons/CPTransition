//
//  CPTabBar.h
//  CPTabBarController
//
//  Created by 孙登峰 on 2018/3/12.
//  Copyright © 2018年 morplcp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPTabBarItem.h"

@class CPTabBar;
@protocol CPTabBarDelegate <NSObject>

@optional
- (void)cp_tabBar:(CPTabBar *)tabBar didSelectItem:(CPTabBarItem *)item;

@end

@interface CPTabBarButton : UIButton

@property (nonatomic, strong) UIButton *badgeView;

@property (nonatomic, assign) CPBadgeType badgeType;

- (void)setTitle:(NSString *)title;
- (void)setTitleColor:(UIColor *)titleColor;
- (void)setImage:(UIImage *)image;
- (void)setSelectImage:(UIImage *)image;
- (void)setFont:(UIFont *)font;

@end

@interface CPTabBar : UIView

@property (nonatomic, assign) id <CPTabBarDelegate> cp_delegate;
@property (nonatomic, copy) NSArray<CPTabBarItem *> *cp_items;
@property (nonatomic, strong) UIColor *selectColor;
@property (nonatomic, strong) UIColor *unSelectColor;
@property (nonatomic, strong) UIFont *selectFont;
@property (nonatomic, strong) UIFont *unselectFont;
@property (nonatomic, assign) CGFloat scope;
@property (nonatomic, strong) CPTabBarItem *selectItem;

- (void)setTitleColor:(UIColor *)titleColor withIndex:(NSInteger)index;
- (void)setSelectIndex:(NSInteger)index;

@end
