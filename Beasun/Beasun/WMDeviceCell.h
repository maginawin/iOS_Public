//
//  WMDeviceCell.h
//  Beasun
//
//  Created by maginawin on 15/9/6.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+BatteryLevel.h"
@class WMDeviceCell;
@class WMPeripheral;

@protocol WMDeviceCellDelegate <NSObject>

@required

- (void)deviceCell:(WMDeviceCell *)cell closeClickAtIndexPath:(NSIndexPath *)indexPath;

- (void)deviceCell:(WMDeviceCell *)cell deleteClickAtIndexPath:(NSIndexPath *)indexPath;

- (void)deviceCell:(WMDeviceCell *)cell detailClickAtIndexPath:(NSIndexPath *)indexPath;

- (void)deviceCell:(WMDeviceCell *)cell connectClickAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface WMDeviceCell : UITableViewCell

@property (strong, nonatomic) NSIndexPath *indexPath;

+ (WMDeviceCell *)deviceCellWithIndexPath:(NSIndexPath *)indexPath;

@property (strong, nonatomic) WMPeripheral *peripheral;

@property (weak, nonatomic) id<WMDeviceCellDelegate> delegate;

@property (strong, nonatomic) UIImageView *batteryImageView; // 电量
@property (strong, nonatomic) UIButton *connectButotn; // 用来重连

- (void)showMenuButton:(BOOL)enable;

@end
