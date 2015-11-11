//
//  WMDeviceVC.m
//  Beasun
//
//  Created by maginawin on 15/8/31.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import "WMDeviceVC.h"
#import "WMSavedPeripheral.h"
#import "WMDeviceCell.h"
#import "WMAddDeviceCell.h"
#import "UIColor+Beasun.h"
#import "WMDeviceRenameVC.h"
#import "WMDeviceSearchingVC.h"
#import "WMBLEManager.h"
#import "WMBLEHelper.h"

NSString const* kSavedPeripheralDeviceCellId = @"idSavedPeripheralDevice";
NSString const* kSavedPeripheralAddBtnCellId = @"idSavedPeripheralAddBtn";

@interface WMDeviceVC () <UITableViewDataSource, UITableViewDelegate, WMDeviceCellDelegate, WMAddDeviceCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@end

@implementation WMDeviceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureBase];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_mTableView reloadData];
}

#pragma mark - WMDeviceCellDelegate, WMAddDeviceCellDelegate

// 关机
- (void)deviceCell:(WMDeviceCell *)cell closeClickAtIndexPath:(NSIndexPath *)indexPath {
    WMPeripheral *mPeripheral = [[WMSavedPeripheral savedPeripheral] objectAtIndex:indexPath.row];
    
    CBPeripheral *peripheral = [[WMBLEManager sharedInstance].connectedPeripherals objectForKey:mPeripheral.uuidString];
    
    if (peripheral) {
        [[WMBLEManager sharedInstance] writeValue:[WMBLEHelper dataForCloseMassager] toPeripheral:peripheral withResponse:YES];
    }
}

// 删除
- (void)deviceCell:(WMDeviceCell *)cell deleteClickAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *peripherals = [WMSavedPeripheral savedPeripheral];
    WMPeripheral *peripheral = peripherals[indexPath.row];
    
    NSString *key = peripheral.uuidString.copy;
    
    [WMSavedPeripheral removePeripheral:peripheral];
    
    if (key) {
        CBPeripheral *cbPer = [[WMBLEManager sharedInstance].foundPeripherals objectForKey:key];
        if (cbPer) {
            [[WMBLEManager sharedInstance].foundPeripherals removeObjectForKey:key];
        }
        
        CBPeripheral *cbPer2 = [[WMBLEManager sharedInstance].connectedPeripherals objectForKey:key];
        [[WMBLEManager sharedInstance] cancelPeripheralConnection:cbPer2];
        
        if (cbPer2) {
            [[WMBLEManager sharedInstance].connectedPeripherals removeObjectForKey:key];
            
            if ([WMBLEManager sharedInstance].connectedPeripherals.count < 1) {
                [WMBLEManager sharedInstance].massagerInfo.isOn = NO;
            }
        }
    }
    
    [_mTableView reloadData];
}

// 改名
- (void)deviceCell:(WMDeviceCell *)cell detailClickAtIndexPath:(NSIndexPath *)indexPath {
    
    WMDeviceRenameVC *renameVC = [[WMDeviceRenameVC alloc] initWithNibName:@"WMDeviceRenameVC" bundle:nil];
    renameVC.hidesBottomBarWhenPushed = YES;
    renameVC.indexPath = indexPath;
    [self.navigationController pushViewController:renameVC animated:YES];
}

// 连接
- (void)deviceCell:(WMDeviceCell *)cell connectClickAtIndexPath:(NSIndexPath *)indexPath {
    CBUUID *serviceUUID = [CBUUID UUIDWithString:kBLEManagerUUIDForService];
    NSArray *uuids = @[serviceUUID];
    [[WMBLEManager sharedInstance] stopScan];
    [[WMBLEManager sharedInstance] scanForPeripheralsWithServices:nil];
#warning 未使用过滤
}

// 添加设备
- (void)addDeviceCell:(WMAddDeviceCell *)cell addClickAtIndexPath:(NSIndexPath *)indexPath {
    WMDeviceSearchingVC *searchingVC = [[WMDeviceSearchingVC alloc] initWithNibName:@"WMDeviceSearchingVC" bundle:nil];
    searchingVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchingVC animated:YES];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    // 为了去掉 滑出来的东西
//    [_mTableView reloadData];
//}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    // 为了去掉滑出来的菜单
    [_mTableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger deviceCount = [WMSavedPeripheral savedPeripheral].count;
    return deviceCount + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *peripherals = [WMSavedPeripheral savedPeripheral];
    
    //  Device
    if (indexPath.row < peripherals.count) {
        //        WMDeviceCell *cell = (WMDeviceCell *)[tableView dequeueReusableCellWithIdentifier:kSavedPeripheralDeviceCellId];
        WMDeviceCell *cell = nil;
        
        if (!cell) {
            cell = [WMDeviceCell deviceCellWithIndexPath:indexPath];
        }
        
        cell.delegate = self;
        
        WMPeripheral *peripheral = peripherals[indexPath.row];
        
        cell.peripheral = peripheral;
        
        [cell showMenuButton:NO];
        
        // 更新电池与连接状态
        CBPeripheral *connPeripheral = [[WMBLEManager sharedInstance].connectedPeripherals objectForKey:peripheral.uuidString];
        
        // 未连接
        if (!connPeripheral) {
            [cell.connectButotn setHidden:NO];
            [cell.batteryImageView updateImageForDeviceBatteryLevel:DeviceBatteryLevelDisconnect];
        }
        // 已连接
        else {
            [cell.connectButotn setHidden:YES];
            NSNumber *batteryNumber = [[WMBLEManager sharedInstance].peripheralsBattery objectForKey:peripheral.uuidString];
            if (batteryNumber) {
                NSInteger battery = batteryNumber.integerValue;
                [cell.batteryImageView updateImageForDeviceBatteryLevel:battery];
            } else {
                [cell.batteryImageView updateImageForDeviceBatteryLevel:DeviceBatteryLevelUnknown];
            }
        }
        
        return cell;
    }
    // Add Button
    else {
        //        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSavedPeripheralAddBtnCellId];
        WMAddDeviceCell *cell2 = nil;
        
        if (!cell2) {
            cell2 = [WMAddDeviceCell addDeviceCellForIndexPath:indexPath];
        }
        
        cell2.delegate = self;
        
        return cell2;
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"accessoryButtonTappedForRowWithIndexPath %@", indexPath);
}

#pragma mark - Private

- (void)bleManagerNotiDidChanged {

    dispatch_async(dispatch_get_main_queue(), ^ {
        [_mTableView reloadData];
    });
}

#pragma mark - Configure

- (void)configureBase {
    //
    self.navigationItem.title = NSLocalizedString(@"nav_device", @"");
    
    
    // Device TableView
    _mTableView.delegate = self;
    _mTableView.dataSource = self;
    _mTableView.tableFooterView = [[UIView alloc] init];
    _mTableView.backgroundColor =  [UIColor beasunTableViewBackground];
    
    // Notification
    [self configureNotificaiton];
}

- (void)configureNotificaiton {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bleManagerNotiDidChanged) name:kBLEManagerNotiDidConnectPeripheral object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bleManagerNotiDidChanged) name:kBLEManagerNotiDidDisconnectPeripheral object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bleManagerNotiDidChanged) name:kBLEManagerNotiDidUpdateState object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bleManagerNotiDidChanged) name:kBLEManagerNotiDidUpdateBattery object:nil];
}

@end
