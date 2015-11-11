//
//  WMSearchDeviceCell.m
//  Beasun
//
//  Created by maginawin on 15/9/8.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import "WMSearchDeviceCell.h"

@interface WMSearchDeviceCell ()


@end

@implementation WMSearchDeviceCell

+ (WMSearchDeviceCell *)searchDeviceCellWithIndexPath:(NSIndexPath *)indexPath {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WMSearchDeviceCell" owner:nil options:nil];

    WMSearchDeviceCell *cell = views.firstObject;
    [cell configureBase];
    cell.indexPath = indexPath;
    
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)chooseClick:(id)sender {
//    _isChoose = !_selectedButton.isSelected;
    [_selectedButton setSelected:!_selectedButton.selected];
    
    if ([_delegate respondsToSelector:@selector(searchDeviceCell:changedChooseStateAtIndexPath:)]) {
        [_delegate searchDeviceCell:self changedChooseStateAtIndexPath:_indexPath];
    }
}

#pragma mark - Private

- (void)configureBase {
//    _isChoose = NO;
}

@end
