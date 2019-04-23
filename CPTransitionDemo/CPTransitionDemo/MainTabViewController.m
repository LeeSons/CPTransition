//
//  MainTabViewController.m
//  CPTransitionDemo
//
//  Created by Morplcp on 2019/4/23.
//  Copyright © 2019 Morplcp. All rights reserved.
//

#import "MainTabViewController.h"
#import "CPNavViewController.h"

#import "DemoFirstViewController.h"
#import "DemoSeccondViewController.h"

@interface MainTabViewController () <UITabBarControllerDelegate, UIViewControllerTransitioningDelegate, CPTabBarDelegate>

//P_STRONG(CPTransitionDelegate, cp_delegate);
@property (nonatomic, strong) CPTransitionDelegate *cp_delegate;

@property (nonatomic, strong) NSMutableArray *cp_childViewControllers;

@property (nonatomic, assign) NSInteger currentSelectIndex;

@end

@implementation MainTabViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    DemoFirstViewController *vc1 = [DemoFirstViewController new];
    
    DemoSeccondViewController *vc2 = [DemoSeccondViewController new];
    
    DemoFirstViewController *vc3 = [DemoFirstViewController new];
    
    DemoFirstViewController *vc4 = [DemoFirstViewController new];
    
    DemoFirstViewController *vc5 = [DemoFirstViewController new];
    
    [self addChildVC:vc1 title:@"呵呵" image:@"main_tab_home_nor" selectedImage:@"main_tab_home_per" nav:YES];
    [self addChildVC:vc2 title:@"哈哈" image:@"main_tab_article_nor" selectedImage:@"main_tab_article_per" nav:YES];
    [self addChildVC:vc3 title:@"呼呼" image:@"main_tab_map_nor" selectedImage:@"main_tab_map_per" nav:YES];
    [self addChildVC:vc4 title:@"嘻嘻" image:@"main_tab_city_nor" selectedImage:@"main_tab_city_per" nav:YES];
    [self addChildVC:vc5 title:@"嘘嘘" image:@"main_tab_mine_nor" selectedImage:@"main_tab_mine_per" nav:YES];
    
    [self setViewControllers:self.cp_childViewControllers];
    [self settingAppearance];
    _currentSelectIndex = 0;
    
    self.cp_delegate = [[CPTransitionDelegate alloc] init];
    self.delegate = self.cp_delegate;
    
    self.cp_tabBarDidSelectIndex = ^BOOL(NSInteger index)
    {
        NSLog(@"%ld", index);
        return YES;
    };
    
    
    [self setBadges];
    
}

- (void)addChildVC:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage nav:(BOOL)nav
{
    vc.cp_tabBarItem.title = title;
    vc.cp_tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    vc.cp_tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    if (nav)
    {
        vc.needNavBar = YES;
    }
    [self.cp_childViewControllers addObject:vc];
    return;
}

- (void)setBadges
{
    
//    注释部分是测试用滴
    // 第一个
    [self.cp_tabBar.cp_items enumerateObjectsUsingBlock:^(CPTabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         if (idx == 0)
         {
             // 数字角标
             obj.badgeType = CPBadgeTypeNumber;
             [obj setBadgeNumber:10];
         }
         else if (idx == 1)
         {
             // 蓝底 红字角标
             obj.badgeType = CPBadgeTypeNumber;
             [obj setBadgeBgColor:[UIColor blueColor]];
             [obj setBadgeTitleColor:[UIColor redColor]];
             [obj setBadgeNumber:15];
         }
         else if (idx == 2)
         {
             // 绿点角标
             obj.badgeType = CPBadgeTypeDot;
             [obj setBadgeBgColor:[UIColor greenColor]];
             [obj setShowBadgeDot:YES];
         }
         else if (idx == 3)
         {
             //            // 图标角标
             obj.badgeType = CPBadgeTypeDot;
             [obj setBadgeIcon:@"icon_moment_zan_per"];
             [obj setShowBadgeDot:YES];
             
             // 设置 动态角标动画
             [obj setIconBadgeAnimation:^AnimationBlock(UIView *view)
              {
                  // 放大
                  return ^(){
                      view.transform = CGAffineTransformMakeScale(1.5, 1.5);
                  };
                  
              } complet:^AnimationFinishBlock(UIView *view)
              {
                  // 回到原来样子
                  return ^(BOOL finish)
                  {
                      view.transform = CGAffineTransformIdentity;
                  };
              }];
             
             // 连续播放动画
             [obj playBadgeAnimation:0.3 loop:YES];
         }
         else
         {
             // 文字角标
             obj.badgeType = CPBadgeTypeNumber;
             [obj setBadgeText:@"哈哈"];
         }
     }];
}

- (void)settingAppearance
{
    CPTabBar *tabBar = self.cp_tabBar;
    [tabBar setSelectColor:[UIColor blackColor]];
    [tabBar setUnSelectColor:[UIColor lightGrayColor]];
    [tabBar setSelectFont:[UIFont systemFontOfSize:13]];
    [tabBar setUnselectFont:[UIFont systemFontOfSize:11]];
    //    self.cp_tabBar.tintColor = COLOR_WHITE;
    
}

- (NSMutableArray *)cp_childViewControllers
{
    if (!_cp_childViewControllers)
    {
        _cp_childViewControllers = [NSMutableArray array];
    }
    return _cp_childViewControllers;
}

@end
