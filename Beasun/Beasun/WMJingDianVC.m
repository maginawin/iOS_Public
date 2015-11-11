//
//  WMJingDianVC.m
//  Beasun
//
//  Created by maginawin on 15/9/9.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import "WMJingDianVC.h"
#import "WMJDModeButton.h"
#import "WMTimerBar.h"
#import "UIColor+Beasun.h"
#import "WMBLEManager.h"
#import "WMMusicChooseVC.h"
#import "WMLDTJView.h"
#import "WMMusicManager.h"
#import "WMMassagerModeManager.h"
#import "WMStandarMusic.h"

@interface WMJingDianVC () <WMTimerBarDelegate, WMLDTJViewDelegate, WMMassagerInfoDelegate, WMMusicChooseVCDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (weak, nonatomic) IBOutlet UIButton *chooseMusicButton;
@property (weak, nonatomic) IBOutlet WMTimerBar *timerBar;
@property (weak, nonatomic) IBOutlet WMLDTJView *liduBar;

//@property (assign, nonatomic) BLEHelperMassagerMode mode;
@property (assign, nonatomic) NSInteger selectedModeIndex;

@property (strong, nonatomic) NSMutableArray *modeButtons;

@property (strong, nonatomic) WMMassagerInfo *massagerInfo;

@property (strong, nonatomic) UISwitch *rightSwitch;

//@property (strong, nonatomic) NSTimer *mTimer;

@property (weak, nonatomic) IBOutlet UIButton *musicBtn;

@end

@implementation WMJingDianVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureBase];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (_musicBtn.selected) {
        if (![[WMMusicManager sharedInstance].audioPlayer isPlaying]) {
            [[WMMusicManager sharedInstance] playMusicNamed:_musicName];
        }
    }
    
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (!_massagerInfo.isOn) {
        [[WMMusicManager sharedInstance] stopMusic];
    }
}

- (IBAction)musicClick:(id)sender {
    if (![sender isSelected]) {
        if ([[WMMusicManager sharedInstance] playMusicNamed:_musicName]) {
            [sender setSelected:YES];
        }
    } else {
        if ([[WMMusicManager sharedInstance].audioPlayer isPlaying]) {
            [[WMMusicManager sharedInstance] stopMusic];
        }
        [sender setSelected:NO];
    }
}

#pragma mark - WMMusicChooseVCDelegate

- (void)musicChooseVCChooseMusicName:(NSString *)musicName {
    _musicName = musicName;
    _chooseMusicButton.titleLabel.text = _musicName;
    [_chooseMusicButton setTitle:_musicName forState:UIControlStateNormal];

        // Save as standar mode
        [WMStandarMusic saveMusicName:_musicName atIndex:_index];

}

#pragma mark - Selector

- (IBAction)chooseMusicClick:(id)sender {
    WMMusicChooseVC *musicChooseVC = [[WMMusicChooseVC alloc] initWithNibName:@"WMMusicChooseVC" bundle:nil];
    musicChooseVC.delegate = self;
    
    [self.navigationController pushViewController:musicChooseVC animated:YES];
}

- (void)updateModeClick:(WMJDModeButton *)sender {
    if (!sender.isSelected) {        
        WMJDModeButton *oldBtn = [_modeButtons objectAtIndex:_selectedModeIndex];
        [oldBtn setSelected:NO];
        
        [sender setSelected:YES];
        
        _selectedModeIndex = [_modeButtons indexOfObject:sender];
        _massagerInfo.mode = sender.mode;
    }
    
    if (_massagerInfo.index == [WMBLEManager sharedInstance].massagerInfo.index) {
        [[WMBLEManager sharedInstance] writeValue:[WMBLEHelper dataForMode:_massagerInfo mutable:NO] withResponse:YES];
    }
}

