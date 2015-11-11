//
//  WMBeasunOtherVC.m
//  Beasun
//
//  Created by maginawin on 15/8/31.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import "WMBeasunOtherVC.h"
#import "WMBLEHelper.h"
#import "UIColor+Beasun.h"
#import "WMMassagerInfo.h"
#import "WMBLEManager.h"
#import "WMTimerBar.h"
#import "WMLDTJView.h"
#import "WMMusicChooseVC.h"
#import "WMMassagerModeManager.h"
#import "WMMusicManager.h"
#import "WMStandarMusic.h"
//#import "WMMassagerMode.h"

@interface WMBeasunOtherVC () <WMMassagerInfoDelegate, WMTimerBarDelegate, WMLDTJViewDelegate, WMMusicChooseVCDelegate>

//@property (assign, nonatomic) BLEHelperMassagerMode mode;
@property (weak, nonatomic) IBOutlet UIButton *chooseMusicButton;
@property (weak, nonatomic) IBOutlet WMTimerBar *timerBar;
@property (weak, nonatomic) IBOutlet WMLDTJView *liduBar;

@property (strong, nonatomic) WMMassagerInfo *massagerInfo;
@property (strong, nonatomic) UISwitch *rightSwitch;

@property (assign, nonatomic) BOOL mutable;
@property (weak, nonatomic) IBOutlet UIButton *musicBtn;

@end

@implementation WMBeasunOtherVC

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
    
    if (_mutable) {
        WMMassagerMode *mode = [WMMassagerModeManager massagerModeForModeIndex:_index];
        mode.modeMusicName = _musicName;
        [WMMassagerModeManager saveOrUpdateMassagerMode:mode];
    } else {
        // Save as standar mode
        [WMStandarMusic saveMusicName:_musicName atIndex:_index];
    }
}

#pragma mark - WMTimerBarDelegate, WMLDTJViewDelegate

- (void)timerBarDidUpdateValue:(NSInteger)value {
    _massagerInfo.minutes = value;
    _massagerInfo.leftSeconds = value * 60;
    _massagerInfo.leftMinutes = value;
}

- (void)ldtjViewUpdateSelectedIndex:(NSInteger)selectedIndex {
    _massagerInfo.lidu = selectedIndex + 1;
    
    if (_massagerInfo.index == [WMBLEManager sharedInstance].massagerInfo.index) {
        //        [[WMBLEManager sharedInstance] writeValue:[WMBLEHelper dataForMode:_massagerInfo] withResponse:YES];
        [[WMBLEManager sharedInstance] writeValue:[WMBLEHelper dataForLidu:_massagerInfo] withResponse:YES];
        //        [[WMBLEManager sharedInstance] writeValue:[WMBLEHelper dataforState:_massagerInfo] withResponse:YES];
    }
}

#pragma mark - WMMassagerInfoDelegate

- (void)massagerInfoMinutesChanged:(WMMassagerInfo *)massagerInfo {
    [_timerBar updateValue:massagerInfo.leftMinutes];
}

- (void)massagerInfoStop:(WMMassagerInfo *)massagerInfo {
    [_timerBar updateValue:massagerInfo.leftMinutes];
    [_rightSwitch setOn:NO];
    
    [[WMMusicManager sharedInstance] stopMusic];
    [_musicBtn setSelected:NO];
    
//    if (_massagerInfo.index == [WMBLEManager sharedInstance].massagerInfo.index) {
//        //        [[WMBLEManager sharedInstance] writeValue:[WMBLEHelper dataForMode:_massagerInfo] withResponse:YES];
//        //        [[WMBLEManager sharedInstance] writeValue:[WMBLEHelper dataForLidu:_massagerInfo] withResponse:YES];
//        [[WMBLEManager sharedInstance] writeValue:[WMBLEHelper dataforState:_massagerInfo] withResponse:YES];
//    }
}

#pragma mark - Selector

