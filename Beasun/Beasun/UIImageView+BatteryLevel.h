//
//  UIImageView+BatteryLevel.h
//  Beasun
//
//  Created by maginawin on 15/9/14.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DeviceBatteryLevel) {
    DeviceBatteryLevelUnknown = 0x00,
    DeviceBatteryLevel1 = 0x01,
    DeviceBatteryLevel2 = 0x02,
    DeviceBatteryLevel3 = 0x03,
    DeviceBatteryLevel4 = 0x04,
    DeviceBatteryLevelDisconnect = 0xFF
};

@interface UIImageView (BatteryLevel)

- (void)updateImageForDeviceBatteryLevel:(DeviceBatteryLevel)level;

@end
