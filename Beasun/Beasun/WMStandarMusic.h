//
//  WMStandarMusic.h
//  Beasun
//
//  Created by maginawin on 15/9/18.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMStandarMusic : NSObject

+ (NSString *)standarMusicNameForIndex:(NSInteger)index;

+ (void)saveMusicName:(NSString *)musicName atIndex:(NSInteger)index;

@end
