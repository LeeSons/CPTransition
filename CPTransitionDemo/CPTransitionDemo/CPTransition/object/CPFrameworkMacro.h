//
//  CPFrameworkMacro.h
//  CPTabBarController
//
//  Created by Morplcp on 2018/11/6.
//  Copyright © 2018 morplcp. All rights reserved.
//

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000 // 当前Xcode支持iOS8及以上
#define CP_SCREEN_WIDTH                    ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.width)

#define CP_SCREEN_HEIGHT                   ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.height)

#define CP_SCREEN_SIZE                     ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?CGSizeMake([UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale,[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale):[UIScreen mainScreen].bounds.size)
#else
#define CP_SCREEN_WIDTH                    [UIScreen mainScreen].bounds.size.width
#define CP_SCREENH_HEIGHT                  [UIScreen mainScreen].bounds.size.height
#define CP_SCREEN_SIZE                     [UIScreen mainScreen].bounds.size
#endif

#define CP_SCREEN_MAX_LENGTH               MAX(CP_SCREEN_WIDTH, CP_SCREEN_HEIGHT)
#define CP_SCREEN_MIN_LENGTH               MIN(CP_SCREEN_WIDTH, CP_SCREEN_HEIGHT)

#define CP_IS_PORTRAIT                     UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation) ||\
UIDeviceOrientationIsPortrait(self.interfaceOrientation)
#define CP_IS_IPAD                         (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define CP_IS_IPHONE                       (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
// 判断当前是否是模拟器
#define CP_IS_SIMULATOR                    (NSNotFound != [[[UIDevice currentDevice] model] rangeOfString:@"Simulator"].location)
// 当前系统版本
#define CP_SYSTEMVERSION                   [[UIDevice currentDevice] systemVersion].floatValue

#define CP_XCODE_VERSION_GREATER_THAN_OR_EQUAL_TO_8    __has_include(<UserNotifications/UserNotifications.h>)
#define CP_SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define CP_SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define CP_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define CP_SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define CP_SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define CP_IS_IPHONE_X  (CP_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11.0") && CP_IS_IPHONE && (CP_SCREEN_MIN_LENGTH == 375 && CP_SCREEN_MAX_LENGTH == 812))
#define CP_IS_IPHONE_XR  (CP_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11.0") && CP_IS_IPHONE && (CP_SCREEN_MIN_LENGTH == 414 && CP_SCREEN_MAX_LENGTH == 896))
#define CP_IS_IPHONE_XS  (CP_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11.0") && CP_IS_IPHONE && (CP_SCREEN_MIN_LENGTH == 375 && CP_SCREEN_MAX_LENGTH == 812))
#define CP_IS_IPHONE_XS_MAX  (CP_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11.0") && CP_IS_IPHONE && (CP_SCREEN_MIN_LENGTH == 414 && CP_SCREEN_MAX_LENGTH == 896))

#define CP_HAVE_SAFE_AREA (CP_IS_IPHONE_X||CP_IS_IPHONE_XR||CP_IS_IPHONE_XS||CP_IS_IPHONE_XS_MAX)

// 状态栏的高度
#define CP_STATUS_HEIGHT  (CP_HAVE_SAFE_AREA?44:20)
#define CP_BOTTOM_SAFEAREA_HEIGHT (CP_HAVE_SAFE_AREA? 34 : 0)

#define CP_NAVBAR_HEIGHT   (CP_STATUS_HEIGHT + 44)

#define CP_TABBAR_HEIGHT   (CP_BOTTOM_SAFEAREA_HEIGHT + 49)

// 安全返回主线程
#define cp_dispatch_main_async_safa(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

#define CP_RESOURCE(resource, extension, imgName, type) ([[NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:resource withExtension:extension]] pathForResource:imgName ofType:type] ? [[NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:resource withExtension:extension]] pathForResource:imgName ofType:type] : [[NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:resource withExtension:extension]] pathForResource:[NSString stringWithFormat:@"%@@2x", imgName] ofType:type] ? [[NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:resource withExtension:extension]] pathForResource:[NSString stringWithFormat:@"%@@2x", imgName] ofType:type] : [[NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:resource withExtension:extension]] pathForResource:[NSString stringWithFormat:@"%@@3x", imgName] ofType:type])

#define CP_RESOURCE_NAMED(imgName) CP_RESOURCE(@"CPTransitionResource", @"bundle", imgName, @"png")

#define CP_COLOR_VALUE(RGBVALUE) [UIColor colorWithRed:(((RGBVALUE & 0xFF0000) >> 16))/255.0 green:(((RGBVALUE & 0xFF00) >> 8)) / 255.0 blue:((RGBVALUE & 0xFF)) / 255.0 alpha:1.0]
