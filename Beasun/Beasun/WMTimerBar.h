//
//  WMTimerBar.h
//  Beasun
//
//  Created by maginawin on 15/9/9.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WMTimerBarDelegate <NSObject>

@optional

- (void)timerBarDidUpdateValue:(NSInteger)value;

@end

@interface WMTimerBar : UIView

@property (assign, nonatomic) int value;

- (void)updateValue:(NSInteger)value;

@property (weak, nonatomic) id<WMTimerBarDelegate> delegate;

@end
