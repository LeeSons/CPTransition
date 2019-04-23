//
//  CPPercentDrivenInteractiveTransition.h
//  zent
//
//  Created by Morplcp on 2018/11/2.
//  Copyright © 2018 zentcm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPPercentDrivenInteractiveTransition : UIPercentDrivenInteractiveTransition

@property (nonatomic, weak) UIViewController *vc;
@property (nonatomic, assign, readonly) BOOL isInteracting;
@property (nonatomic, assign, readonly) BOOL shouldComplete;

@property (nonatomic, assign) BOOL drawerMode; // 是否是抽屉模式

- (instancetype)initWithVc:(UIViewController *)vc screenMode:(BOOL)screenMode;
- (void)panGestureHander:(UIGestureRecognizer *)gesture;

@end
