//
//  CPTransitionManager.m
//  CPTransition
//
//  Created by 孙登峰 on 2018/3/14.
//  Copyright © 2018年 morplcp. All rights reserved.
//

#import "CPTransitionManager.h"
#import "CPFrameworkMacro.h"

@interface CPTransitionManager ()

@end

@implementation CPTransitionManager
{
    id <UIViewControllerContextTransitioning> _transitionContext;
    UIView *_maskView;
}

+ (instancetype)manager
{
    static CPTransitionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [CPTransitionManager new];
        manager.animationDuration = 0.5f;
        manager.transitionType = -1;
        manager.transitionAnimationType = CPTransitionAnimationTypeDefault;
        manager.drawerMode = NO;
    });
    return manager;
}

#pragma mark -- UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return _animationDuration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    _transitionContext = transitionContext;
    switch (_transitionType)
    {
        case CPTransitionTypeTabDirectionLeft:
        case CPTransitionTypeTabDirectionRight:
            [self doTabBarTransition];
            break;
        case CPTransitionTypeNavPush:
        case CPTransitionTypeNavPop:
            [self doNavigationTransition];
            break;
        case CPTransitionTypeCustom:
            [self doCustomTransition];
            break;
        case CPTransitionTypePresent:
            [self doPresentTransition];
            break;
        case CPTransitionTypeDismiss:
            [self doDismissTransition];
            break;
        default:
            break;
    }
}

