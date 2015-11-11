//
//  WMDeviceRenameCell.m
//  Beasun
//
//  Created by maginawin on 15/9/7.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import "WMDeviceRenameCell.h"
#import "WMPeripheral.h"

@interface WMDeviceRenameCell ()

@property (weak, nonatomic) IBOutlet UITextField *mTextField;

@end

@implementation WMDeviceRenameCell

+ (WMDeviceRenameCell *)deviceRenameCellWithPeripheral:(WMPeripheral *)peripheral {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WMDeviceRenameCell" owner:nil options:nil];
    
    WMDeviceRenameCell *cell = views.firstObject;
    
    [cell configureBase];
    
    if (peripheral) {
        NSString *name = peripheral.name;
        
        if (name.length > 10) {
            name = [name substringToIndex:10];
        }
        
        cell.mTextField.text = name;
    }
    
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)textFieldDidEnd:(id)sender {
    if ([_delegate respondsToSelector:@selector(deviceRenameCell:didEndTextField:)]) {
        [_delegate deviceRenameCell:self didEndTextField:_mTextField];
    }
}

- (IBAction)textFieldChanged:(id)sender {
    if ([_delegate respondsToSelector:@selector(deviceRenameCell:changedTextField:)]) {
        [_delegate deviceRenameCell:self changedTextField:_mTextField];
    }
}

- (IBAction)textFieldDidEndOnExit:(id)sender {
    // 按下 DONE 时触发
}

#pragma mark - Private

- (void)configureBase {
    //
    [_mTextField becomeFirstResponder];
    _mTextField.placeholder = NSLocalizedString(@"can_not_be_empty", @"");
}

@end
