//
//  WMLDTJPoint.m
//  Beasun
//
//  Created by maginawin on 15/9/9.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import "WMLDTJPoint.h"

@interface WMLDTJPoint ()

@property (strong, nonatomic) UIView *colorView;
@property (strong, nonatomic) UILabel *textLabel;

@end

@implementation WMLDTJPoint

- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text color:(UIColor *)color {
    self = [super initWithFrame:frame];
    if (self) {
        [self configureBase];
        
        [self configureColorView:color];
        
        [self configureTextLabel:text];
    }
    return self;
}

#pragma mark - Public

- (void)updateSelected:(BOOL)isSelected {
    // 加特技
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform"];
    anim.duration = 0.2f;
    
    if (isSelected) {
        anim.fromValue = [NSValue valueWithCATransform3D:_colorView.layer.transform];
        anim.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        _colorView.layer.transform = CATransform3DIdentity;
        _textLabel.layer.transform = CATransform3DIdentity;
    } else {
        anim.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        anim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.3, 0.3, 1)];
        _colorView.layer.transform = CATransform3DMakeScale(0.3, 0.3, 1);
        _textLabel.layer.transform = CATransform3DMakeScale(0.3, 0.3, 1);
    }
    
    anim.removedOnCompletion = YES;
    
    [_colorView.layer addAnimation:anim forKey:@"colorAnimation"];
    [_textLabel.layer addAnimation:anim forKey:@"textLabelAnimation"];
    
    _isSelected = isSelected;
    _textLabel.hidden = !_isSelected;
}

#pragma mark - Private

- (void)configureBase {
    self.backgroundColor = [UIColor clearColor];
}

- (void)configureTextLabel:(NSString *)text {
    _textLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _textLabel.text = text;
    _textLabel.textColor = [UIColor whiteColor];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.font = [UIFont systemFontOfSize:13.f];
    _textLabel.hidden = YES;
    
    [self addSubview:_textLabel];   
}

- (void)configureColorView:(UIColor *)color {
    _colorView = [[UIView alloc] initWithFrame:self.bounds];
    _colorView.backgroundColor = color;
    _colorView.layer.cornerRadius = CGRectGetWidth(self.bounds) / 2.f;
    _colorView.layer.transform = CATransform3DMakeScale(0.3, 0.3, 1);
    _isSelected = NO;
    
    [self addSubview:_colorView];    
}

@end
