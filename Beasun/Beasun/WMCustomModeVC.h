//
//  WMCustomModeVC.h
//  Beasun
//
//  Created by maginawin on 15/9/17.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WMMassagerMode;

@protocol WMCustomModeVCDelegate <NSObject>

@optional

- (void)customModeVCDidModeChanged;

@end

@interface WMCustomModeVC : UIViewController

@property (strong, nonatomic) WMMassagerMode *mode;

@property (weak, nonatomic) id<WMCustomModeVCDelegate> delegate;

@end
