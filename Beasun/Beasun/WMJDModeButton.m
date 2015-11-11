//
//  WMJDModeButton.m
//  Beasun
//
//  Created by maginawin on 15/9/10.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import "WMJDModeButton.h"
#import "UIColor+Beasun.h"

@implementation WMJDModeButton

+ (WMJDModeButton *)jdModeButtonWithMode:(BLEHelperMassagerMode)mode {
    WMJDModeButton *jdModeButton = [[WMJDModeButton alloc] init];
    
    jdModeButton.mode = mode;
    
    NSString *normalImageName;
    NSString *selectedImageName;
    NSString *title;
    
    switch (mode) {
        case BLEHelperMassagerModeQinFu: {
            normalImageName = @"jindian_qinfu_off";
            selectedImageName = @"jindian_qinfu_on";
            title = NSLocalizedString(@"qinfu", @"");
            break;
        }
        case BLEHelperMassagerModeRouNie: {
            normalImageName = @"jindian_rounie_off";
            selectedImageName = @"jindian_rounie_on";
            title = NSLocalizedString(@"rounie", @"");
            break;
        }
        case BLEHelperMassagerModeZhenJiu: {
            normalImageName = @"jindian_zhenjiu_off";
            selectedImageName = @"jindian_zhenjiu_on";
            title = NSLocalizedString(@"zhenjiu", @"");
            break;
        }
        case BLEHelperMassagerModeTuiNa: {
            normalImageName = @"jindian_tuina_off";
            selectedImageName = @"jindian_tuina_on";
            title = NSLocalizedString(@"tuina", @"");
            break;
        }
        case BLEHelperMassagerModeChuiJi: {
            normalImageName = @"jindian_chuiji_off";
            selectedImageName = @"jindian_chuiji_on";
            title = NSLocalizedString(@"chuiji", @"");
            break;
        }
        case BLEHelperMassagerModeZhiYa: {
            normalImageName = @"jindian_zhiya_off";
            selectedImageName = @"jindian_zhiya_on";
            title = NSLocalizedString(@"zhiya", @"");
            break;
        }
            
        default:
            break;
    }
    
    if (normalImageName && selectedImageName) {
        [jdModeButton setBackgroundImage:[UIImage imageNamed:normalImageName] forState:UIControlStateNormal];
        [jdModeButton setBackgroundImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateHighlighted];
        [jdModeButton setBackgroundImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateSelected];
    }
    
    jdModeButton.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [jdModeButton setTitle:title forState:UIControlStateNormal];
    [jdModeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [jdModeButton setTitleColor:[UIColor beasunJingDianModeSelected] forState:UIControlStateHighlighted];
    [jdModeButton setTitleColor:[UIColor beasunJingDianModeSelected] forState:UIControlStateSelected];
    
    if (title) {
        jdModeButton.titleLabel.text = title;
    }
    
    [jdModeButton setContentEdgeInsets:UIEdgeInsetsMake(30, 0, 0, 0)];
    
    [jdModeButton setSelected:NO];
    
    return jdModeButton;
}

@end
