//
//  WMMusicCell.m
//  Beasun
//
//  Created by maginawin on 15/9/16.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import "WMMusicCell.h"

@implementation WMMusicCell

+ (WMMusicCell *)musicCell {
    NSArray *cells = [[NSBundle mainBundle] loadNibNamed:@"WMMusicCell" owner:nil options:nil];
    
    
    return cells.firstObject;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
