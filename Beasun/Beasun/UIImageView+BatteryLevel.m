//
//  UIImageView+BatteryLevel.m
//  Beasun
//
//  Created by maginawin on 15/9/14.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import "UIImageView+BatteryLevel.h"

@implementation UIImageView (BatteryLevel)

- (void)updateImageForDeviceBatteryLevel:(DeviceBatteryLevel)level {
    switch (level) {

        case DeviceBatteryLevelDisconnect: {
            self.image = nil;
//            self.hidden = YES;
            break;
        }
            
        default: {
            NSString *imageName = [NSString stringWithFormat:@"%@%d", @"battery", (int)level];
            self.image = [UIImage imageNamed:imageName];
            
            break;
        }
    }
    
}

@end
