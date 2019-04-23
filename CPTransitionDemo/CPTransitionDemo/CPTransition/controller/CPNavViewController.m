//
//  CPNavViewController.m
//  zent
//
//  Created by Morplcp on 2018/11/7.
//  Copyright © 2018 zentcm. All rights reserved.
//

#import "CPNavViewController.h"
#import "CPTransitionDelegate.h"
#import "CPTransitionHelper.h"
#import "CPTransitionManager.h"
#import "Aspects.h"
#import <objc/runtime.h>

static char CPNavBarKey;
static char CPShowNavBarKey;

static char CPTransitionDelegateKey;

@interface UIViewController ()

@property (nonatomic, strong) CPTransitionDelegate *cp_delegate;

@end

@implementation UIViewController (CPNavViewController)

+ (void)load
{
    [UIViewController aspect_hookSelector:@selector(viewDidLoad) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info)
     {
         UIViewController *instance = (UIViewController *)info.instance;
         if (instance.needNavBar)
         {
             instance.cp_navBar = [[CPNavigationBar alloc] init];
             [instance.view addSubview:instance.cp_navBar];
         }
     } error:nil];
    
    [UIViewController aspect_hookSelector:@selector(viewWillLayoutSubviews) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info)
     {
         UIViewController *instance = (UIViewController *)info.instance;
         if (instance.cp_navBar)
         {
             [instance.view bringSubviewToFront:instance.cp_navBar];
         }
     } error:nil];
    
    // 拦截获取系统导航控制器的方法，返回自身 (侵入性太强，暂时去掉)
//    [UIViewController aspect_hookSelector:@selector(navigationController) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> info)
//     {
//         UIViewController *instance = (UIViewController *)info.instance;
//         NSInvocation *inv = info.originalInvocation;
//         [inv setReturnValue:&instance];
//     } error:nil];
}

- (void)setCp_navBar:(CPNavigationBar *)cp_navBar
{
    objc_setAssociatedObject(self, &CPNavBarKey, cp_navBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CPNavigationBar *)cp_navBar
{
    return objc_getAssociatedObject(self, &CPNavBarKey);
}

- (void)setNeedNavBar:(BOOL)needNavBar
{
    objc_setAssociatedObject(self, &CPShowNavBarKey, @(needNavBar), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)needNavBar
{
    return objc_getAssociatedObject(self, &CPShowNavBarKey);
}

- (void)setCp_delegate:(CPTransitionDelegate *)cp_delegate
{
    objc_setAssociatedObject(self, &CPTransitionDelegateKey, cp_delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CPTransitionDelegate *)cp_delegate
{
    return objc_getAssociatedObject(self, &CPTransitionDelegateKey);
}

- (void)cp_pushWithAnimationType:(CPTransitionAnimationType)type complete:(void (^)(void))complete
{
    if (!self.cp_delegate)
    {
        self.cp_delegate = [[CPTransitionDelegate alloc] init];
    }
    UIViewController *toVC = self;
    self.transitioningDelegate = self.cp_delegate;
    self.cp_delegate.transitionAnimationType = type;
    
    if (!self.cp_delegate.interactiveTransition)
    {
        self.cp_delegate.interactiveTransition = [[CPPercentDrivenInteractiveTransition alloc] initWithVc:toVC screenMode:YES];
    }
    self.modalPresentationStyle = UIModalPresentationCustom;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (type)
        {
            case CPTransitionAnimationTypeNone:
                [[CPTransitionHelper cp_topViewController] presentViewController:toVC animated:NO completion:complete];
                break;
            case CPTransitionAnimationTypeDefault:
                [[CPTransitionHelper cp_topViewController] presentViewController:toVC animated:YES completion:complete];
            default:
                break;
        }
    });
}

- (void)cp_openDrawerWithType:(CPTransitionOpenDrawerType)type complete:(void(^)(void))complete
{
    [self cp_openDrawerWithType:type proportion:0.8f complete:complete];
}

- (void)cp_openDrawerWithType:(CPTransitionOpenDrawerType)type proportion:(float)proportion complete:(void(^)(void))complete
{
    if (!self.cp_delegate)
    {
        self.cp_delegate = [[CPTransitionDelegate alloc] init];
    }
    UIViewController *toVC = self;
    self.transitioningDelegate = self.cp_delegate;
    
    // 打开抽屉模式
    self.cp_delegate.drawerMode = YES;
    // 设置抽屉打开类型
    self.cp_delegate.transitionOpenDrawerType = type;
    // 设置抽屉打开比例
    self.cp_delegate.drawerOpenProportion = proportion;
    
    // 设置手势为抽屉模式 (用来拖拽关闭抽屉)
    if (!self.cp_delegate.interactiveTransition)
    {
        self.cp_delegate.interactiveTransition = [[CPPercentDrivenInteractiveTransition alloc] initWithVc:toVC screenMode:YES];
        self.cp_delegate.interactiveTransition.drawerMode = YES;
    }
    
    self.modalPresentationStyle = UIModalPresentationCustom;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[CPTransitionHelper cp_topViewController] presentViewController:toVC animated:YES completion:complete];
    });
}

@end
