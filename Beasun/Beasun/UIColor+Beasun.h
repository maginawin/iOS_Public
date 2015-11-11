//
//  UIColor+Beasun.h
//  Beasun
//
//  Created by maginawin on 15/8/31.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Beasun)

// 底部标签栏背景色
+ (UIColor *)beasunTabBarTint;

// 导航条背景色
+ (UIColor *)beasunNavBarTint;

// 主要背景色
+ (UIColor *)beasunTableViewBackground;

// 力度调节颜色们
+ (NSArray *)beasunLDTJColors;

// 模式选中色
+ (UIColor *)beasunJingDianModeSelected;

/** 导航栏中 Switch 选中色 */
+ (UIColor *)beasunNavSwitchSelectedColor;

@end
