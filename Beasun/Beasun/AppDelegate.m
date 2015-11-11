//
//  AppDelegate.m
//  Beasun
//
//  Created by maginawin on 15/8/31.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import "AppDelegate.h"
#import "WMBLEManager.h"
#import "WMLoginVC.h"
#import "WMUserInfo.h"
#import "WMMusicManager.h"
#import "WMMassagerModeManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 状态栏白色
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // Init BLE
    [WMBLEManager sharedInstance];
    
    // Init Audio
    [WMMusicManager sharedInstance];
    
    // 判断是否登录
//    [self configureLogin];
    
    // Test Massager Mode Manager
//    [self testMassagerModeManager];
    
    // 睡睡
//    [NSThread sleepForTimeInterval:1.f];
    
    // BLE init
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Private

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    [[WMMusicManager sharedInstance] remoteControlReceivedWithEvent:event];
}

/** Does user had login? If not, need login, test user name is /test/ and password is /a1234/ */
- (void)configureLogin {
    WMUserInfo *userInfo = [[WMUserInfo alloc] init];
    if (!userInfo.isLogin) {
        WMLoginVC *loginVC = [[WMLoginVC alloc] initWithNibName:@"WMLoginVC" bundle:nil];
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _window.rootViewController = loginVC;
        [_window makeKeyAndVisible];
    }
}

#pragma mark - TEST

// Test Massager Mode Manager
- (void)testMassagerModeManager {
    WMMassagerMode *mode = [[WMMassagerMode alloc] init];
    mode.modeIndex = 11;
    mode.modeName = @"test mode massager 8";
    
    [WMMassagerModeManager saveOrUpdateMassagerMode:mode];
    
//    NSMutableDictionary *dict = [WMMassagerModeManager massagerModes];
//    NSLog(@"dict %@", dict);
    
}

@end
