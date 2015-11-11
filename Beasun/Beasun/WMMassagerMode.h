//
//  WMMassagerMode.h
//  Beasun
//
//  Created by maginawin on 15/9/10.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WMMassagerMode : NSObject <NSCoding>

@property (strong, nonatomic) NSString *modeName;
@property (assign, nonatomic) NSInteger modeIndex;
@property (assign, nonatomic) NSInteger modeValue;
@property (strong, nonatomic) NSString *modeMusicName;
//@property (strong, nonatomic) WMMusicObject *modeMusic;
@property (strong, nonatomic) UIImage *modeImage;

@end
