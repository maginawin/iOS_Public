//
//  WMBasicTBC.m
//  Beasun
//
//  Created by maginawin on 15/8/31.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import "WMBasicTBC.h"
#import "UIColor+Beasun.h"

@interface WMBasicTBC ()

@end

@implementation WMBasicTBC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tabBar.tintColor = [UIColor whiteColor];
    self.tabBar.selectedImageTintColor = [UIColor whiteColor];
    self.tabBar.barTintColor = [UIColor beasunTabBarTint];
    self.tabBar.translucent = NO;
    
    NSArray *tabBarTitles = @[NSLocalizedString(@"tab_beasun", @""), NSLocalizedString(@"tab_device", @""), NSLocalizedString(@"tab_other", @"")];
    NSArray *tabBarImagesName = @[@"tab_beasun", @"tab_device", @"tab_other"];
    
    NSArray *items = self.tabBar.items;
    
    for (int i = 0; i< items.count; i++) {
        int index = i % 3;
        NSString *title = tabBarTitles[index];
        
        UITabBarItem *item = items[i];
        item.title = title;
        item.image = [UIImage imageNamed:tabBarImagesName[i]];
    }
}

@end
