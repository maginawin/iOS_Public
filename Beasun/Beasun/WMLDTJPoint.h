//
//  WMLDTJPoint.h
//  Beasun
//
//  Created by maginawin on 15/9/9.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMLDTJPoint : UIView

- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text color:(UIColor *)color;

@property (assign, nonatomic, setter=updateSelected:) BOOL isSelected;

@end
