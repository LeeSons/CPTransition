//
//  CPTransitionHelper.h
//  zent
//
//  Created by Morplcp on 2019/4/22.
//  Copyright © 2019 zentcm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CPFrameworkMacro.h"

NS_ASSUME_NONNULL_BEGIN

@interface CPTransitionHelper : NSObject

+ (UIImage *)cp_getBundleImage:(NSString *)imageName;

+ (UIViewController *)cp_topViewController;

@end

NS_ASSUME_NONNULL_END
