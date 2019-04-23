//
//  CPPercentDrivenInteractiveTransition.m
//  zent
//
//  Created by Morplcp on 2018/11/2.
//  Copyright © 2018 zentcm. All rights reserved.
//

#import "CPPercentDrivenInteractiveTransition.h"
#import "CPFrameworkMacro.h"

@interface CPPercentDrivenInteractiveTransition ()

@property (nonatomic, assign) CGFloat start_x;

@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *edgePanGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *screenPanGesture;

@end

@implementation CPPercentDrivenInteractiveTransition

- (instancetype)initWithVc:(UIViewController *)vc screenMode:(BOOL)screenMode
{
    self = [super init];
    if (self)
    {
        _vc = vc;
        _start_x = 0;
        
        if (screenMode)
        {
            _screenPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHander:)];
            [vc.view addGestureRecognizer:_screenPanGesture];
        }
        else
        {
            _edgePanGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHander:)];
            _edgePanGesture.edges = UIRectEdgeLeft;
            [vc.view addGestureRecognizer:_edgePanGesture];
        }
    }
    return self;
}

- (void)panGestureHander:(UIGestureRecognizer *)gesture
{
    BOOL screenMode = [gesture isKindOfClass:[UIPanGestureRecognizer class]];
    
    switch (gesture.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            _isInteracting = YES;
            _start_x = [gesture locationInView:_vc.view].x;
            [_vc dismissViewControllerAnimated:YES completion:nil];
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            CGFloat fraction = 0;
            CGFloat point_x = 0;
            if (self.drawerMode)
            {
                point_x = [gesture locationInView:_vc.view].x;
                if (point_x > 0)
                {
                    point_x = _start_x - (point_x - _vc.view.frame.size.width);
                }
                else
                {
                    point_x = point_x + _vc.view.frame.size.width - _start_x;
                }
            
                if (point_x > 0)
                {
                    fraction = point_x / _vc.view.frame.size.width;
                }
            }
            else
            {
                if (screenMode)
                {
                    point_x = CP_SCREEN_WIDTH + [gesture locationInView:_vc.view].x;
                    if (screenMode)
                    {
                        point_x -= _start_x;
                    }
                    fraction = (point_x / CP_SCREEN_WIDTH);
                }
            }

            fraction = fmin(fmaxf(fraction, 0.0), 1.0);

            _shouldComplete = fraction > 0.3;
            [self updateInteractiveTransition:fraction];
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            _isInteracting = NO;
            if (!_shouldComplete || gesture.state == UIGestureRecognizerStateCancelled)
            {
                [self cancelInteractiveTransition];
            }
            else
            {
                [self finishInteractiveTransition];
            }
            break;
        }
        default:
            break;
    }
}

@end