- (void)rightSwitchValueChanged:(UISwitch *)sender {
    if ([sender isOn]) {
        // 未连接设备就别开始了
        if ([WMBLEManager sharedInstance].connectedPeripherals.count <= 0) {
            [self showAlertMessage:NSLocalizedString(@"connect_at_least_one_device", @"")];
            
            [sender setOn:NO];
            
            return;
        }
        
        NSInteger tempMode = _massagerInfo.mode;
        _massagerInfo = [WMBLEManager sharedInstance].massagerInfo;
        _massagerInfo.delegate = self;
        _massagerInfo.index = 0;
        _massagerInfo.minutes = _timerBar.value;
        _massagerInfo.lidu = _liduBar.selectedIndex + 1;
        _massagerInfo.mode = tempMode;
        
//        [_massagerInfo setIsOn:YES];
        [_massagerInfo start];
        [[WMMusicManager sharedInstance] playMusicNamed:_musicName];
        
        if ([WMMusicManager sharedInstance].audioPlayer.isPlaying) {
            [_musicBtn setSelected:YES];
        }
        
        if (_massagerInfo.index == [WMBLEManager sharedInstance].massagerInfo.index) {
            [[WMBLEManager sharedInstance] writeValue:[WMBLEHelper dataForMode:_massagerInfo mutable:NO] withResponse:YES];
            [[WMBLEManager sharedInstance] writeValue:[WMBLEHelper dataForLidu:_massagerInfo] withResponse:YES];
            [[WMBLEManager sharedInstance] writeValue:[WMBLEHelper dataforState:_massagerInfo] withResponse:YES];
        }
    } else {
//        [_massagerInfo setIsOn:NO];
        [_massagerInfo stop];
        [[WMMusicManager sharedInstance] stopMusic];
        [_musicBtn setSelected:NO];
    }
    
//    if (_massagerInfo.index != [WMBLEManager sharedInstance].massagerInfo.index) {
//        return;
//    }
//    
//    [[WMBLEManager sharedInstance] writeValue:[WMBLEHelper dataforState:_massagerInfo] withResponse:YES];
}


//- (void)handleTimer:(NSTimer *)sender {
//    
//}

- (void)ldtjViewUpdateSelectedIndex:(NSInteger)selectedIndex {
    _massagerInfo.lidu = selectedIndex + 1;
    
    if (_massagerInfo.index != [WMBLEManager sharedInstance].massagerInfo.index) {
        return;
    }
    
    [[WMBLEManager sharedInstance] writeValue:[WMBLEHelper dataForLidu:_massagerInfo] withResponse:YES];
}

- (void)timerBarDidUpdateValue:(NSInteger)value {
    _massagerInfo.minutes = value;
    _massagerInfo.leftSeconds = value * 60;
    _massagerInfo.leftMinutes = value;

}

- (void)massagerInfoStop:(WMMassagerInfo *)massagerInfo {
    [_timerBar updateValue:massagerInfo.leftMinutes];
    [_rightSwitch setOn:NO];
    
    if (_massagerInfo.index != [WMBLEManager sharedInstance].massagerInfo.index) {
        return;
    }
    
    [[WMMusicManager sharedInstance] stopMusic];
    [_musicBtn setSelected:NO];
    
//    [[WMBLEManager sharedInstance] writeValue:[WMBLEHelper dataforState:_massagerInfo] withResponse:YES];
}

- (void)massagerInfoMinutesChanged:(WMMassagerInfo *)massagerInfo {
    [_timerBar updateValue:massagerInfo.leftMinutes];
}

- (void)bleManagerNotiDidDisconnectPeripheral {
    dispatch_async(dispatch_get_main_queue(), ^ {
        // 如果全部掉线, 恢复状态
        if ([WMBLEManager sharedInstance].connectedPeripherals.count < 1) {
            [_rightSwitch setOn:[WMBLEManager sharedInstance].massagerInfo.isOn];
            [_timerBar updateValue:[WMBLEManager sharedInstance].massagerInfo.leftMinutes];
        }
    });
}

#pragma mark - Private

