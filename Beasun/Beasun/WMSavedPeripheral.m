//
//  WMSavedPeripheral.m
//  Beasun
//
//  Created by maginawin on 15/9/6.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import "WMSavedPeripheral.h"
#import "WMPeripheral.h"
#import <CoreBluetooth/CoreBluetooth.h>

NSString *const kSavedPeripheral = @"maginawin.beasun.kSavedPeripheral";

@implementation WMSavedPeripheral

+ (NSArray *)savedPeripheral {
    NSMutableArray *savedPeripherals = [NSMutableArray array];
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:kSavedPeripheral];
    
//    if (!dict) {
//        dict = [NSDictionary dictionary];
//    }
    
    for (NSString *key in dict) {
        NSString *name = dict[key];
        WMPeripheral *peripheral = [[WMPeripheral alloc] init];
        peripheral.uuidString = key;
        peripheral.name = name;
        [savedPeripherals addObject:peripheral];
    }
    
    return savedPeripherals;
}

+ (void)addPeripheral:(CBPeripheral *)peripheral {
    if (!peripheral) {
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] dictionaryForKey:kSavedPeripheral]];
    
    if (!dict) {
        dict = [NSMutableDictionary dictionary];
    }

    [dict setValue:peripheral.name forKey:peripheral.identifier.UUIDString];
    
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:kSavedPeripheral];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)alterPeripheral:(WMPeripheral *)peripheral {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] dictionaryForKey:kSavedPeripheral]];
    if (!dict) {
        dict = [NSMutableDictionary dictionary];
    }
    [dict setValue:peripheral.name forKey:peripheral.uuidString];
    
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:kSavedPeripheral];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)removePeripheral:(WMPeripheral *)peripheral {
    if (!peripheral) {
        return;
    }
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:kSavedPeripheral];
    
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    [mDict removeObjectForKey:peripheral.uuidString];
    
    [[NSUserDefaults standardUserDefaults] setObject:mDict forKey:kSavedPeripheral];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)removeAllPeripherals {
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:kSavedPeripheral];

    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    [mDict removeAllObjects];
    
    [[NSUserDefaults standardUserDefaults] setObject:mDict forKey:kSavedPeripheral];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isSavedPeripheral:(CBPeripheral *)peripheral {
    if (!peripheral) {
        return NO;
    }
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:kSavedPeripheral];
    
    if (!dict) {
        dict = [NSDictionary dictionary];
    }
    
    NSString *name = dict[peripheral.identifier.UUIDString];
    
    if (name) {
        return YES;
    }
    
    return NO;
}



//+ (NSMutableArray *)savedPeripheral {
//    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kSavedPeripheral];
//    
//    if (!data) {
//        return [NSMutableArray array];
//    }
//    
//    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//    
//    return [NSMutableArray arrayWithArray:array];
//}
//
//+ (void)addPeripheral:(WMPeripheral *)peripheral {
//    if (!peripheral) {
//        return;
//    }
//    
//    NSMutableArray *array = [self savedPeripheral];
//    
//    NSArray *indexs = [self indexsForPeripherals:array containPeripheral:peripheral];
//    
//    if (indexs.count > 0) {
//        int index = [indexs.firstObject intValue];
//        [array replaceObjectAtIndex:index withObject:peripheral];
//    } else {
//        [array addObject:peripheral];
//    }
//    
//    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
//    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kSavedPeripheral];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//+ (void)alterPeripheral:(WMPeripheral *)peripheral {
//    if (!peripheral) {
//        return;
//    }
//    
//    [self removePeripheral:peripheral];
//    
//    [self addPeripheral:peripheral];
//}
//
//+ (void)removePeripheral:(WMPeripheral *)peripheral {
//    if (!peripheral) {
//        return;
//    }
//    
//    NSMutableArray *array = [self savedPeripheral];
//    
//    NSArray *indexs = [self indexsForPeripherals:array containPeripheral:peripheral];
//    
//    for (int i = 0; i < indexs.count; i++) {
//        int index = [indexs[i] intValue];
//        [array removeObjectAtIndex:index];
//    }
//    
//    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
//    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kSavedPeripheral];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//+ (void)removeAllPeripherals {
//    NSMutableArray *array = [self savedPeripheral];
//    [array removeAllObjects];
//    
//    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
//    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kSavedPeripheral];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//+ (NSArray *)indexsForPeripherals:(NSArray *)peripherals containPeripheral:(WMPeripheral *)peripheral {
//    NSMutableArray *indexs = [NSMutableArray array];
//    
//    for (int i = 0; i < peripherals.count; i++) {
//        WMPeripheral *aPeripheral = peripherals[i];
//        if ([aPeripheral.uuidString isEqualToString:peripheral.uuidString]) {
//            NSNumber *num = [NSNumber numberWithInt:i];
//            [indexs addObject:num];
//        }
//    }
//    
//    return indexs;
//}

@end
