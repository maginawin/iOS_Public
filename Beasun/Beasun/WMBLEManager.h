//
//  WMBLEManager.h
//  Beasun
//
//  Created by maginawin on 15/9/8.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "WMMassagerInfo.h"

// BLE UUID
extern NSString *const kBLEManagerUUIDForService;
extern NSString *const kBLEManagerUUIDForWriteChar;
extern NSString *const kBLEManagerUUIDForNotifyChar;

// Key for noti value

extern NSString *const kBLEManagerNotiKeyPeripheral;
extern NSString *const kBLEManagerNotiKeyRSSI;
extern NSString *const kBLEManagerNotiKeyCharacteristic;

// Key for noti key

/** (CBCentralManager *)central */
extern NSString *const kBLEManagerNotiDidUpdateState;

/** @{kBLEManagerNotiKeyPeripheral : peripheral, kBLEManagerNotiKeyRSSI : RSSI} */
extern NSString *const kBLEManagerNotiDidDiscoverPeripheral;

/** @{kBLEManagerNotiKeyPeripheral : peripheral} */
extern NSString *const kBLEManagerNotiDidConnectPeripheral;

/** @{kBLEManagerNotiKeyPeripheral : peripheral} */
extern NSString *const kBLEManagerNotiDidDisconnectPeripheral;

/** @{kBLEManagerNotiKeyCharacteristic : characteristic, kBLEManagerNotiKeyPeripheral : peripheral} */
extern NSString *const kBLEManagerNotiDidUpdateValueForCharacteristic;

extern NSString *const kBLEManagerNotiDidUpdateBattery;

@interface WMBLEManager : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>

+ (WMBLEManager *)sharedInstance;

@property (strong, nonatomic) CBCentralManager *centralManager;
@property (strong, nonatomic) NSMutableDictionary *foundPeripherals;
//@property (strong, nonatomic) NSMutableArray *connectedPeripherals;
@property (strong, nonatomic) NSMutableDictionary *writeCharsDict;
// 用  Dict 来管理连接上的 Peripheral
@property (strong, nonatomic) NSMutableDictionary *connectedPeripherals;
/** 存储电量, 用 NSNumber */
@property (strong, nonatomic) NSMutableDictionary *peripheralsBattery;

/** 用来存储按摩信息 */
@property (strong, nonatomic) WMMassagerInfo *massagerInfo;

- (void)scanForPeripheralsWithServices:(NSArray *)serviceUUIDs;

- (void)stopScan;

- (void)connectPeripheral:(CBPeripheral *)peripheral;

- (void)connectPeripherals:(NSArray *)peripherals;

- (void)cancelPeripheralConnection:(CBPeripheral *)peripheral;

- (void)cancelAllPeripherals;

- (void)writeValue:(NSData *)value toPeripheral:(CBPeripheral *)peripheral withResponse:(BOOL)response;

- (void)writeValue:(NSData *)value withResponse:(BOOL)response;

#pragma mark - Data handler

/**
 * @brief 将十六进制 NSData 转换成十六进制 NSString
 * @param aData : 十六进制 NSData
 * @return 十六进制 NSString
 */
+ (NSString*)hexStringFromHexData:(NSData*)aData;

/**
 * @brief 将十六进制 NSString 转成十六进制 NSData
 * @param hexString : 十六进制 NSString
 * @return 十六进制 NSData
 */
+ (NSData*)hexDataFromHexString:(NSString*)hexString;

/**
 * @brief 将十六进制 NSString 转为 NSInteger
 * @param hexString : 十六进制 NSString
 * @return 十进制 NSInteger
 */
+ (NSInteger)integerFromHexString:(NSString*)hexString;

/** 将十六进制 NSString 转为 NSString */
/**
 * @brief 将十六进制 NSString 转为 NSString
 * @param hexString : 十六进制 NSString
 * @return 十进制 NSString
 */
+ (NSString*)stringFromHexString:(NSString*)hexString;

/**
 * @brief 将十进制 NSString 转为十六进制 NSData
 * @param aString : 十进制 NSString
 * @return 十六进制 NSData
 */
+ (NSData*)hexDataFromString:(NSString*)aString;

/**
 * @brief 将十进制 NSString 转为十六进制 NSString
 * @param aString : 十进制 NSString
 * @return 十六进制 NSString
 */
+ (NSString*)hexStringFromString:(NSString*)aString;

/**
 * @brief NSInteger 转为十六进制的 NSString
 * @param aInteger : 十进制 NSInteger
 * @return 十六进制 NSString
 */
+ (NSString*)hexStringFromInteger:(NSInteger)aInteger;

@end
