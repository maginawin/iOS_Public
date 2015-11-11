//
//  WMBeasunZhinengCVCell.h
//  Beasun
//
//  Created by maginawin on 15/8/31.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMBLEHelper.h"
@class WMBeasunZhinengCVCell;

@protocol WMBeasunZhinengVCCellDelegate <NSObject>

@optional

- (void)beasunZhinengVCCell:(WMBeasunZhinengCVCell *)cell didLongPressAtIndex:(NSIndexPath *)indexPath;

@end

@interface WMBeasunZhinengCVCell : UICollectionViewCell

+ (WMBeasunZhinengCVCell *)beasunZhinengCVCell;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (assign, nonatomic) BLEHelperMassagerMode mode;
@property (strong, nonatomic) NSIndexPath *indexPath;

- (void)configureLongPressGesture;

@property (weak, nonatomic) id<WMBeasunZhinengVCCellDelegate> delegate;

@end
