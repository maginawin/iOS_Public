//
//  WMBLEHelper.h
//  Beasun
//
//  Created by maginawin on 15/9/10.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WMMassagerInfo;

typedef NS_ENUM(NSInteger, BLEHelperMassagerMode) {
    BLEHelperMassagerModeAnMo = 0xF2,
    BLEHelperMassagerModeRouNie = 0xF3,
    BLEHelperMassagerModeTuiNa = 0xF4,
    BLEHelperMassagerModeChuiJi = 0xF5,
    BLEHelperMassagerModeGuaSha = 0xF6,
    BLEHelperMassagerModeZhenJiu = 0xF7,
    BLEHelperMassagerModeZhiYa = 0xF8,
    BLEHelperMassagerModeHuoGuan = 0xF9,
    BLEHelperMassagerModeShouShen = 0xFA,
    BLEHelperMassagerModeQinFu = 0xFB,
    BLEHelperMassagerModeJinZhui = 0xFC
};

@interface WMBLEHelper : NSObject

+ (NSData *)dataForMode:(WMMassagerInfo *)info mutable:(BOOL)mutable;

+ (NSData *)dataForLidu:(WMMassagerInfo *)info;

+ (NSData *)dataforState:(WMMassagerInfo *)info;

+ (NSData *)dataForCloseMassager;

+ (NSArray *)bleHelperModes;


@end
