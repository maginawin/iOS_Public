//
//  WMBLEManager.m
//  Beasun
//
//  Created by maginawin on 15/9/8.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import "WMBLEManager.h"
#import "WMSavedPeripheral.h"
#import "WMBLEHelper.h"

// BLE UUID
NSString *const kBLEManagerUUIDForService = @"FFF0";
NSString *const kBLEManagerUUIDForWriteChar = @"FFF2";
NSString *const kBLEManagerUUIDForNotifyChar = @"FFF1";

// Key for noti value
NSString *const kBLEManagerNotiKeyPeripheral = @"kBLEManagerNotiPeripheral";
NSString *const kBLEManagerNotiKeyRSSI = @"kBLEManagerNotiRSSI";
NSString *const kBLEManagerNotiKeyCharacteristic = @"kBLEManagerNotiCharacteristic";

// Key for noti key
NSString *const kBLEManagerNotiDidUpdateState = @"kBLEManagerNotiDidUpdateState";
NSString *const kBLEManagerNotiDidDiscoverPeripheral = @"kBLEManagerDiscoverPeripheral";
NSString *const kBLEManagerNotiDidConnectPeripheral = @"kBLEManagerDidConnectPeripheral";
NSString *const kBLEManagerNotiDidDisconnectPeripheral = @"kBLEManagerDidDisconnectPeripheral";
NSString *const kBLEManagerNotiDidUpdateValueForCharacteristic = @"kBLEManagerDidUpdateValueForCharacteristic";
NSString *const kBLEManagerNotiDidUpdateBattery = @"kBLEManagerNotiDidUpdateBattery";

@interface WMBLEManager ()

@end

@implementation WMBLEManager

+ (instancetype)sharedInstance {
    static id sharedInstance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (id)init {
    self = [super init];
    
    if (self) {
        // Central Manager Initialization Options
        
        // CBCentralManagerOptionShowPowerAlertKey :
        // - NSNumber BOOL : 是否在没有打开蓝牙的情况下提醒要打开蓝牙, 在初始化的时候
        
        // CBCentralManagerOptionRestoreIdentifierKey :
        // - 用来恢复蓝牙连接
        
        NSDictionary *options = @{CBCentralManagerOptionShowPowerAlertKey : @YES};
        
        dispatch_queue_t centralQueue = dispatch_queue_create("maginaBeasonBLEManagerQueue", DISPATCH_QUEUE_CONCURRENT);
        
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:centralQueue options:options];
        
        _foundPeripherals = [NSMutableDictionary dictionary];
//        _connectedPeripherals = [NSMutableArray array];
        _connectedPeripherals = [NSMutableDictionary dictionary];
        _writeCharsDict = [NSMutableDictionary dictionary];
        _peripheralsBattery = [NSMutableDictionary dictionary];
        
        // Init massager info
        _massagerInfo = [[WMMassagerInfo alloc] init];
    }
    
    return self;
}

#pragma mark - Public

- (void)scanForPeripheralsWithServices:(NSArray *)serviceUUIDs {
    // Peripheral Scanning Options
    
    // CBCentralManagerScanOptionAllowDuplicatesKey :
    // - 传 NSNumber 的 BOOL 值, 默认 NO
    // - YES 则允许重复查找, 会重复回调 didDiscoverPeripheral, 影响电池寿命
    // - NO 不允许重复查找, 若已经查找过, 则不会调用 didDiscoverPeripheral
    
    // CBCentralManagerScanOptionSolicitedServiceUUIDsKey
    
    NSDictionary *options = @{CBCentralManagerScanOptionAllowDuplicatesKey : @NO};
    
    [_centralManager scanForPeripheralsWithServices:serviceUUIDs options:options];
}

- (void)stopScan {
    [_centralManager stopScan];
}

