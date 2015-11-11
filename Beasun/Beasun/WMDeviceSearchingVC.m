//
//  WMDeviceSearchingVC.m
//  Beasun
//
//  Created by maginawin on 15/9/8.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import "WMDeviceSearchingVC.h"
#import "WMSearchDeviceCell.h"
#import "WMBLEManager.h"
#import "WMSavedPeripheral.h"

const float kDeviceCircelPeriod = 0.5f;

@interface WMDeviceSearchingVC () <UITableViewDataSource, UITableViewDelegate, WMSearchDeviceCellDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *circelView;
@property (weak, nonatomic) IBOutlet UIImageView *circleImageView;
@property (weak, nonatomic) IBOutlet UILabel *searchLabel;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@property (assign, nonatomic) BOOL isSearching;

@property (strong, nonatomic) NSMutableArray *foundPeirpherals;
@property (strong, nonatomic) NSMutableArray *selectedPeripherals;

@end

@implementation WMDeviceSearchingVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureBase];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 开始查找设备
    CBUUID *serviceUUID = [CBUUID UUIDWithString:kBLEManagerUUIDForService];
    NSArray *uuids = @[serviceUUID];
    // 先查找所有的试试
    [[WMBLEManager sharedInstance] stopScan];
    [[WMBLEManager sharedInstance] scanForPeripheralsWithServices:nil];
#warning 未使用过滤
    
    // 就这样一直找吧, 别停
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self updateSearchingState:NO];
//    });
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    // 停止查找设备
    [[WMBLEManager sharedInstance] stopScan];
}

- (IBAction)searchClick:(id)sender {
    _isSearching = !_isSearching;
    
    [self updateSearchingState:_isSearching];
}

#pragma mark - WMSearchDeviceCellDelegate

- (void)searchDeviceCell:(WMSearchDeviceCell *)cell changedChooseStateAtIndexPath:(NSIndexPath *)indexPath {
    CBPeripheral *peripheral = _foundPeirpherals[indexPath.row];
    
    // 选中
    if (cell.selectedButton.isSelected) {
        if (![_selectedPeripherals containsObject:peripheral]) {
            [_selectedPeripherals addObject:peripheral];
        }
    }
    // 未选中
    else {
        if ([_selectedPeripherals containsObject:peripheral]) {
            [_selectedPeripherals removeObject:peripheral];
        }
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
}

#pragma mark - UITableViewDataSource, UITabBarDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _foundPeirpherals.count;
//    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WMSearchDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idSearchDeviceCell"];
    
    if (!cell) {
        cell = [WMSearchDeviceCell searchDeviceCellWithIndexPath:indexPath];
    }
    
    cell.delegate = self;
//    [cell.selectedButton setSelected:NO];
    
    CBPeripheral *peripheral = _foundPeirpherals[indexPath.row];
    
    if (peripheral) {
        cell.nameLabel.text = peripheral.name;
        cell.uuidStringLabel.text = peripheral.identifier.UUIDString;
    } else {
        cell.nameLabel.text = @"-------";
        cell.uuidStringLabel.text = @"-------";
    }
    
    if ([_selectedPeripherals containsObject:peripheral]) {
        [cell.selectedButton setSelected:YES];
    } else {
        [cell.selectedButton setSelected:NO];
    }
    
    return cell;
}

#pragma mark - Selector

