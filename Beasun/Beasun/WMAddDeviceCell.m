//
//  WMAddDeviceCell.m
//  Beasun
//
//  Created by maginawin on 15/9/7.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import "WMAddDeviceCell.h"

@interface WMAddDeviceCell ()
@property (weak, nonatomic) IBOutlet UIButton *addDviceButton;

@end

@implementation WMAddDeviceCell

+ (WMAddDeviceCell *)addDeviceCellForIndexPath:(NSIndexPath *)indexPath {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WMAddDeviceCell" owner:nil options:nil];
    
    WMAddDeviceCell *cell = views.firstObject;
    cell.indexPath = indexPath;
    [cell configureBase];
    
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)addClick:(id)sender {
    if ([_delegate respondsToSelector:@selector(addDeviceCell:addClickAtIndexPath:)]) {
        [_delegate addDeviceCell:self addClickAtIndexPath:_indexPath];
    }
}

#pragma mark - Private

- (void)configureBase {
    // Btn
    NSString *title = NSLocalizedString(@"device_add_device", @"");
    _addDviceButton.titleLabel.text = title;
    [_addDviceButton setTitle:title forState:UIControlStateNormal];
    _addDviceButton.layer.borderWidth = 0.5f;
    _addDviceButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _addDviceButton.layer.cornerRadius = 6.f;
    [_addDviceButton setBackgroundColor:[UIColor whiteColor]];
    
    self.backgroundColor = [UIColor clearColor];
    self.separatorInset = UIEdgeInsetsMake(0, CGRectGetWidth(self.bounds), 0, 0);
}

@end
