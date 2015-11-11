//
//  WMBeasunVC.m
//  Beasun
//
//  Created by maginawin on 15/8/31.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import "WMBeasunVC.h"
#import "WMBeasunZhinengVC.h"
#import "WMBeasunOtherVC.h"
#import "WMStandarMusic.h"

@interface WMBeasunVC ()

@end

@implementation WMBeasunVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureBase];
}


#pragma mark - Selector

- (IBAction)otherModeClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSInteger index = btn.tag * -1;
    
    WMBeasunOtherVC *otherVC = [[WMBeasunOtherVC alloc] initWithNibName:@"WMBeasunOtherVC" bundle:nil];
    otherVC.index = index;
    otherVC.hidesBottomBarWhenPushed = YES;
    otherVC.musicName = [WMStandarMusic standarMusicNameForIndex:otherVC.index];
    
    [self.navigationController pushViewController:otherVC animated:YES];
}

- (IBAction)zhinengClick:(id)sender {
    WMBeasunZhinengVC *zhinengVC = [WMBeasunZhinengVC beasunZhineng];

    [self.navigationController pushViewController:zhinengVC animated:YES];
}

#pragma mark - Configure

- (void)configureBase {
    //
    self.navigationItem.title = NSLocalizedString(@"nav_beason", @"");

}

@end
