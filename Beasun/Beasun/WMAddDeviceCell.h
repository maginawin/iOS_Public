//
//  WMAddDeviceCell.h
//  Beasun
//
//  Created by maginawin on 15/9/7.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WMAddDeviceCell;

@protocol WMAddDeviceCellDelegate <NSObject>

@required

- (void)addDeviceCell:(WMAddDeviceCell *)cell addClickAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface WMAddDeviceCell : UITableViewCell

+ (WMAddDeviceCell *)addDeviceCellForIndexPath:(NSIndexPath *)indexPath;

@property (strong, nonatomic) NSIndexPath *indexPath;

@property (weak, nonatomic) id<WMAddDeviceCellDelegate> delegate;

@end
