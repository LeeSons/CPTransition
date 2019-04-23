//
//  CPTabBarController.m
//  CPTabBarController
//
//  Created by 孙登峰 on 2018/3/12.
//  Copyright © 2018年 morplcp. All rights reserved.
//

#import "CPTabBarController.h"
#import "Aspects.h"
#import <objc/runtime.h>

@interface CPTabBarController () <CPTabBarDelegate>

@property (nonatomic, strong) CPTabBar *cp_tabBar;

@end

@implementation CPTabBarController
{
    NSInteger _viewControllerCount;
}

- (void)dealloc
{
    NSLog(@"释放了就很棒");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTabBar];
}

#pragma mark -- CPTabBarDelegate
- (void)cp_tabBar:(CPTabBar *)tabBar didSelectItem:(CPTabBarItem *)item
{
    BOOL result = YES;
    if (self.cp_tabBarDidSelectIndex)
    {
        result = self.cp_tabBarDidSelectIndex([tabBar.cp_items indexOfObject:item]);
    }
    if (result)
    {
        [self setSelectedViewController:item.viewController];
    }
}

- (void)cp_setSelectedIndex:(NSUInteger)selectedIndex
{
    if (selectedIndex < 0 || selectedIndex >= self.cp_tabBar.cp_items.count)
    {
        return;
    }
    [self.cp_tabBar setSelectIndex:selectedIndex];
    CPTabBarItem *item = self.cp_tabBar.cp_items[selectedIndex];
    [self setSelectedViewController:item.viewController];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    [self.cp_tabBar setSelectIndex:selectedIndex];
}

- (void)setTabBar
{
    self.tabBar.hidden = YES;
    [self.view addSubview:self.cp_tabBar];
    self.cp_tabBar.frame = CGRectMake(0, CP_SCREEN_HEIGHT - CP_TABBAR_HEIGHT, CP_SCREEN_WIDTH, CP_TABBAR_HEIGHT);
//    [self.cp_tabBar mas_makeConstraints:^(MASConstraintMaker *make)
//    {
//        make.left.bottom.right.mas_equalTo(0);
//        make.height.mas_equalTo(TABBAR_HEIGHT);
//    }];
    [self.cp_tabBar layoutIfNeeded];
}

- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers
{
    [super setViewControllers:viewControllers];
    NSMutableArray *items = [NSMutableArray array];
    for (UIViewController *viewController in viewControllers)
    {
        [items addObject:viewController.cp_tabBarItem];
        viewController.cp_tabBarItem.cp_tabBar = self.cp_tabBar;
    }
    self.cp_tabBar.cp_items = items;
}

- (void)setSelectedViewController:(__kindof UIViewController *)selectedViewController
{
    [super setSelectedViewController:selectedViewController];
    self.cp_tabBar.selectItem = selectedViewController.cp_tabBarItem;
}

- (void)setCp_tabBarItemsAttributes:(NSArray<NSDictionary *> *)cp_tabBarItemsAttributes
{
    _cp_tabBarItemsAttributes = cp_tabBarItemsAttributes;
}

- (CPTabBar *)cp_tabBar
{
    if (!_cp_tabBar)
    {
        _cp_tabBar = [[CPTabBar alloc] initWithFrame:CGRectMake(0, CP_SCREEN_HEIGHT - CP_TABBAR_HEIGHT, CP_SCREEN_WIDTH, CP_TABBAR_HEIGHT)];
        _cp_tabBar.cp_delegate = self;
    }
    return _cp_tabBar;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

static char CPTabBarItemKey;


@implementation UIViewController(CPTabBar)

+ (void)load
{
    [UIViewController aspect_hookSelector:@selector(init) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info)
     {
         UIViewController *instance = (UIViewController *)info.instance;
         if (!instance.cp_tabBarItem)
         {
             instance.cp_tabBarItem = [[CPTabBarItem alloc] init];
             instance.cp_tabBarItem.viewController = instance;
         }
     } error:nil];
    
    [UIViewController aspect_hookSelector:@selector(initWithCoder:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info)
     {
         UIViewController *instance = (UIViewController *)info.instance;
         if (!instance.cp_tabBarItem)
         {
             instance.cp_tabBarItem = [[CPTabBarItem alloc] init];
             instance.cp_tabBarItem.viewController = instance;
         }
     } error:nil];
    
    [UIViewController aspect_hookSelector:@selector(initWithNibName:bundle:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info)
     {
         UIViewController *instance = (UIViewController *)info.instance;
         if (!instance.cp_tabBarItem)
         {
             instance.cp_tabBarItem = [[CPTabBarItem alloc] init];
             instance.cp_tabBarItem.viewController = instance;
         }
     } error:nil];
    
//    [UIViewController aspect_hookSelector:@selector(setTitle:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info)
//     {
//         UIViewController *instance = (UIViewController *)info.instance;
//         if (info.arguments.firstObject && [info.arguments.firstObject isKindOfClass:[NSString class]])
//         {
//             instance.navigationItem.title = info.arguments.firstObject;
//             instance.cp_tabBarItem.title = info.arguments.firstObject;
//         }
//     } error:nil];
}

- (void)setCp_tabBarItem:(CPTabBarItem *)cp_tabBarItem
{
    objc_setAssociatedObject(self, &CPTabBarItemKey, cp_tabBarItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CPTabBarItem *)cp_tabBarItem
{
    return objc_getAssociatedObject(self, &CPTabBarItemKey);
}

- (CPTabBarController *)cp_tabBarController
{
    if (self.tabBarController&&[self.tabBarController isKindOfClass:[CPTabBarController class]])
    {
        return (CPTabBarController *)self.tabBarController;
    }
    return nil;
}

- (CPTabBar *)cp_tabBar
{
    if (self.tabBarController&&[self.tabBarController isKindOfClass:[CPTabBarController class]])
    {
        return (CPTabBar *)self.tabBarController.cp_tabBar;
    }
    return nil;
}

@end