// 框架内置tabbar切换动画
- (void)doTabBarTransition
{
    UIView *containerView = [_transitionContext containerView];
    
    UIViewController *fromVC = [_transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIViewController *toVC = [_transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *fromView = fromVC.view;
    UIView *toView = toVC.view;
    
    [containerView addSubview:toView];
    
    toView.alpha = 0;
    void (^animationBlock)(void) = ^()
    {
        fromView.alpha = 0;
        toView.alpha = 1;
    };
    void (^finishedBlock)(BOOL finished) = ^(BOOL finished)
    {
        [self->_transitionContext completeTransition:!self->_transitionContext.transitionWasCancelled];
    };
    [self addAnimationBlock:animationBlock completion:finishedBlock];
}

// 框架内置简单的 push/pop动画，建议自定义哦
- (void)doNavigationTransition
{
    UIView *containerView = [_transitionContext containerView];
    
    UIViewController *fromVC = [_transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIViewController *toVC = [_transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *fromView = fromVC.view;
    UIView *toView = toVC.view;
    
    CGFloat translation = containerView.frame.size.width;
    CGAffineTransform fromViewTransform = CGAffineTransformIdentity;
    CGAffineTransform toViewTransform = CGAffineTransformIdentity;
    if (_transitionType == CPTransitionTypeNavPush)
    {
        fromViewTransform = CGAffineTransformMakeScale(0.9, 0.9);
        toViewTransform = CGAffineTransformMakeTranslation(translation, 0);
        [containerView addSubview:toView];
    }
    else if (_transitionType == CPTransitionTypeNavPop)
    {
        fromViewTransform = CGAffineTransformMakeTranslation(translation, 0);
        toViewTransform = CGAffineTransformMakeScale(0.9, 0.9);
        [containerView addSubview:toView];
        [containerView addSubview:fromView];
    }
    toView.transform = toViewTransform;
    void (^animationBlock)(void) = ^()
    {
        //        self.fromView.transform = fromViewTransform;
        fromVC.navigationController.view.transform = fromViewTransform;
        toView.transform = CGAffineTransformIdentity;
    };
    void (^finishedBlock)(BOOL finished) = ^(BOOL finished)
    {
        fromView.transform = CGAffineTransformIdentity;
        toView.transform = CGAffineTransformIdentity;
        [self->_transitionContext completeTransition:!self->_transitionContext.transitionWasCancelled];
    };
    [self addAnimationBlock:animationBlock completion:finishedBlock];
}

- (void)doPresentTransition
{
    if (self.transitionAnimationType == CPTransitionAnimationTypeNone)
    {
        return;
    }
    [self doModalPresentAnimation];
}

- (void)doDismissTransition
{
    if (self.transitionAnimationType == CPTransitionAnimationTypeNone)
    {
        return;
    }
    [self doModalDismissAnimation];
}

- (void)doModalPresentAnimation
{
    if (_maskView)
    {
        [_maskView removeFromSuperview];
        _maskView = nil;
    }
    UIView *containerView = [_transitionContext containerView];
    containerView.backgroundColor = [UIColor blackColor];
    UIViewController *fromVC = [_transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [_transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIImageView *fromSnapView = [[UIImageView alloc] initWithImage:[self makeImageWithView:fromVC.view withSize:containerView.bounds.size]];
    fromSnapView.frame = containerView.frame;
    CGRect finalFrameForVC = [_transitionContext finalFrameForViewController:toVC];
    
    [containerView addSubview:fromSnapView];
    fromVC.view.hidden = YES;
    if (self.drawerMode)
    {
        _maskView = [[UIView alloc] initWithFrame:containerView.frame];
        _maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
        [containerView addSubview:_maskView];
        _maskView.alpha = 0;
        
        CGFloat originalWidth = finalFrameForVC.size.width;
        
        finalFrameForVC.size.width = originalWidth * self.drawerOpenProportion;
        
        finalFrameForVC.origin.x = (self.transitionOpenDrawerType == CPTransitionOpenDrawerTypeRight?originalWidth * (1 - self.drawerOpenProportion):0);
        
        // maskView添加tap手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeTheDrawer)];
        [_maskView addGestureRecognizer:tap];
        
        // maskView添加pan手势
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panToCloseDrawer:)];
        [_maskView addGestureRecognizer:pan];
    }
    [containerView addSubview:toVC.view];
    
    
    CGFloat fromViewScale = self.drawerMode?1:0.95;
    CGAffineTransform fromViewTransform = CGAffineTransformMakeScale(fromViewScale, fromViewScale);
    toVC.view.frame = CGRectOffset(finalFrameForVC, self.drawerMode?(self.transitionOpenDrawerType == CPTransitionOpenDrawerTypeLeft?-finalFrameForVC.size.width:finalFrameForVC.size.width):CP_SCREEN_WIDTH, 0);
    void (^animationBlock)(void) = ^()
    {
        fromSnapView.transform = fromViewTransform;
        toVC.view.frame = finalFrameForVC;
        if (self->_maskView)
        {
            self->_maskView.alpha = 1;
        }
    };
    void (^finishedBlock)(BOOL finished) = ^(BOOL finished)
    {
        [self->_transitionContext completeTransition:!self->_transitionContext.transitionWasCancelled];
    };
    [self addAnimationBlock:animationBlock completion:finishedBlock];
}

- (void)closeTheDrawer
{
    UIViewController *toVC = [_transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    [toVC dismissViewControllerAnimated:YES completion:nil];
}

- (void)panToCloseDrawer:(UIPanGestureRecognizer *)sender
{
    CPPercentDrivenInteractiveTransition *percentDrivenInteractiveTransition = self.interactiveTransition;
    [percentDrivenInteractiveTransition panGestureHander:sender];
}

- (void)doModalDismissAnimation
{
    _panOrTap = YES;
    UIView *containerView = [_transitionContext containerView];
    containerView.backgroundColor = [UIColor blackColor];
    
    UIViewController *fromVC = [_transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIViewController *toVC = [_transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIImageView *toSnapView = containerView.subviews.firstObject;
    
    CGRect initFrame = [_transitionContext initialFrameForViewController:fromVC];
    
    [toVC beginAppearanceTransition:YES animated:YES];
    
    CGRect finalFrame = CGRectOffset(initFrame, self.drawerMode?(self.transitionOpenDrawerType == CPTransitionOpenDrawerTypeLeft?-initFrame.size.width:initFrame.size.width):CP_SCREEN_WIDTH, 0);
    void (^animationBlock)(void) = ^()
    {
        toSnapView.transform = CGAffineTransformIdentity;
        if (self->_maskView)
        {
            self->_maskView.alpha = 0;
        }
        fromVC.view.frame = finalFrame;
    };
    void (^finishedBlock)(BOOL finished) = ^(BOOL finished)
    {
        if (!self->_transitionContext.transitionWasCancelled)
        {
            [toSnapView removeFromSuperview];
            toVC.view.hidden = NO;
            if (self->_maskView)
            {
                [self->_maskView removeFromSuperview];
                self->_maskView = nil;
            }
            [toVC endAppearanceTransition];
        }
        self->_panOrTap = NO;
        [self->_transitionContext completeTransition:!self->_transitionContext.transitionWasCancelled];
    };
    [self addAnimationBlock:animationBlock completion:finishedBlock];
}

// 执行自定义动画
- (void)doCustomTransition
{
    if (self.transitionAnimationType == CPTransitionAnimationTypeNone)
    {
        return;
    }
    
    if (self.customAnimationBlock)
    {
        self.customAnimationBlock(_transitionContext);
    }
}

#pragma mark -- 执行动画
- (void)addAnimationBlock:(void(^)(void))block completion:(void(^)(BOOL finished))completion
{
    if (_panOrTap)
    {
        [UIView animateWithDuration:0.3 animations:block completion:completion];
    }
    else
    {
        [UIView animateWithDuration:_animationDuration delay:0 usingSpringWithDamping:1 initialSpringVelocity:5 options:0 animations:block completion:completion];
    }
}

- (UIImage *)makeImageWithView:(UIView *)view withSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
