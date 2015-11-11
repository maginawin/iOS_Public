//
//  WMTimerBar.m
//  Beasun
//
//  Created by maginawin on 15/9/9.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import "WMTimerBar.h"

//const float kTimerBarOffset = 12.f;

const int kTimerBarMaxValue = 20;

@interface WMTimerBar ()

@property (strong, nonatomic) CAShapeLayer *mLayer;

// 滑动块
@property (strong, nonatomic) UIButton *mButton;
@property (assign, nonatomic) BOOL isTap;
@property (assign, nonatomic) CGPoint mCenter;
//@property (assign, nonatomic) CGFloat angleFrom;
//@property (assign, nonatomic) CGFloat angleTo;
//@property (assign, nonatomic) CGFloat step;
//@property (assign, nonatomic) int value;
@property (assign, nonatomic) CGFloat offset;
@property (assign, nonatomic) CGFloat radius;
@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) CGFloat height;
@property (assign, nonatomic) CGFloat stepAngle;
@property (strong, nonatomic) UILabel *valueLabel;

@end

@implementation WMTimerBar

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configureBase];
    }
    return self;
}

- (void)awakeFromNib {
    
    [self configureBase];
}

#pragma mark - Private


- (void)configureBase {
    self.backgroundColor = [UIColor clearColor];
    
    _width = CGRectGetWidth(self.bounds);
    _height = CGRectGetHeight(self.bounds);
    _mCenter = CGPointMake(_width / 2.f, _height / 2.f);
    
    // 添加图片
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jingdian_bar_bg"]];
    imageView.frame = self.bounds;
    imageView.contentMode = UIViewContentModeScaleToFill;
    
    [self addSubview:imageView];
    
    // 添加图片的 Mask
    CGFloat maskWidth = _width / 10.f;
    _offset = maskWidth / 2.f;
    _radius = (_width - maskWidth) / 2.f;
    _stepAngle = (M_PI + M_PI_2) / kTimerBarMaxValue;
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    
    UIBezierPath *maskPath = [[UIBezierPath alloc] init];
    CGPoint maskPathCenter = CGPointMake(_width / 2.f, _height / 2.f);
    CGFloat corner60 = M_PI_2 / 2.f;
    [maskPath addArcWithCenter:maskPathCenter radius:_radius startAngle:- (corner60 + M_PI) endAngle:corner60 clockwise:YES];
    
    maskLayer.path = maskPath.CGPath;
    maskLayer.strokeColor = [UIColor whiteColor].CGColor;
    maskLayer.fillColor = [UIColor clearColor].CGColor;
    maskLayer.lineWidth = maskWidth;
    maskLayer.lineCap = kCALineCapRound;
    maskLayer.strokeStart = 0.f;
    maskLayer.strokeEnd = 1.f;
    
    imageView.layer.mask = maskLayer;
    
    // 添加白色 mLayer
    _mLayer = [CAShapeLayer layer];
    _mLayer.path = maskPath.CGPath;
    _mLayer.lineWidth = maskLayer.lineWidth - 4;
    _mLayer.lineCap = kCALineCapRound;
    _mLayer.strokeStart = 0.f;
    _mLayer.strokeEnd = 1.f;
    _mLayer.fillColor = [UIColor clearColor].CGColor;
    _mLayer.strokeColor = [UIColor whiteColor].CGColor;
    _mLayer.opacity = 0.5f;
    
    [self.layer addSublayer:_mLayer];
    
    // 添加 valueLabel
    _valueLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _valueLabel.backgroundColor = [UIColor clearColor];
    _valueLabel.text = [NSString stringWithFormat:@"%d", _value];
    _valueLabel.font = [UIFont systemFontOfSize:62.f];
    _valueLabel.textColor = [UIColor whiteColor];
    _valueLabel.textAlignment = NSTextAlignmentCenter;
    _valueLabel.hidden = YES;
    
    [self addSubview:_valueLabel];
    
    // 添加 Button
    _mButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40.f, 40.f)];
//    _mButton.backgroundColor = [UIColor clearColor];
//    [_mButton setImage:[UIImage imageNamed:@"time_bar_button"] forState:UIControlStateNormal];
    [_mButton setBackgroundImage:[UIImage imageNamed:@"time_bar_button"] forState:UIControlStateNormal];
    [_mButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _mButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [_mButton addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchDragInside];
    [self addSubview:_mButton];
    
    // 添加手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self addGestureRecognizer:pan];
    
    [self updateValue:kTimerBarMaxValue];
}

#pragma mark - Selector

- (void)buttonPressed {
    _isTap = YES;
    _valueLabel.hidden = NO;
}