- (void)configureBase {
    //
    self.navigationItem.title = NSLocalizedString(@"cell_0", @"");
    
    // Music Button
    _chooseMusicButton.titleLabel.text = [WMStandarMusic standarMusicNameForIndex:_index];
    [_chooseMusicButton setTitle:[WMStandarMusic standarMusicNameForIndex:_index] forState:UIControlStateNormal];
    
    // Massager Info
    
    WMMassagerInfo *bleMassagerInfo = [WMBLEManager sharedInstance].massagerInfo;
    
    if (bleMassagerInfo.index == 0) {
        // Is self
        _massagerInfo = bleMassagerInfo;
        bleMassagerInfo.delegate = self;
        
        if ([WMMusicManager sharedInstance].audioPlayer.isPlaying) {
            [_musicBtn setSelected:YES];
        } else {
            [_musicBtn setSelected:NO];
        }
        
    } else {
        _massagerInfo = [[WMMassagerInfo alloc] init];
    }
    
    // 更新
    _timerBar.delegate = self;
    _liduBar.delegate = self;
    
    [_liduBar updateSelectedIndex:_massagerInfo.lidu - 1];
    [_timerBar updateValue:_massagerInfo.minutes];
    
    
    // 配置模式选择的 ScrollView
    _mScrollView.contentSize = CGSizeMake(80 * 6, 0);
    
    int btnModes[] = {BLEHelperMassagerModeQinFu, BLEHelperMassagerModeRouNie, BLEHelperMassagerModeZhenJiu, BLEHelperMassagerModeTuiNa, BLEHelperMassagerModeChuiJi, BLEHelperMassagerModeZhiYa};
    _modeButtons = [NSMutableArray array];
    
    for (int i = 0; i < 6; i++) {
        CGRect btnFrame = CGRectMake(80 * i, 0, 80, 50);
        BLEHelperMassagerMode mode = btnModes[i];
        
        WMJDModeButton *modeButton = [WMJDModeButton jdModeButtonWithMode:mode];
        modeButton.frame = btnFrame;
        [modeButton addTarget:self action:@selector(updateModeClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_mScrollView addSubview:modeButton];
        [_modeButtons addObject:modeButton];
    }
    
//    WMJDModeButton *firstBtn = _modeButtons.firstObject;
//    [firstBtn setSelected:YES];
//    _mode = firstBtn.mode;
//    _selectedModeIndex = 0;
    
    // 找出选中的模式
    for (int i = 0; i < _modeButtons.count; i++) {
        WMJDModeButton *btn = _modeButtons[i];
        if (btn.mode == _massagerInfo.mode) {
            [self updateModeClick:btn];
            break;
        }
    }
    
    if (_massagerInfo.index == [WMBLEManager sharedInstance].massagerInfo.index) {
        [[WMBLEManager sharedInstance] writeValue:[WMBLEHelper dataForMode:_massagerInfo mutable:NO] withResponse:YES];
        [[WMBLEManager sharedInstance] writeValue:[WMBLEHelper dataForLidu:_massagerInfo] withResponse:YES];
        [[WMBLEManager sharedInstance] writeValue:[WMBLEHelper dataforState:_massagerInfo] withResponse:YES];
    }
    
    // 配置右上角的开关
    _rightSwitch = [[UISwitch alloc] init];
//    [rightSwitch setTintColor:[UIColor beasunNavSwitchSelectedColor]]; 这是用来设置边的
//    [rightSwitch setThumbTintColor:[UIColor beasunNavSwitchSelectedColor]]; 这是用来设置按钮色
    [_rightSwitch setOnTintColor:[UIColor beasunNavSwitchSelectedColor]];
    [_rightSwitch addTarget:self action:@selector(rightSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
    [_rightSwitch setOn:_massagerInfo.isOn];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:_rightSwitch];
    self.navigationItem.rightBarButtonItem = item;
    
    [self configureNoti];
    
    
    // 循环读取时间
//    _mTimer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
}

// 配置通知
- (void)configureNoti {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bleManagerNotiDidDisconnectPeripheral) name:kBLEManagerNotiDidDisconnectPeripheral object:nil];
}

- (void)showAlertMessage:(NSString *)msg {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:msg message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    alert.alertViewStyle = UIAlertViewStyleDefault;
    alert.alpha = 0.8;
    [alert show];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissWithClickedButtonIndex:0 animated:YES];
    });
}

@end
