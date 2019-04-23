//
//  CPNavigationBar.h
//  zent
//
//  Created by Morplcp on 2018/11/16.
//  Copyright © 2018 zentcm. All rights reserved.
//

#import <UIKit/UIKit.h>

// 导航条高度改变通知
UIKIT_EXTERN NSString *const CPNavigationBarHeightDidChangeNotification;

@interface CPNavigationBar : UIView

// 标题视图
@property (nonatomic, strong) UIView *titleView;

@property (nonatomic, strong) UIBarButtonItem *leftItem;
@property (nonatomic, copy) NSArray <UIBarButtonItem *> *leftItems;

@property (nonatomic, strong) UIBarButtonItem *rightItem;
@property (nonatomic, copy) NSArray <UIBarButtonItem *> *rightItems;

@property (nonatomic, assign) BOOL showLineView; // 是否显示分割线 默认YES
@property (nonatomic, strong) UIColor *lineColor; // 分割线颜色 默认 lightGrayColor
@property (nonatomic, assign) BOOL blurEffect; // 是否显示模糊效果 默认YES
@property (nonatomic, assign) UIBlurEffectStyle blurEffectStyle; // 模糊效果风格 默认 UIBlurEffectStyleLight
@property (nonatomic, strong) UIColor *backColor; // 背景颜色 默认 nil 当设置了背景色之后 模糊效果会失效。 设置为透明的时候 分割线也去掉

// 标题属性 （字体默认15、字体颜色默认 black）
@property (nonatomic, copy) NSDictionary *titleTextAttribute;

// 按钮字体属性 (字体默认15、字体颜色默认 black)
@property (nonatomic, copy) NSDictionary *itemTextAttribute;

// 标题
@property (nonatomic, copy) NSString *title;

@end
