//
//  WMPeripheral.h
//  Beasun
//
//  Created by maginawin on 15/9/6.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMPeripheral : NSObject <NSCoding>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *uuidString;

@end
