//
//  WMSavedPeripheral.h
//  Beasun
//
//  Created by maginawin on 15/9/6.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMPeripheral.h"
@class CBPeripheral;

@interface WMSavedPeripheral : NSObject

/** WMPeripherals */
+ (NSArray *)savedPeripheral;

+ (void)addPeripheral:(CBPeripheral *)peripheral;

+ (void)alterPeripheral:(WMPeripheral *)peripheral;

+ (void)removePeripheral:(WMPeripheral *)peripheral;

+ (void)removeAllPeripherals;

+ (BOOL)isSavedPeripheral:(CBPeripheral *)peripheral;

@end
