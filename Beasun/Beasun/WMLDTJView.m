//
//  WMLDTJView.m
//  Beasun
//
//  Created by maginawin on 15/9/9.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import "WMLDTJView.h"
#import "WMLDTJPoint.h"
#import "UIColor+Beasun.h"

@interface WMLDTJView ()

@property (strong, nonatomic) NSMutableArray *points;

@end

@implementation WMLDTJView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configureBase];
    }
    return self;
}

- (void)awakeFromNib {
    [self configureBase];
}

#pragma mark - Selector

- (void)minusClick {
    if (_selectedIndex > 0) {
        WMLDTJPoint *point0 = _points[_selectedIndex];
        [point0 updateSelected:NO];
        
        _selectedIndex -= 1;
        WMLDTJPoint *point1 = _points[_selectedIndex];
        [point1 updateSelected:YES];
        
        if ([_delegate respondsToSelector:@selector(ldtjViewUpdateSelectedIndex:)]) {
            [_delegate ldtjViewUpdateSelectedIndex:_selectedIndex];
        }
    }
}

- (void)plusClick {
    if (_selectedIndex < _points.count - 1) {
        WMLDTJPoint *point0 = _points[_selectedIndex];
        [point0 updateSelected:NO];
        
        _selectedIndex += 1;
        WMLDTJPoint *point1 = _points[_selectedIndex];
        [point1 updateSelected:YES];
        
        if ([_delegate respondsToSelector:@selector(ldtjViewUpdateSelectedIndex:)]) {
            [_delegate ldtjViewUpdateSelectedIndex:_selectedIndex];
        }
    }
}

- (void)updateSelectedIndex:(NSInteger)selectedIndex {
    WMLDTJPoint *point0 = _points[_selectedIndex];
    [point0 updateSelected:NO];
    _selectedIndex = selectedIndex;
    WMLDTJPoint *point = _points[selectedIndex];
    [point updateSelected:YES];
}

#pragma mark - Private

- (void)configureBase {
    //
    self.backgroundColor = [UIColor beasunTableViewBackground];
    
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    
    // 先画内框
    UIView *bgNeiView = [[UIView alloc] initWithFrame:CGRectMake(0, 12, width, height - 12)];
    bgNeiView.backgroundColor = [UIColor beasunTableViewBackground];
    bgNeiView.layer.borderWidth = 1.f;
    bgNeiView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    bgNeiView.layer.cornerRadius = 6.f;
    [self addSubview:bgNeiView];
    
    // 加 2 个按钮
    CGRect minusFrame = CGRectMake(8, (height - 20) / 2.f, 32, 32);
    CGRect plusFrame = CGRectMake(width - 40, (height - 20) / 2.f, 32, 32);
    
    UIButton *minusBtn = [[UIButton alloc] initWithFrame:minusFrame];
    [minusBtn setImage:[UIImage imageNamed:@"beasun_minus_btn"] forState:UIControlStateNormal];
    [minusBtn addTarget:self action:@selector(minusClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *plusBtn = [[UIButton alloc] initWithFrame:plusFrame];
    [plusBtn setImage:[UIImage imageNamed:@"beasun_plus_btn"] forState:UIControlStateNormal];
    [plusBtn addTarget:self action:@selector(plusClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:minusBtn];
    [self addSubview:plusBtn];
    
    // 再写中间的力度调节 Label
    NSString *ldtjText = NSLocalizedString(@"lidutiaojie", @"");
    CGSize ldtjSize = [ldtjText sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13.f]}];
    CGRect ldtjRect = CGRectMake((width - ldtjSize.width - 8) / 2.f, 0, ldtjSize.width + 8, 24.f);
    UILabel *ldtjLabel = [[UILabel alloc] initWithFrame:ldtjRect];
    ldtjLabel.text = ldtjText;
    ldtjLabel.textColor = [UIColor darkGrayColor];
    ldtjLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    ldtjLabel.layer.borderWidth = 1.f;
    ldtjLabel.layer.cornerRadius = 8.f;
    ldtjLabel.textAlignment = NSTextAlignmentCenter;
    ldtjLabel.font = [UIFont systemFontOfSize:13.f];
    ldtjLabel.backgroundColor = [UIColor beasunTableViewBackground];
    [self addSubview:ldtjLabel];
    
    // 添加点们
    // 11 个点
    
    CGFloat pointY = (height - 12) / 2.f;
    CGFloat perDiffX = (width - 112) / 10.f;
    
    _points = [NSMutableArray array];
    NSArray *colors = [UIColor beasunLDTJColors];
    
    for (int i = 0; i < 11; i++) {
        CGRect pointRect = CGRectMake(44.f + i * perDiffX, pointY, 24, 24);
        WMLDTJPoint *point = [[WMLDTJPoint alloc] initWithFrame:pointRect text:[NSString stringWithFormat:@"%d", (i + 1)] color:colors[i]];
        [_points addObject:point];
        [self addSubview:point];
    }
    
    // 默认选第 1 个
    WMLDTJPoint *point1 = _points.firstObject;
    [point1 updateSelected:YES];
    _selectedIndex = 0;
}

@end
