//
//  UIColor+Beasun.m
//  Beasun
//
//  Created by maginawin on 15/8/31.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import "UIColor+Beasun.h"

@implementation UIColor (Beasun)

+ (UIColor *)beasunTabBarTint {
    return [UIColor colorWithRed:64/255.f green:64/255.f blue:64/255.f alpha:1.f];
}

+ (UIColor *)beasunNavBarTint {
    return [UIColor colorWithRed:238/255.f green:118/255.f blue:0/255.f alpha:1.f];
}

+ (UIColor *)beasunTableViewBackground {
    return [UIColor colorWithRed:243/255.f green:236/255.f blue:224/255.f alpha:1.f];
}

+ (NSArray *)beasunLDTJColors {
    
    UIColor *color0 = [UIColor colorWithRed:41/255.f green:142/255.f blue:201/255.f alpha:1.f];
    UIColor *color1 = [UIColor colorWithRed:59/255.f green:186/255.f blue:187/255.f alpha:1.f];
    UIColor *color2 = [UIColor colorWithRed:77/255.f green:208/255.f blue:173/255.f alpha:1.f];
    UIColor *color3 = [UIColor colorWithRed:122/255.f green:213/255.f blue:141/255.f alpha:1.f];
    UIColor *color4 = [UIColor colorWithRed:183/255.f green:203/255.f blue:101/255.f alpha:1.f];
    UIColor *color5 = [UIColor colorWithRed:238/255.f green:183/255.f blue:62/255.f alpha:1.f];
    UIColor *color6 = [UIColor colorWithRed:255/255.f green:158/255.f blue:39/255.f alpha:1.f];
    UIColor *color7 = [UIColor colorWithRed:252/255.f green:122/255.f blue:29/255.f alpha:1.f];
    UIColor *color8 = [UIColor colorWithRed:244/255.f green:103/255.f blue:26/255.f alpha:1.f];
    UIColor *color9 = [UIColor colorWithRed:226/255.f green:67/255.f blue:23/255.f alpha:1.f];
    UIColor *color10 = [UIColor colorWithRed:212/255.f green:39/255.f blue:20/255.f alpha:1.f];
    
    return @[color0, color1, color2, color3, color4, color5, color6, color7, color8, color9, color10];
}

+ (UIColor *)beasunJingDianModeSelected {
    return [UIColor colorWithRed:0 green:180/255.f blue:1.f alpha:1.f];
}

+ (UIColor *)beasunNavSwitchSelectedColor {
    return [UIColor colorWithRed:250/255.f green:200/255.f blue:0 alpha:1.f];
}

@end