- (IBAction)chooseMusicClick:(id)sender {    
    WMMusicChooseVC *musicChooseVC = [[WMMusicChooseVC alloc] initWithNibName:@"WMMusicChooseVC" bundle:nil];
    musicChooseVC.delegate = self;
    
    [self.navigationController pushViewController:musicChooseVC animated:YES];
}

- (void)rightSwitchValueChanged:(UISwitch *)sender {
    if ([sender isOn]) {
        // 未连接设备, 则提醒
        if ([WMBLEManager sharedInstance].connectedPeripherals.count <= 0) {
            [self showAlertMessage:NSLocalizedString(@"connect_at_least_one_device", @"")];
            
            [sender setOn:NO];
            
            return;
        }
        
        NSInteger tempMode = _massagerInfo.mode;
        _massagerInfo = [WMBLEManager sharedInstance].massagerInfo;
        _massagerInfo.delegate = self;
        _massagerInfo.index = _index;
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
            [[WMBLEManager sharedInstance] writeValue:[WMBLEHelper dataForMode:_massagerInfo mutable:_mutable] withResponse:YES];
            [[WMBLEManager sharedInstance] writeValue:[WMBLEHelper dataForLidu:_massagerInfo] withResponse:YES];
            [[WMBLEManager sharedInstance] writeValue:[WMBLEHelper dataforState:_massagerInfo] withResponse:YES];
        }
    } else {
//        [_massagerInfo setIsOn:NO];
        [_massagerInfo stop];
        [[WMMusicManager sharedInstance] stopMusic];
        [_musicBtn setSelected:NO];
    }
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
    NSString *title = @"";
    _mutable = NO;
    
    // 初始化 MassagerInfo
    WMMassagerInfo *bleMassagerInfo = [WMBLEManager sharedInstance].massagerInfo;
    
    if (bleMassagerInfo.index == _index) {
        _massagerInfo = bleMassagerInfo;
        bleMassagerInfo.delegate = self;
        
        if ([WMMusicManager sharedInstance].audioPlayer.isPlaying) {
            [_musicBtn setSelected:YES];
        }
        
//        if (_musicBtn.selected) {
//            if (![[WMMusicManager sharedInstance].audioPlayer isPlaying]) {
//                [[WMMusicManager sharedInstance] playMusicNamed:_musicName];
//            }
//        }
        
    } else {
        _massagerInfo = [[WMMassagerInfo alloc] init];
    }
    
    // 根据 index 判断所处的模式
    switch (_index) {
            // 轻抚
        case -1: {
            title = NSLocalizedString(@"qinfu_anmo", @"");
            _massagerInfo.mode = BLEHelperMassagerModeQinFu;
            break;
        }
            // 揉捏
        case -2: {
            title = NSLocalizedString(@"rounie_anmo", @"");
            _massagerInfo.mode = BLEHelperMassagerModeRouNie;
            break;
        }
            // 针灸
        case -3: {
            title = NSLocalizedString(@"zhenjiu_anmo", @"");
            _massagerInfo.mode = BLEHelperMassagerModeZhenJiu;
            break;
        }
            // 推拿
        case -4: {
            title = NSLocalizedString(@"tuina_anmo", @"");
            _massagerInfo.mode = BLEHelperMassagerModeTuiNa;
            break;
        }
            // 锤击
        case -5: {
            title = NSLocalizedString(@"chuiji_anmo", @"");
            _massagerInfo.mode = BLEHelperMassagerModeChuiJi;
            break;
        }
            // 刮痧
        case -6: {
            title = NSLocalizedString(@"guasha_anmo", @"");
            _massagerInfo.mode = BLEHelperMassagerModeGuaSha;
            break;
        }
            // 指压
        case -7: {
            title = NSLocalizedString(@"zhiya_anmo", @"");
            _massagerInfo.mode = BLEHelperMassagerModeZhiYa;
            break;
        }
            // 颈椎
        case -8: {
            title = NSLocalizedString(@"jinzhui_anmo", @"");
            _massagerInfo.mode = BLEHelperMassagerModeJinZhui;
            break;
        }
            // 瘦身
        case -9: {
            title = NSLocalizedString(@"shoushen_anmo", @"");
            _massagerInfo.mode = BLEHelperMassagerModeShouShen;
            break;
        }
            // 火罐
        case -10: {
            title = NSLocalizedString(@"huoguan_anmo", @"");
            _massagerInfo.mode = BLEHelperMassagerModeHuoGuan;
            break;
        }
            // 小憩
        case 1: {
            _massagerInfo.mode = BLEHelperMassagerModeTuiNa;
            title = NSLocalizedString(@"cell_1", @"");
            break;
        }
            // 宅印象
        case 2: {
            _massagerInfo.mode = BLEHelperMassagerModeGuaSha;
            title = NSLocalizedString(@"cell_2", @"");
            break;
        }
            // 空山竹语
        case 3: {
            _massagerInfo.mode = BLEHelperMassagerModeShouShen;
            title = NSLocalizedString(@"cell_3", @"");
            break;
        }
            // 办公室
        case 4: {
            _massagerInfo.mode = BLEHelperMassagerModeQinFu;
            title = NSLocalizedString(@"cell_4", @"");
            break;
        }
            // 旅行
        case 5: {
            _massagerInfo.mode = BLEHelperMassagerModeZhenJiu;
            title = NSLocalizedString(@"cell_5", @"");
            break;
        }
            // 听潮
        case 6: {
            _massagerInfo.mode = BLEHelperMassagerModeChuiJi;
            title = NSLocalizedString(@"cell_6", @"");
            break;
        }
            // 悦风聆
        case 7: {
            _massagerInfo.mode = BLEHelperMassagerModeZhiYa;
            title = NSLocalizedString(@"cell_7", @"");
            break;
        }
            // 静心
        case 8: {
            _massagerInfo.mode = BLEHelperMassagerModeJinZhui;
            title = NSLocalizedString(@"cell_8", @"");
            break;
        }
            // 在路上
        case 9: {
            _massagerInfo.mode = BLEHelperMassagerModeHuoGuan;
            title = NSLocalizedString(@"cell_9", @"");
            break;
        }
            // 静夜
        case 10: {
            _massagerInfo.mode = BLEHelperMassagerModeAnMo;
            title = NSLocalizedString(@"cell_10", @"");
            break;
        }
            // Custom mode
        default: {
            _mutable = YES;
            
            WMMassagerMode *mode = [WMMassagerModeManager massagerModeForModeIndex:_index];
            _massagerInfo.mode = mode.modeValue;
            title = mode.modeName;
            _musicName = mode.modeMusicName;
            
            break;
        }
    }
    
    // 更新信息
    if (_massagerInfo.index == [WMBLEManager sharedInstance].massagerInfo.index) {
        [[WMBLEManager sharedInstance] writeValue:[WMBLEHelper dataForMode:_massagerInfo mutable:_mutable] withResponse:YES];
        [[WMBLEManager sharedInstance] writeValue:[WMBLEHelper dataForLidu:_massagerInfo] withResponse:YES];
        [[WMBLEManager sharedInstance] writeValue:[WMBLEHelper dataforState:_massagerInfo] withResponse:YES];
    }
    
    // 国际化
    self.navigationItem.title = title;
    
    // Music Button
    _chooseMusicButton.titleLabel.text = _musicName;
    [_chooseMusicButton setTitle:_musicName forState:UIControlStateNormal];
    
    // 力度与时间
    _timerBar.delegate = self;
    _liduBar.delegate = self;
    [_liduBar updateSelectedIndex:_massagerInfo.lidu - 1];
    [_timerBar updateValue:_massagerInfo.minutes];
    
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
}

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
