//
//  WMMassagerInfo.m
//  Beasun
//
//  Created by maginawin on 15/9/11.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import "WMMassagerInfo.h"
#import "AppDelegate.h"
#import "WMBLEManager.h"
#import "WMBLEHelper.h"

const float kMassagerInfoMinute = 60;
const float kMassagerInfoSecond = 1;

@interface WMMassagerInfo ()

@property (strong, nonatomic) NSDate *bgDate;
@property (strong, nonatomic) NSTimer *mTimer;

@end

@implementation WMMassagerInfo

- (instancetype)init {
    self = [super init];
    if (self) {
        // 初始化一些值
        _minutes = 20;
        _lidu = 1;
        _mode = 0xFB;
        _state = 0x03; // 0x03 停止
        _index = -100; // 无定向
        _isOn = NO;

        
        //        _mTimer = [NSTimer timerWithTimeInterval:60 target:self selector:@selector(handleTimerMassagerInfo:) userInfo:nil repeats:YES];
//        _mTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(handleTimerMassagerInfo:) userInfo:nil repeats:YES];
    }
    return self;
}

//- (void)setIsOn:(BOOL)isOn {
//    if (isOn) {
//        _state = 0x01;
//        
//        [self start];
//        
//        //        _startDate = [NSDate date];
//        
//    } else {
//        _state = 0x03;
//        
//        [self stop];
//    }
//    _isOn = isOn;
//}

#pragma mark - Selector

- (void)handleTimerMassagerInfo:(NSTimer *)sender {
    if (!_isOn) {
        [self stop];
        return;
    }
    
    _leftSeconds -= 1;
    _leftMinutes = ceil(_leftSeconds / 60.f);
    
    if (_leftSeconds <= 0) {
        [self stop];
    } else {
        
        if ([_delegate respondsToSelector:@selector(massagerInfoMinutesChanged:)]) {
            [_delegate massagerInfoMinutesChanged:self];
        }
    }
        
    NSLog(@"left seconds %d", (int)_leftSeconds);
}

- (void)applicationDidEnterBackgroundNotification {
    _bgDate = [NSDate date];
}

- (void)applicationDidBecomeActiveNotification {
    
    NSDate *activeDate = [NSDate date];
    
    NSTimeInterval diff = [activeDate timeIntervalSinceDate:_bgDate];
    
//    int diffMinute = diff / 60.f;
    
    _leftSeconds -= diff;
    _leftMinutes -= ceil(_leftSeconds / 60.f);
    
    if (_leftSeconds <= 0) {
        
        [self stop];
    } else {
        if ([_delegate respondsToSelector:@selector(massagerInfoMinutesChanged:)]) {
            [_delegate massagerInfoMinutesChanged:self];
        }
        
    }
}

#pragma mark - Public

- (void)start {
    //    if (!_isOn) {
    _isOn = YES;
    _state = 0x01;
    
    _leftMinutes = _minutes;
    _leftSeconds = _leftMinutes * 60;
    
    if ([_delegate respondsToSelector:@selector(massagerInfoMinutesChanged:)]) {
        [_delegate massagerInfoMinutesChanged:self];
    }
    
    if (_mTimer.isValid) {
        [_mTimer invalidate];
    }
    
    _mTimer = nil;
    _mTimer = [NSTimer scheduledTimerWithTimeInterval:kMassagerInfoSecond target:self selector:@selector(handleTimerMassagerInfo:) userInfo:nil repeats:YES];
    
    _bgDate = [NSDate date];
    //    }
    
}

- (void)stop {
    _isOn = NO;
    _state = 0x03;
    _leftMinutes = _minutes;
    _leftSeconds = _leftMinutes * 60;
    
    if ([_delegate respondsToSelector:@selector(massagerInfoStop:)]) {
        [_delegate massagerInfoStop:self];
    }
    
    [[WMBLEManager sharedInstance] writeValue:[WMBLEHelper dataforState:self] withResponse:YES];
    
    if (_mTimer) {
        [_mTimer invalidate];
    }
    
    _mTimer = nil;
}

- (NSData *)dataForMassagerInfo {
    NSMutableData *data = [NSMutableData data];
    
    
    return data;
}

#pragma mark - Private

- (void)configureNoti {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackgroundNotification) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActiveNotification) name:UIApplicationDidBecomeActiveNotification object:nil];
}

@end
