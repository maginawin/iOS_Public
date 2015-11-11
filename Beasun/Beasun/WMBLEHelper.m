//
//  WMBLEHelper.m
//  Beasun
//
//  Created by maginawin on 15/9/10.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import "WMBLEHelper.h"
#import "WMMassagerInfo.h"

@implementation WMBLEHelper

+ (NSData *)dataForMode:(WMMassagerInfo *)info {
    NSMutableData *data = [NSMutableData data];
    
    int tag = 0xF2;
    int mode = (int)info.mode;
    
    [data appendBytes:&tag length:1];
    [data appendBytes:&mode length:1];
    
    return data;
}

+ (NSData *)dataForMode:(WMMassagerInfo *)info mutable:(BOOL)mutable {
    NSMutableData *data = [NSMutableData data];
    
    int tag = mutable ? 0xF1 : 0xF2;
    int modeLength = mutable ? 2 : 1;
    int mode = (int)info.mode;
    
    [data appendBytes:&tag length:1];
    [data appendBytes:&mode length:modeLength];
    
    return data;
}

+ (NSData *)dataForLidu:(WMMassagerInfo *)info {
    NSMutableData *data = [NSMutableData data];
    
    int tag = 0xFB;
    int qiangdu = (int)info.lidu;
    
    [data appendBytes:&tag length:1];
    [data appendBytes:&qiangdu length:1];
    
    return data;
}

+ (NSData *)dataforState:(WMMassagerInfo *)info {
    NSMutableData *data = [NSMutableData data];
    
    int tag = 0xFC;
    int state = (int)info.state;
    
    [data appendBytes:&tag length:1];
    [data appendBytes:&state length:1];
    
    return data;
}

+ (NSData *)dataForCloseMassager {
    int tag = 0xFD;
    NSData *data = [NSData dataWithBytes:&tag length:1];
    return data;
}


+ (NSArray *)bleHelperModes {
    NSMutableArray *modes = [NSMutableArray array];

    [modes addObject:[NSNumber numberWithInteger:BLEHelperMassagerModeTuiNa]];
    [modes addObject:[NSNumber numberWithInteger:BLEHelperMassagerModeGuaSha]];
    [modes addObject:[NSNumber numberWithInteger:BLEHelperMassagerModeShouShen]];
    [modes addObject:[NSNumber numberWithInteger:BLEHelperMassagerModeQinFu]];
    [modes addObject:[NSNumber numberWithInteger:BLEHelperMassagerModeZhenJiu]];
    [modes addObject:[NSNumber numberWithInteger:BLEHelperMassagerModeChuiJi]];
    [modes addObject:[NSNumber numberWithInteger:BLEHelperMassagerModeZhiYa]];
    [modes addObject:[NSNumber numberWithInteger:BLEHelperMassagerModeJinZhui]];
    [modes addObject:[NSNumber numberWithInteger:BLEHelperMassagerModeHuoGuan]];
    [modes addObject:[NSNumber numberWithInteger:BLEHelperMassagerModeAnMo]];
    
    return modes;
}

@end
