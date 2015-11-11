//
//  WMDeviceRenameCell.h
//  Beasun
//
//  Created by maginawin on 15/9/7.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WMPeripheral;
@class WMDeviceRenameCell;

@protocol WMDeviceRenameCellDelegate <NSObject>

@required

- (void)deviceRenameCell:(WMDeviceRenameCell *)cell didEndTextField:(UITextField *)textField;

- (void)deviceRenameCell:(WMDeviceRenameCell *)cell changedTextField:(UITextField *)textField;

@end

@interface WMDeviceRenameCell : UITableViewCell

+ (WMDeviceRenameCell *)deviceRenameCellWithPeripheral:(WMPeripheral *)peripheral;

@property (weak, nonatomic) id<WMDeviceRenameCellDelegate> delegate;

@end
