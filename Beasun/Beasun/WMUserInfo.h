//
//  WMUserInfo.h
//  Beasun
//
//  Created by maginawin on 15/9/15.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMUserInfo : NSObject

@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *mobilephoneNumber;
@property (strong, nonatomic) NSString *telephoneNumber;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *qqNumber;
@property (strong, nonatomic) NSString *wechartNumber;
@property (strong, nonatomic) NSString *address;
@property (assign, nonatomic) BOOL isLogin;

@end
