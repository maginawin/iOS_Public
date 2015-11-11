//
//  WMMassagerModeManager.h
//  Beasun
//
//  Created by maginawin on 15/9/17.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMMassagerMode.h"

@interface WMMassagerModeManager : NSObject

+ (WMMassagerMode *)massagerModeForModeIndex:(NSInteger)modeIndex;

+ (void)saveOrUpdateMassagerMode:(WMMassagerMode *)mode;

+ (void)delegateMassagerModeAtIndex:(NSInteger)index;

+ (NSMutableDictionary *)massagerModes;

+ (NSMutableArray *)massagerModesArray;

@end
