//
//  WMMassagerInfo.h
//  Beasun
//
//  Created by maginawin on 15/9/11.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WMMassagerInfo;

@protocol WMMassagerInfoDelegate <NSObject>

@optional

- (void)massagerInfoMinutesChanged:(WMMassagerInfo *)massagerInfo;

- (void)massagerInfoStop:(WMMassagerInfo *)massagerInfo;

@end

/** 按摩进行时的信息, / 时间 / 力度 / 模式 / 开关状态 / 从何而来 / */
@interface WMMassagerInfo : NSObject

/** 1 ~ 20, 默认 20 */
@property (assign, nonatomic) NSInteger minutes;

@property (assign, nonatomic) NSInteger leftMinutes;

@property (assign, nonatomic) NSInteger leftSeconds;

/** 1 ~ 11, 默认 1 */
@property (assign, nonatomic) NSInteger lidu;

/** 默认 0xF2 按摩 */
@property (assign, nonatomic) NSInteger mode;

/** 0x01 -> Start; 0x02 -> Pause; 0x03 -> Stop */
@property (assign, nonatomic, readonly) NSInteger state;

@property (assign, nonatomic) BOOL isOn;

/** 现在所处的模式是从哪里进去的, 主页进的统一乘以负一, 智   能模式进去的按原 Index */
@property (assign, nonatomic) NSInteger index;

- (NSData *)dataForMassagerInfo;

- (void)start;

- (void)stop;

//- (NSString *)modeStringFromMutableMode;

@property (weak, nonatomic) id<WMMassagerInfoDelegate> delegate;

@end
