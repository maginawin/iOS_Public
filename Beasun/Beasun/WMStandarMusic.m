//
//  WMStandarMusic.m
//  Beasun
//
//  Created by maginawin on 15/9/18.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import "WMStandarMusic.h"

NSString *const kStandarMusicDict = @"kStandarMusicDict";

@implementation WMStandarMusic

+ (NSString *)standarMusicNameForIndex:(NSInteger)index {
    NSString *value = [NSString string];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] dictionaryForKey:kStandarMusicDict]];
    
    if (dict) {
        NSString *key = [NSString stringWithFormat:@"%d", (int)index];
        value = dict[key];
    }
    
    if (!value) {
        value =  NSLocalizedString(@"choose_a_music", @"");
    }
    
    return value;
}

+ (void)saveMusicName:(NSString *)musicName atIndex:(NSInteger)index {
    NSString *key = [NSString stringWithFormat:@"%d", (int)index];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] dictionaryForKey:kStandarMusicDict]];
    
    if (!dict) {
        dict = [NSMutableDictionary dictionary];
    }
    
    [dict setValue:musicName forKey:key];
    
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:kStandarMusicDict];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