- (void)connectPeripheral:(CBPeripheral *)peripheral {
    // Peripheral Connection Options
    
    // CBConnectPeripheralOptionNotifyOnConnectionKey :
    // - NSNumber BOOL : 连接时是否提醒, 默认为 NO
    
    // CBConnectPeripheralOptionNotifyOnDisconnectionKey :
    // - NSNumber BOOL : 掉线时是否提醒, 默认为 NO
    
    // CBConnectPeripheralOptionNotifyOnNotificationKey :
    // - NSNumber BOOL : 收到通知时是否提醒, 默认为 NO
    
    if (!peripheral) {
        return;
    }
    
    NSDictionary *options = @{CBConnectPeripheralOptionNotifyOnConnectionKey : @NO, CBConnectPeripheralOptionNotifyOnDisconnectionKey : @NO, CBConnectPeripheralOptionNotifyOnNotificationKey : @NO};
    
    [_centralManager connectPeripheral:peripheral options:options];
}

- (void)connectPeripherals:(NSArray *)peripherals {
    if (!peripherals || peripherals.count < 1) {
        return;
    }
    
    for (int i = 0; i < peripherals.count; i++) {
        CBPeripheral *peripheral = peripherals[i];
        
        [self connectPeripheral:peripheral];
    }
}

- (void)cancelPeripheralConnection:(CBPeripheral *)peripheral {
//    if ([_connectedPeripherals containsObject:peripheral]) {
//        [_connectedPeripherals removeObject:peripheral];
//    }
    
    if (!peripheral) {
        return;
    }
    
    [_connectedPeripherals removeObjectForKey:peripheral.identifier.UUIDString];
    [_peripheralsBattery removeObjectForKey:peripheral.identifier.UUIDString];
    
    [_centralManager cancelPeripheralConnection:peripheral];
}

- (void)cancelAllPeripherals {
    if (!_connectedPeripherals || _connectedPeripherals.count <= 0) {
        return;
    }
    
//    for (int i = 0; i < _connectedPeripherals.count; i++) {
//        CBPeripheral *peripheral = _connectedPeripherals[i];
//        
//        [self cancelPeripheralConnection:peripheral];
//    }

    for (NSString *key in _connectedPeripherals) {
        CBPeripheral *peripheral = _connectedPeripherals[key];
        [self cancelPeripheralConnection:peripheral];
    }
    
    [_connectedPeripherals removeAllObjects];
    [_peripheralsBattery removeAllObjects];
    
    [_writeCharsDict removeAllObjects];
}

- (void)writeValue:(NSData *)value toPeripheral:(CBPeripheral *)peripheral withResponse:(BOOL)response {
    if (value && peripheral.state == CBPeripheralStateConnected) {
        CBCharacteristicWriteType writeType = response ? CBCharacteristicWriteWithResponse : CBCharacteristicWriteWithoutResponse;
        CBCharacteristic *writeChar = [_writeCharsDict objectForKey:peripheral.identifier.UUIDString];
        
        if (writeChar) {
            [peripheral writeValue:value forCharacteristic:writeChar type:writeType];
        }
    }
}

- (void)writeValue:(NSData *)value withResponse:(BOOL)response {
    if (_connectedPeripherals.count <= 0) {
        return;
    }
    
    for (NSString *key in _connectedPeripherals) {
        CBPeripheral *peripheral = _connectedPeripherals[key];
        CBCharacteristic *mChar = _writeCharsDict[peripheral.identifier.UUIDString];
        
        if (mChar && peripheral.state == CBPeripheralStateConnected) {
            CBCharacteristicWriteType writeType = response ? CBCharacteristicWriteWithResponse : CBCharacteristicWriteWithoutResponse;
            [peripheral writeValue:value forCharacteristic:mChar type:writeType];
            
             NSLog(@"write data %@ to peripheral %@", value, peripheral.name);
        }
    }
}

#pragma mark - Central Manager Delegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    [[NSNotificationCenter defaultCenter] postNotificationName:kBLEManagerNotiDidUpdateState object:central];
    
    switch (central.state) {
        case CBCentralManagerStatePoweredOn: {
            CBUUID *serviceUUID = [CBUUID UUIDWithString:kBLEManagerUUIDForService];
            NSArray *uuids = @[serviceUUID];
#warning 未过滤
            [self scanForPeripheralsWithServices:nil];
            
            break;
        }
        case CBCentralManagerStatePoweredOff: {

            break;
        }
        case CBCentralManagerStateResetting: {
            
            break;
        }
            
        default:
            break;
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    [_foundPeripherals setObject:peripheral forKey:peripheral.identifier.UUIDString];
    
    NSDictionary *dict = @{kBLEManagerNotiKeyPeripheral : peripheral, kBLEManagerNotiKeyRSSI : RSSI};
    
    // 如果有存在, 就连
    if ([WMSavedPeripheral isSavedPeripheral:peripheral]) {
        [self connectPeripheral:peripheral];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBLEManagerNotiDidDiscoverPeripheral object:dict];
    
//    if (![_foundPeripherals containsObject:peripheral]) {
//        [_foundPeripherals addObject:peripheral];
//    }
//    
//    NSDictionary *value = @{kBLEManagerNotiPeripheral : peripheral, kBLEManagerNotiRSSI : RSSI};
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:kBLEManagerDidDiscoverPeripheral object:value];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    // NSLog(@"didConnectPeripheral:%@", peripheral);
    
