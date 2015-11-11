//
//  WMBeasunZhinengCVCell.m
//  Beasun
//
//  Created by maginawin on 15/8/31.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import "WMBeasunZhinengCVCell.h"

@interface WMBeasunZhinengCVCell () <UIGestureRecognizerDelegate>

@end

@implementation WMBeasunZhinengCVCell

+ (WMBeasunZhinengCVCell *)beasunZhinengCVCell {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WMBeasunZhinengCVCell" owner:nil options:nil];
    
    WMBeasunZhinengCVCell *cell = views.firstObject;
    [cell configureLongPressGesture];
    
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor lightGrayColor];
    
    self.layer.cornerRadius = 4.f;
    self.layer.masksToBounds = YES;
    
    _textLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5f];
}

- (void)longPressClick:(UILongPressGestureRecognizer *)sender {
    // Long press gesture has two state, began and ended
    if (sender.state == UIGestureRecognizerStateBegan) {
        if ([_delegate respondsToSelector:@selector(beasunZhinengVCCell:didLongPressAtIndex:)]) {
            
            [_delegate beasunZhinengVCCell:self didLongPressAtIndex:_indexPath];
        }
    }
}

- (void)configureLongPressGesture {
    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressClick:)];
    gesture.minimumPressDuration = 1.f;
    gesture.delegate = self;
    gesture.view.tag = _indexPath.row;
    [self addGestureRecognizer:gesture];
}

@end
