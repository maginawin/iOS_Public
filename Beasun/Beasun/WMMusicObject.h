//
//  WMMusicObject.h
//  MyWatch150812
//
//  Created by wangwendong on 15/8/23.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIImage;

@interface WMMusicObject : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) NSString *artist;
@property (strong, nonatomic) UIImage *image;

@end
