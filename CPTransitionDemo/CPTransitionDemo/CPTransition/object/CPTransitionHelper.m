//
//  CPTransitionHelper.m
//  zent
//
//  Created by Morplcp on 2019/4/22.
//  Copyright © 2019 zentcm. All rights reserved.
//

#import "CPTransitionHelper.h"

@implementation CPTransitionHelper

+ (UIImage *)cp_getBundleImage:(NSString *)imageName
{
    CGFloat screenScale = [UIScreen mainScreen].scale;
    NSString *imagePath_2x = [[self sourceBundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@@%dx", imageName, (int)screenScale]];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath_2x];
    return image;
}

+ (NSString *)sourceBundlePath
{
    return [[NSBundle mainBundle] pathForResource:@"CPTransitionResource" ofType:@"bundle"];
}

+ (UIViewController *)cp_topViewController
{
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while(resultVC.presentedViewController)
    {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

+ (UIViewController *)_topViewController:(UIViewController *)vc
{
    if([vc isKindOfClass:[UINavigationController class]])
    {
        return[self _topViewController:[(UINavigationController *)vc topViewController]];
    }
    else if([vc isKindOfClass:[UITabBarController class]])
    {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    }
    else
    {
        return vc;
    }
    return nil;
}

@end
