//
//  WMUserInfo.m
//  Beasun
//
//  Created by maginawin on 15/9/15.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import "WMUserInfo.h"

NSString *const kUserInfoUserName = @"kUserInfoUserName";
NSString *const kUserInfoPassword = @"kUserInfoPassword";
NSString *const kUserInfoMobilePhoneNumber = @"kUserInfoMobilePhoneNumber";
NSString *const kUserInfoTelephoneNumber = @"kUserInfoTelephoneNumber";
NSString *const kUserInfoEmail = @"kUserInfoEmail";
NSString *const kUserInfoQQNumber = @"kUserInfoQQNumber";
NSString *const kUserInfoWechatNumber = @"kUserInfoWechatNumber";
NSString *const kUserInfoAddress = @"kUserInfoAddress";
NSString *const kUserInfoIsLogin = @"kUserInfoIsLogin";

@implementation WMUserInfo

- (NSString *)userName {
    NSString *value = [[NSUserDefaults standardUserDefaults] stringForKey:kUserInfoUserName];
    if (!value) {
        value = @"";
    }
    return value;
}

- (void)setUserName:(NSString *)userName {
    [[NSUserDefaults standardUserDefaults] setValue:userName forKey:kUserInfoUserName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)password {
    NSString *value = [[NSUserDefaults standardUserDefaults] stringForKey:kUserInfoPassword];
    if (!value) {
        value = @"";
    }
    return value;
}

- (void)setPassword:(NSString *)password {
    [[NSUserDefaults standardUserDefaults] setValue:password forKey:kUserInfoPassword];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)mobilephoneNumber {
    NSString *value = [[NSUserDefaults standardUserDefaults] stringForKey:kUserInfoMobilePhoneNumber];
    if (!value) {
        value = @"";
    }
    return value;
}

- (void)setMobilephoneNumber:(NSString *)mobilephoneNumber {
    [[NSUserDefaults standardUserDefaults] setValue:mobilephoneNumber forKey:kUserInfoMobilePhoneNumber];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)telephoneNumber {
    NSString *value = [[NSUserDefaults standardUserDefaults] stringForKey:kUserInfoTelephoneNumber];
    if (!value) {
        value = @"";
    }
    return value;
}

- (void)setTelephoneNumber:(NSString *)telephoneNumber {
    [[NSUserDefaults standardUserDefaults] setValue:telephoneNumber forKey:kUserInfoTelephoneNumber];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)email {
    NSString *value = [[NSUserDefaults standardUserDefaults] stringForKey:kUserInfoEmail];
    if (!value) {
        value = @"";
    }
    return value;
}

- (void)setEmail:(NSString *)email {
    [[NSUserDefaults standardUserDefaults] setValue:email forKey:kUserInfoEmail];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)qqNumber {
    NSString *value = [[NSUserDefaults standardUserDefaults] stringForKey:kUserInfoQQNumber];
    if (!value) {
        value = @"";
    }
    return value;
}

- (void)setQqNumber:(NSString *)qqNumber {
    [[NSUserDefaults standardUserDefaults] setValue:qqNumber forKey:kUserInfoQQNumber];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)wechartNumber {
    NSString *value = [[NSUserDefaults standardUserDefaults] stringForKey:kUserInfoWechatNumber];
    if (!value) {
        value = @"";
    }
    return value;
}

- (void)setWechartNumber:(NSString *)wechartNumber {
    [[NSUserDefaults standardUserDefaults] setValue:wechartNumber forKey:kUserInfoWechatNumber];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)address {
    NSString *value = [[NSUserDefaults standardUserDefaults] stringForKey:kUserInfoAddress];
    if (!value) {
        value = @"";
    }
    return value;
}

- (void)setAddress:(NSString *)address {
    [[NSUserDefaults standardUserDefaults] setValue:address forKey:kUserInfoAddress];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isLogin {
    BOOL value = [[NSUserDefaults standardUserDefaults] boolForKey:kUserInfoIsLogin];
    return value;
}

- (void)setIsLogin:(BOOL)isLogin {
    [[NSUserDefaults standardUserDefaults] setBool:isLogin forKey:kUserInfoIsLogin];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
