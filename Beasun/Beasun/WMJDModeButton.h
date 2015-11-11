//
//  WMJDModeButton.h
//  Beasun
//
//  Created by maginawin on 15/9/10.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

// 经典模式下的模式按钮

#import <UIKit/UIKit.h>
#import "WMBLEHelper.h"

@interface WMJDModeButton : UIButton

+ (WMJDModeButton *)jdModeButtonWithMode:(BLEHelperMassagerMode)mode;

@property (assign, nonatomic) BLEHelperMassagerMode mode;

@end
