//
//  WMPeripheral.m
//  Beasun
//
//  Created by maginawin on 15/9/6.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import "WMPeripheral.h"

@implementation WMPeripheral

@synthesize name;
@synthesize uuidString;

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:name forKey:@"name"];
    [aCoder encodeObject:uuidString forKey:@"uuidString"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.uuidString = [aDecoder decodeObjectForKey:@"uuidString"];
    }
    return self;
}

@end
