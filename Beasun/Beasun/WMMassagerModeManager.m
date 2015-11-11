
//
//  WMMassagerModeManager.m
//  Beasun
//
//  Created by maginawin on 15/9/17.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import "WMMassagerModeManager.h"

NSString *const kMassagerModeManagerDict = @"kMassagerModeManagerDict";

@implementation WMMassagerModeManager

+ (void)saveOrUpdateMassagerMode:(WMMassagerMode *)mode {
    NSDictionary *dict = [self massagerModes];
    
    NSString *modeIndexString = [NSString stringWithFormat:@"%d", (int)mode.modeIndex];
    
    NSData *modeData = [NSKeyedArchiver archivedDataWithRootObject:mode];
    
    [dict setValue:modeData forKey:modeIndexString];
    
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:kMassagerModeManagerDict];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)delegateMassagerModeAtIndex:(NSInteger)index {
//    NSString *modeIndexString = [NSString stringWithFormat:@"%d", (int)index];
    
    NSMutableDictionary *dict = [self massagerModes];
    
    NSInteger count = dict.count;
    NSInteger max = count + 10;
    
    for (int i = (int)index; i <= max - 1; i++) {
        NSString *key0 = [NSString stringWithFormat:@"%d", i];
        NSString *key1 = [NSString stringWithFormat:@"%d", i + 1];
        NSData *modeData = [dict objectForKey:key1];
        WMMassagerMode *mode = [NSKeyedUnarchiver unarchiveObjectWithData:modeData];
        mode.modeIndex = i;
        modeData = [NSKeyedArchiver archivedDataWithRootObject:mode];
        [dict setObject:modeData forKey:key0];
    }
    
    NSData *modeData = [dict objectForKey:[NSString stringWithFormat:@"%d", (int)max]];
    
    if (modeData) {
        [dict removeObjectForKey:[NSString stringWithFormat:@"%d", (int)max]];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:kMassagerModeManagerDict];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (WMMassagerMode *)massagerModeForModeIndex:(NSInteger)modeIndex {
    NSString *modeIndexString = [NSString stringWithFormat:@"%d", (int)modeIndex];
    
    NSDictionary *dict = [self massagerModes];
    
    NSData *modeData = [dict objectForKey:modeIndexString];
    
    if (!modeData) {
        return nil;
    }
    
    WMMassagerMode *mode = [NSKeyedUnarchiver unarchiveObjectWithData:modeData];
    return mode;
}

+ (NSMutableDictionary *)massagerModes {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] dictionaryForKey:kMassagerModeManagerDict]];
    if (!dict) {
        dict = [NSMutableDictionary dictionary];
        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:kMassagerModeManagerDict];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return dict;
}

+ (NSMutableArray *)massagerModesArray {
    NSMutableArray *modes = [NSMutableArray array];

    NSDictionary *dict = [self massagerModes];
    NSUInteger count = dict.count;
    
    if (count > 0) {
        for (int i = 0; i < count; i++) {
//            NSString *key = [NSString stringWithFormat:@"%d", (int)(i + 11)];
            WMMassagerMode *mode = [self massagerModeForModeIndex:(i + 11)];
            
            if (mode) {
                [modes addObject:mode];
            }            
        }
    }
    
    return modes;
}

@end
