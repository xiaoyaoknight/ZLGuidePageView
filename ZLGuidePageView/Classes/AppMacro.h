//
//  AppMacro.h
//  GuidePage-Demo
//
//  Created by 王泽龙 on 2019/8/2.
//  Copyright © 2019 王泽龙. All rights reserved.
//

#pragma mark - 宽度、高度
/**
 获取SafeAreaInsets, 未考虑横屏情况
 */
static inline UIEdgeInsets SafeAreaInsets() {
    static UIEdgeInsets safeAreaInsets;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (@available(iOS 11.0, *)) {
            // (top = 44, left = 0, bottom = 34, right = 0)
            UIWindow *win = [UIApplication sharedApplication].keyWindow ? : [[UIWindow alloc] init];
            safeAreaInsets = win.safeAreaInsets;
        } else {
            safeAreaInsets = UIEdgeInsetsZero;
        }
    });
    return safeAreaInsets;
};


//  获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

// 底部iPhone X 的安全区域 = 34
#define kSafeAreaBottomHeight (SafeAreaInsets().bottom)

//  NavBar高度
#define kNavigationBarHeight 44

// tabBar的系统默认高度
#define kTabBarHeight (SafeAreaInsets().bottom + 49)

// 状态栏默认高度
#define kStatusBarHeight ([UIApplication sharedApplication].statusBarFrame.size.height)

// 状态栏 + 导航栏高度
#define total_topView_height  (kNavigationBarHeight + kStatusBarHeight)

// 有底部安全区域则为 刘海机型
#define IS_IPHONEX (( SafeAreaInsets().bottom == 0 ) ? NO : YES)

#define AutoSizeScale6 ((SCREEN_WIDTH) / 375.)
/**
 以750的屏幕宽，适配位置
 */
#define AutoSize6(size) ( lroundl((size) * AutoSizeScale6 * 10 / 2.0) / 10.0 )