- (void)rightItemClick:(UIBarButtonItem *)item {
    if (_selectedPeripherals.count < 1) {
        return;
    }
    
    // 绑定的设备加上要连的设备不要超过 6
    NSArray *savedPeripherals = [WMSavedPeripheral savedPeripheral];
    
    if ((_selectedPeripherals.count + savedPeripherals.count) > 6) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"device_attention", @"") message:NSLocalizedString(@"device_attention_text", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"confirm", @"") otherButtonTitles:nil, nil];
        alertView.alertViewStyle = UIAlertViewStyleDefault;
        
        [alertView show];
        
        return;
    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^ {
        for (int i = 0; i < _selectedPeripherals.count; i++) {
            CBPeripheral *peripheral = _selectedPeripherals[i];
            
            [WMSavedPeripheral addPeripheral:peripheral];
            
            [[WMBLEManager sharedInstance] connectPeripheral:peripheral];
        }
    });
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)bleManagerNotiDidDiscoverPeripheral:(NSNotification *)noti {
    dispatch_async(dispatch_get_main_queue(), ^ {
        NSDictionary *dict = noti.object;
        
        CBPeripheral *peripheral = dict[kBLEManagerNotiKeyPeripheral];
        
        if (![_foundPeirpherals containsObject:peripheral]) {
            [_foundPeirpherals addObject:peripheral];
            
            [_mTableView reloadData];
            
            if (_circelView.isHidden) {
                // 找到新设备
                if (_foundPeirpherals.count > 0) {
                    _searchLabel.text = [NSString stringWithFormat:NSLocalizedString(@"device_searching_end", @""), (int)_foundPeirpherals.count];
                }
                // 未找到新设备
                else {
                    _searchLabel.text = NSLocalizedString(@"device_searching_no_deivce", @"");
                }
            }
        }
        
    });
}

#pragma mark - Private

// 更新查找状态
- (void)updateSearchingState:(BOOL)state {
    _circelView.hidden = !state;
    
    // 正在搜索 / 更新搜索状态
    if (state) {
        // 更新动画 算了有 BUG
//        [_circleImageView.layer removeAllAnimations];
//        [self configureAnimation];
        
        _searchLabel.text = NSLocalizedString(@"device_searching_on", @"");
        
        [_foundPeirpherals removeAllObjects];
        [_selectedPeripherals removeAllObjects];
        [_mTableView reloadData];
        
        CBUUID *serviceUUID = [CBUUID UUIDWithString:kBLEManagerUUIDForService];
        NSArray *uuids = @[serviceUUID];
        [[WMBLEManager sharedInstance] stopScan];
        [[WMBLEManager sharedInstance] scanForPeripheralsWithServices:nil];
#warning 未使用过滤
    }
    // 结束搜索
    else {
        [[WMBLEManager sharedInstance] stopScan];
        
        // 找到新设备
        if (_foundPeirpherals.count > 0) {
            _searchLabel.text = [NSString stringWithFormat:NSLocalizedString(@"device_searching_end", @""), (int)_foundPeirpherals.count];
        }
        // 未找到新设备
        else {
            _searchLabel.text = NSLocalizedString(@"device_searching_no_deivce", @"");
        }
    }
}

- (void)configureBase {
    // Localizable
    self.navigationItem.title = NSLocalizedString(@"nav_search_device", @"");
    _searchLabel.text = NSLocalizedString(@"device_searching_on", @"");
    
    // Nav item
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"device_selected"] style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    // Params
    _isSearching = YES;
    _foundPeirpherals = [NSMutableArray array];
    _selectedPeripherals = [NSMutableArray array];
    
    // Noti
    [self configureNotification];
    
    // TableView
    _mTableView.delegate = self;
    _mTableView.dataSource = self;
    _mTableView.tableFooterView = [[UIView alloc] init];
    
    // Circle animation
    [self configureAnimation];
}

- (void)configureAnimation {
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform"];
    anim.duration = kDeviceCircelPeriod;
    anim.cumulative = YES;
    anim.repeatCount = MAXFLOAT;
    anim.removedOnCompletion = YES;
    anim.fromValue = [NSValue valueWithCATransform3D:_circleImageView.layer.transform];
    anim.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(_circleImageView.layer.transform, M_PI_2, 0, 0, 1)];
    _circleImageView.layer.transform = CATransform3DRotate(_circleImageView.layer.transform, M_PI_2, 0, 0, 1);
    
    [_circleImageView.layer addAnimation:anim forKey:@""];
}

- (void)configureNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bleManagerNotiDidDiscoverPeripheral:) name:kBLEManagerNotiDidDiscoverPeripheral object:nil];
}

@end