- (void)handlePan:(UIPanGestureRecognizer *)pan {
    if (!_isTap) {
        return;
    }
    
    CGPoint point = [pan locationInView:self];
    
    switch (pan.state) {
        case UIGestureRecognizerStateChanged: {
            float x = point.x - _mCenter.x;
            float y = -point.y + _mCenter.y;
            float hypot = hypotf(x, y);
            
            float angle;

            if (x / hypot > 0) {
                angle = -asinf(y / hypot) + M_PI + M_PI_4;
            } else if (x / hypot < 0) {
                angle = asinf(y / hypot) + M_PI_4;
            } else {
                angle = M_PI_4 + M_PI_2;
            }
            
            _value = (int)[self valueFromAngle:angle];
            
            if ([_delegate respondsToSelector:@selector(timerBarDidUpdateValue:)]) {
                [_delegate timerBarDidUpdateValue:_value];
            }
            
            // 若是角度超过了, 则后面不要处理了
            if (angle < 0|| angle > M_PI_2 + M_PI) {
                return;
            }
            
//            if (angle < 0) {
//                angle = 0;
//            } else if (angle > M_PI_2 + M_PI) {
//                angle = M_PI_2 + M_PI;
//            }
            
            // 改变按钮上的字
            NSString *timeStr = [NSString stringWithFormat:@"%d", _value];
            _mButton.titleLabel.text = timeStr;
            [_mButton setTitle:timeStr forState:UIControlStateNormal];
            
            _valueLabel.text = timeStr;
            
            // 移动 Button
            CGFloat mX = 0;
            CGFloat mY = 0;
            
            if (x < 0) {
                // 左下
                if (y < 0) {
                    mX = _radius - fabs(_radius * x / hypot) + _offset;
                    mY = _offset + _radius + fabs(_radius * y / hypot);
                }
                // 左上
                else {
                    mX = _radius - fabs(_radius * x / hypot) + _offset;
                    mY = _radius + _offset - fabs(_radius * y / hypot);
                }
            } else if (x > 0) {
                // 右下
                if (y < 0) {
                    mX = _radius + _offset + fabs(_radius * x / hypot);
                    mY = _offset + _radius + fabs(_radius * y / hypot);
                }
                // 右上
                else {
                    mX = _radius + _offset + fabs(_radius * x / hypot);
                    mY = _radius + _offset - fabs(_radius * y / hypot);
                }
            } else if (x == 0) {
                mX = _offset + _radius;
                mY = _offset;
            }
            
            CGPoint mCenter = CGPointMake(mX, mY);
            _mButton.center = mCenter;
            _mLayer.strokeEnd = (float)(angle / (M_PI_2 + M_PI));
            
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            _isTap = NO;
            _valueLabel.hidden = YES;
            break;
        }
        default:
            break;
    }
}

#pragma mark - Private

- (NSInteger)valueFromAngle:(CGFloat)angle {
    if (angle < 0) {
        angle = 0;
    }
    
    if (angle > M_PI_2 + M_PI) {
        angle = M_PI_2 + M_PI;
    }

    int value = 1;
    
    if (angle > 0) {
        value = ceil(angle / _stepAngle);
    }
    
    if (value > kTimerBarMaxValue) {
        value = kTimerBarMaxValue;
    }
    
    return value;
}

#pragma mark - Public

- (void)updateValue:(NSInteger)value {
    
    __block NSInteger aValue = value;
    dispatch_async(dispatch_get_main_queue(), ^ {
        if (aValue < 0) {
            aValue = 0;
        } else if (aValue > kTimerBarMaxValue) {
            aValue = kTimerBarMaxValue;
        }
        
        CGFloat angle = value * _stepAngle - 0.01f * _stepAngle;
        _mLayer.strokeEnd = (float)((value * _stepAngle) / (M_PI_2 + M_PI));
        
//        angle -= 0.5f * _stepAngle;
        
        CGFloat mX = 0;
        CGFloat mY = 0;
        CGFloat cos = 0;
        CGFloat sin = 0;
//        CGFloat stepAngle = 270 / (float)kTimerBarMaxValue;
//        CGFloat angle = stepAngle * value ;
        
        if (angle <= M_PI_4) {
            angle = M_PI_4 - angle;
            cos = cosl(angle);
            sin = sinl(angle);
            
            mX = _radius - cos * _radius + _offset;
            mY = _radius + sin * _radius + _offset;
        } else if (angle <= M_PI_4 + M_PI_2) {
            angle = angle - M_PI_4;
            cos = cosf(angle);
            sin = sinf(angle);
            
            mX = _radius - cos * _radius + _offset;
            mY = _radius - sin * _radius + _offset;
        } else if (angle <= M_PI + M_PI_4) {
            angle = M_PI + M_PI_4 - angle ;
            cos = cosf(angle);
            sin = sinf(angle);
            
            mX = _radius + cos * _radius + _offset;
            mY = _radius - sin * _radius + _offset;
        } else if (angle <= M_PI + M_PI_2) {
            angle = angle - M_PI - M_PI_4;
            cos = cosf(angle);
            sin = sinf(angle);
            
            mX = _radius + cos * _radius + _offset;
            mY = _radius + sin * _radius + _offset;
        }
        
        _mButton.center = CGPointMake(mX, mY);
        NSString *valueStr = [NSString stringWithFormat:@"%d", (int)value];
        _mButton.titleLabel.text = valueStr;
        [_mButton setTitle:valueStr forState:UIControlStateNormal];
        _value = (int)value;
        
//        if ([_delegate respondsToSelector:@selector(timerBarDidUpdateValue:)]) {
//            [_delegate timerBarDidUpdateValue:_value];
//        }

    });
}

@end
