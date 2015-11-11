//
//  WMMassagerMode.m
//  Beasun
//
//  Created by maginawin on 15/9/10.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import "WMMassagerMode.h"

@implementation WMMassagerMode
//
//@synthesize modeName = _modeName;
//@synthesize modeIndex = _modeIndex;
//@synthesize modeValue = _modeValue;
//@synthesize modeMusicName = _modeMusicName;
//@synthesize modeImage = _modeImage;

- (instancetype)init {
    self = [super init];
    if (self) {
        _modeName = @"";
        _modeIndex = -100;
        _modeValue = 0x00;
        _modeMusicName = NSLocalizedString(@"choose_a_music", @"");
        _modeImage = [UIImage imageNamed:@"no_image"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_modeName forKey:@"modeName"];
    [aCoder encodeInteger:_modeIndex forKey:@"modeIndex"];
    [aCoder encodeInteger:_modeValue forKey:@"modeValue"];
    [aCoder encodeObject:_modeMusicName forKey:@"modeMusicName"];
    [aCoder encodeObject:_modeImage forKey:@"modeImage"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _modeName = [aDecoder decodeObjectForKey:@"modeName"];
        _modeIndex = [aDecoder decodeIntegerForKey:@"modeIndex"];
        _modeValue = [aDecoder decodeIntegerForKey:@"modeValue"];
        _modeMusicName = [aDecoder decodeObjectForKey:@"modeMusicName"];
        _modeImage = [aDecoder decodeObjectForKey:@"modeImage"];
    }
    return self;
}

@end
