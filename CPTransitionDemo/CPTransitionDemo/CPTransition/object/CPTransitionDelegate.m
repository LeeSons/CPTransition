//
//  CPTransitionDelegate.m
//  CPTransition
//
//  Created by 孙登峰 on 2018/3/14.
//  Copyright © 2018年 morplcp. All rights reserved.
//

#import "CPTransitionDelegate.h"

@interface CPTransitionDelegate ()

@end

@implementation CPTransitionDelegate

#pragma mark -- UITabBarControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController animationControllerForTransitionFromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    CPTransitionManager *manager = [CPTransitionManager manager];
    NSInteger fromIndex = [tabBarController.viewControllers indexOfObject:fromVC];
    NSInteger toIndex = [tabBarController.viewControllers indexOfObject:toVC];
    if (manager.transitionType != CPTransitionTypeCustom)
    {
        manager.transitionType = toIndex > fromIndex?CPTransitionTypeTabDirectionLeft:CPTransitionTypeTabDirectionRight;
    }
    manager.panOrTap = _panOrTap;
    return manager;
}

//- (id<UIViewControllerInteractiveTransitioning>)tabBarController:(UITabBarController *)tabBarController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
//{
//    return self.interactive?self.interactionTransition:nil;
//}

#pragma mark -- UINavigationControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    CPTransitionManager *manager = [CPTransitionManager manager];
    manager.panOrTap = _panOrTap;
    if (manager.transitionType == CPTransitionTypeCustom)
    {
        return manager;
    }
    if (operation == UINavigationControllerOperationPush)
    {
        manager.transitionType = CPTransitionTypeNavPush;
    }
    else if (operation == UINavigationControllerOperationPop)
    {
        manager.transitionType = CPTransitionTypeNavPop;
    }
    return manager;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    return self.interactive?self.interactiveTransition:nil;
}

#pragma mark -- UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    CPTransitionManager *manager = [CPTransitionManager manager];
    manager.transitionType = CPTransitionTypePresent;
    manager.transitionAnimationType = self.drawerMode?CPTransitionAnimationTypeDefault:self.transitionAnimationType;
    manager.drawerMode = self.drawerMode;
    manager.transitionOpenDrawerType = self.transitionOpenDrawerType;
    manager.drawerOpenProportion = self.drawerOpenProportion;
    manager.interactiveTransition = self.interactiveTransition;
    return manager;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    CPTransitionManager *manager = [CPTransitionManager manager];
    manager.transitionType = CPTransitionTypeDismiss;
    manager.transitionAnimationType = self.drawerMode?CPTransitionAnimationTypeDefault:self.transitionAnimationType;
    manager.drawerMode = self.drawerMode;
    manager.transitionOpenDrawerType = self.transitionOpenDrawerType;
    manager.drawerOpenProportion = self.drawerOpenProportion;
    manager.interactiveTransition = self.interactiveTransition;
    return manager;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return (self.interactiveTransition.isInteracting ? self.interactiveTransition : nil);
}

@end