//    if ([_foundPeripherals containsObject:peripheral]) {
//        [_foundPeripherals removeObject:peripheral];
//    }
    
//    if (![_connectedPeripherals containsObject:peripheral]) {
//        [_connectedPeripherals addObject:peripheral];
//    }
    
    [_connectedPeripherals setObject:peripheral forKey:peripheral.identifier.UUIDString];
    [_peripheralsBattery setObject:@0 forKey:peripheral.identifier.UUIDString];
    
    // 既然连上了, 就保存下来吧
    // 如果不存在, 就保存
    if (![WMSavedPeripheral isSavedPeripheral:peripheral]) {
        [WMSavedPeripheral addPeripheral:peripheral];
    }
    
    peripheral.delegate = self;
    
    [peripheral discoverServices:nil];
    
    NSDictionary *value = @{kBLEManagerNotiKeyPeripheral : peripheral};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBLEManagerNotiDidConnectPeripheral object:value];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
    NSDictionary *value = @{kBLEManagerNotiKeyPeripheral : peripheral};
    
    // 移掉掉线的设备
    CBPeripheral *oldP = [_connectedPeripherals objectForKey:peripheral.identifier.UUIDString];
    if (oldP) {
        [_connectedPeripherals removeObjectForKey:peripheral.identifier.UUIDString];
        [_peripheralsBattery removeObjectForKey:peripheral.identifier.UUIDString];
    }
    
    // 如果全部掉线, 把 isOn 变成 NO
    // Remove Auto colse when disconnect
//    if (self.connectedPeripherals.count < 1) {
//        _massagerInfo.isOn = NO;
//    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBLEManagerNotiDidDisconnectPeripheral object:value];
    
    // Reconnect
//    if ([_connectedPeripherals containsObject:peripheral]) {
//        [self connectPeripheral:peripheral];
//    }
    
    //
    if ([WMSavedPeripheral isSavedPeripheral:peripheral]) {
        [self connectPeripheral:peripheral];
    }
    

}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
//    NSDictionary *value = @{kBLEManagerNotiPeripheral : peripheral};
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:kBLEManagerDidFailToConnectPeripheral object:value];
}

#pragma mark - Peripheral Delegate

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    NSArray *services = peripheral.services;
    
    for (int i = 0; i < services.count; i++) {
        [peripheral discoverCharacteristics:nil forService:services[i]];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    NSArray *characteristics = service.characteristics;
    
    for (int i = 0; i < characteristics.count; i++) {
        CBCharacteristic *mChar = characteristics[i];
        
        // Notify Char
        if ([mChar.UUID isEqual:[CBUUID UUIDWithString:kBLEManagerUUIDForNotifyChar]]) {
            NSLog(@"noti char found");
            [peripheral setNotifyValue:YES forCharacteristic:mChar];
        }
        // Write char
        else if ([mChar.UUID isEqual:[CBUUID UUIDWithString:kBLEManagerUUIDForWriteChar]]) {
            NSLog(@"write char found");
            // 用 peripheral 的 uuidstring 作为 key 把 mChar 存进去
            [_writeCharsDict setObject:mChar forKey:peripheral.identifier.UUIDString];
            
            // 连接上就把配置发给你
            [self writeValue:[WMBLEHelper dataForMode:_massagerInfo mutable:NO] withResponse:YES];
            [self writeValue:[WMBLEHelper dataForLidu:_massagerInfo] withResponse:YES];
            [self writeValue:[WMBLEHelper dataforState:_massagerInfo] withResponse:YES];
        }
    }
}


- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
     NSLog(@"didWriteValueForCharacteristic %@", characteristic.value);
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
     NSLog(@"didUpdateValueForCharacteristic:%@", characteristic.value);
    
    [self handlePeripheral:peripheral didUpdateValueForCharacteristic:characteristic error:error];
    
    NSDictionary *dict = @{kBLEManagerNotiKeyCharacteristic : characteristic, kBLEManagerNotiKeyPeripheral : peripheral};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBLEManagerNotiDidUpdateValueForCharacteristic object:dict];
}

#pragma mark - Private

/** 处理收到的数据 */
- (void)handlePeripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSData *value = characteristic.value;
    
    NSString *valueString = [WMBLEManager hexStringFromHexData:value];
    
    if (valueString.length < 2) {
        return;
    }
    
    NSString *tagString = [valueString substringToIndex:2];
    NSInteger tag = [WMBLEManager integerFromHexString:tagString];
    
    switch (tag) {
            // 电量
        case 0xF2: {
            
            if (valueString.length < 4) {
                break;
            }
            
            NSString *batteryString = [valueString substringWithRange:NSMakeRange(2, 2)];
            NSInteger battery = [WMBLEManager integerFromHexString:batteryString];
            if (battery > 4) {
                battery = 4;
            }
            
            NSNumber *batteryNumber = [NSNumber numberWithInteger:battery];
            
            [_peripheralsBattery setValue:batteryNumber forKey:peripheral.identifier.UUIDString];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kBLEManagerNotiDidUpdateBattery object:nil];
            
            break;
        }
    }
}

#pragma mark - Data handler

+ (NSString*)hexStringFromHexData:(NSData *)aData {
    //    NSString* hexString;
    const unsigned char* dataBuffer = (const unsigned char*)[aData bytes];
    if (!dataBuffer) {
        return nil;
    }
    NSUInteger dataLength = [aData length];
    NSMutableString* hexString = [NSMutableString stringWithCapacity:(dataLength * 2)];
    for (int i = 0; i < dataLength; i++) {
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];
    }
    return [hexString uppercaseString];
}

+ (NSData*)hexDataFromHexString:(NSString *)hexString {
    NSMutableData* hexData = [NSMutableData data];
    int idx;
    for (idx = 0; (idx + 2) <= hexString.length; idx += 2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* itemString = [hexString substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:itemString];
        unsigned int hexInt;
        [scanner scanHexInt:&hexInt];
        [hexData appendBytes:&hexInt length:1];
    }
    return hexData;
}

+ (NSInteger)integerFromHexString:(NSString *)hexString {
    unsigned long long hexInt = 0;
    // Create scanner
    NSScanner* scanner = [NSScanner scannerWithString:hexString];
    // Tell scanner to skip the # character
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    // Scan hex value
    [scanner scanHexLongLong:&hexInt];
    return (long)hexInt;
}

+ (NSString*)stringFromHexString:(NSString *)hexString {
    long int value = [self integerFromHexString:hexString];
    return [NSString stringWithFormat:@"%02ld", value];
}

+ (NSData*)hexDataFromString:(NSString *)aString {
    NSMutableData* hexData = [NSMutableData data];
    int idx;
    for (idx = 0; (idx + 2) <= aString.length; idx += 2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* item = [aString substringWithRange:range];
        NSString* hexItem = [NSString stringWithFormat:@"%02x", [item intValue]];
        NSScanner* scannner = [NSScanner scannerWithString:hexItem];
        unsigned int hexInt;
        [scannner scanHexInt:&hexInt];
        [hexData appendBytes:&hexInt length:1];
    }
    return hexData;
}

+ (NSString*)hexStringFromString:(NSString *)aString {
    NSString* hexString = [NSString stringWithFormat:@"%02lx", (long)[aString integerValue]];
    if (hexString.length % 2 != 0) {
        hexString = [NSString stringWithFormat:@"0%@", hexString];
    }
    return hexString;
}

+ (NSString*)hexStringFromInteger:(NSInteger)aInteger {
    NSString* hexString = [NSString stringWithFormat:@"%lx", (long)aInteger];
    if (hexString.length % 2 != 0) {
        hexString = [NSString stringWithFormat:@"0%@", hexString];
    }
    return hexString;
}


@end
