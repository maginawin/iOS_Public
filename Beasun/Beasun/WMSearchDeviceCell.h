//
//  WMSearchDeviceCell.h
//  Beasun
//
//  Created by maginawin on 15/9/8.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WMSearchDeviceCell;

@protocol WMSearchDeviceCellDelegate <NSObject>

@required

- (void)searchDeviceCell:(WMSearchDeviceCell *)cell changedChooseStateAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface WMSearchDeviceCell : UITableViewCell

+ (WMSearchDeviceCell *)searchDeviceCellWithIndexPath:(NSIndexPath *)indexPath;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *uuidStringLabel;

@property (strong, nonatomic) NSIndexPath *indexPath;

//@property (assign, nonatomic) BOOL isChoose;

@property (weak, nonatomic) IBOutlet UIButton *selectedButton;

@property (weak, nonatomic) id<WMSearchDeviceCellDelegate> delegate;

@end
