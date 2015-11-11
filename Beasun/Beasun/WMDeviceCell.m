//
//  WMDeviceCell.m
//  Beasun
//
//  Created by maginawin on 15/9/6.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import "WMDeviceCell.h"
#import "WMPeripheral.h"
#import "UIColor+Beasun.h"

const float kDeviceCellButtonWidth = 64.f;

@interface WMDeviceCell () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (assign, nonatomic) BOOL isMenuShow;

@property (strong, nonatomic) UIButton *closeButton; // 用来关闭连接
@property (strong, nonatomic) UIButton *deleteButton; // 用来删除
@property (strong, nonatomic) UIButton *detailButton; // 用来改名

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *uuidLabel;

@property (strong, nonatomic) UIView *mView;

@end

@implementation WMDeviceCell

+ (WMDeviceCell *)deviceCellWithIndexPath:(NSIndexPath *)indexPath {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WMDeviceCell" owner:nil options:nil];
    
    WMDeviceCell *cell = views.firstObject;
    
    cell.indexPath = indexPath;
    
    [cell configureBase];
    
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
//    [self configureBase];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat xDiff = scrollView.contentOffset.x;
    if (xDiff > 20.f) {
        [self showMenuButton:YES];
    } else {
        [self showMenuButton:NO];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        CGFloat xDiff = scrollView.contentOffset.x;
        if (xDiff > 20.f && !_isMenuShow) {
            [self showMenuButton:YES];
        } else {
            [self showMenuButton:NO];
        }
    } 
}

#pragma mark - Selector

- (void)closeClick:(id)sender {
    if ([_delegate respondsToSelector:@selector(deviceCell:closeClickAtIndexPath:)]) {
        [_delegate deviceCell:self closeClickAtIndexPath:_indexPath];
    }
    
    [self showMenuButton:NO];
}

- (void)deleteClick:(id)sender {
    if ([_delegate respondsToSelector:@selector(deviceCell:deleteClickAtIndexPath:)]) {
        [_delegate deviceCell:self deleteClickAtIndexPath:_indexPath];
    }
    
//    [self showMenuButton:NO];
}

- (void)detailClick:(id)sender {
    if ([_delegate respondsToSelector:@selector(deviceCell:detailClickAtIndexPath:)]) {
        [_delegate deviceCell:self detailClickAtIndexPath:_indexPath];
    }
    
    [self showMenuButton:NO];
}

- (void)tagClick:(UITapGestureRecognizer *)gesture {
    [self showMenuButton:NO];
}

#pragma mark - Private

- (void)configureBase {
    // self
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _mScrollView.delegate = self;
    _isMenuShow = NO;
    
    CGFloat height = CGRectGetHeight(self.bounds);
    CGFloat width = CGRectGetWidth(self.bounds);
    
    // 添加 View
    _mView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    _mView.backgroundColor = [UIColor whiteColor];
    [_mScrollView addSubview:_mView];
    
    // 添加 Label
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 8, 200, 20)];
    _nameLabel.font = [UIFont systemFontOfSize:16.f];
    _nameLabel.textColor = [UIColor darkTextColor];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
//    _nameLabel.backgroundColor = [UIColor blueColor];
    [_mView addSubview:_nameLabel];
    
    _uuidLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 28, 240, 20)];
    _uuidLabel.font = [UIFont systemFontOfSize:11.f];
    _uuidLabel.textColor = [UIColor lightGrayColor];
//    _uuidLabel.backgroundColor =[UIColor redColor];
    _uuidLabel.textAlignment = NSTextAlignmentLeft;
    [_mView addSubview:_uuidLabel];
    
    // 添加 Detail Button
    _detailButton = [[UIButton alloc] initWithFrame:_nameLabel.bounds];
    [_detailButton addTarget:self action:@selector(detailClick:) forControlEvents:UIControlEventTouchUpInside];
    _detailButton.titleLabel.text = @"";
    [_mView addSubview:_detailButton];
    
    // 添加电池图片
    _batteryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(width - 45.f, 13.f, 30.f, 30.f)];
    _batteryImageView.contentMode = UIViewContentModeScaleAspectFill;
    _batteryImageView.image = nil;
    [_mView addSubview:_batteryImageView];
    
    // 添加重连 Butotn
    _connectButotn = [[UIButton alloc] initWithFrame:CGRectMake(width - 64.f, 0, 64.f, 56)];
    _connectButotn.titleLabel.text = NSLocalizedString(@"device_connect", @"");
    _connectButotn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [_connectButotn setTitle:NSLocalizedString(@"device_connect", @"") forState:UIControlStateNormal];
//    [_connectButotn setBackgroundColor:[UIColor yellowColor]];
    [_connectButotn setTitleColor:[UIColor beasunNavSwitchSelectedColor] forState:UIControlStateNormal];
    [_connectButotn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [_connectButotn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
    [_mView addSubview:_connectButotn];
    
    // 添加两个 Button
    _closeButton = [[UIButton alloc] initWithFrame:CGRectMake(width, 0, kDeviceCellButtonWidth, height)];
    [_closeButton setBackgroundColor:[UIColor lightGrayColor]];
    _closeButton.titleLabel.text = NSLocalizedString(@"device_cell_close", @"");
    [_closeButton setTitle:NSLocalizedString(@"device_cell_close", @"") forState:UIControlStateNormal];
    [_closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _closeButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [_closeButton addTarget:self action:@selector(closeClick:) forControlEvents:UIControlEventTouchUpInside];
    [_mScrollView addSubview:_closeButton];
    
    _deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(width + kDeviceCellButtonWidth, 0, kDeviceCellButtonWidth, height)];
    [_deleteButton setBackgroundColor:[UIColor redColor]];
    _deleteButton.titleLabel.text = NSLocalizedString(@"device_cell_delete", @"");
    [_deleteButton setTitle:NSLocalizedString(@"device_cell_delete", @"") forState:UIControlStateNormal];
    [_deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _deleteButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [_deleteButton addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
    [_mScrollView addSubview:_deleteButton];
    
    // 给 View 添加手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagClick:)];
    [_mView addGestureRecognizer:tapGesture];
    
    // ScrollView
    _mScrollView.contentSize = CGSizeMake(width + kDeviceCellButtonWidth * 2, height);
}

- (void)showMenuButton:(BOOL)enable {
    if (enable) {
        
        [UIView animateWithDuration:.2f animations:^ {
            _mScrollView.contentOffset = CGPointMake(kDeviceCellButtonWidth * 2, 0);
        } completion:^(BOOL finished) {
            if (finished) { _isMenuShow = YES;}
        }];
    } else {
        
        [UIView animateWithDuration:.2f animations:^ {
            _mScrollView.contentOffset = CGPointMake(0, 0);
        } completion:^(BOOL finished) {
            if (finished) { _isMenuShow = NO;}
        }];
    }
}

- (void)setPeripheral:(WMPeripheral *)peripheral {
    if (!peripheral) {
        _nameLabel.text = @"";
        _uuidLabel.text = @"";
    } else {
//        NSInteger nameCount = peripheral.name.length;
        NSString *name = peripheral.name;
        
        if (name.length > 10) {
            name = [name substringToIndex:10];
        }
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", name, @"✎"]];
        [attributedString addAttribute:NSForegroundColorAttributeName value:(id)[UIColor darkTextColor] range:NSMakeRange(0, name.length)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:(id)[UIColor blueColor] range:NSMakeRange(name.length, 2)];
        _nameLabel.attributedText = attributedString;
        _uuidLabel.text = peripheral.uuidString;
    }
}

@end
