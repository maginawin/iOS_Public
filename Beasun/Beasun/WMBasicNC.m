//
//  WMBasicNC.m
//  Beasun
//
//  Created by maginawin on 15/8/31.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import "WMBasicNC.h"
#import "UIColor+Beasun.h"

@interface WMBasicNC ()

@end

@implementation WMBasicNC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationBar.barTintColor = [UIColor beasunNavBarTint];
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    self.navigationBar.translucent = NO;

}

@end
