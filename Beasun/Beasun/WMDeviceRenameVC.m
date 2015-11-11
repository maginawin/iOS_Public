//
//  WMDeviceRenameVC.m
//  Beasun
//
//  Created by maginawin on 15/9/7.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import "WMDeviceRenameVC.h"
#import "WMDeviceRenameCell.h"
#import "UIColor+Beasun.h"
#import "WMSavedPeripheral.h"

@interface WMDeviceRenameVC () <UITableViewDataSource, UITableViewDelegate, WMDeviceRenameCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@property (strong, nonatomic) WMPeripheral *mPeripheral;

@end

@implementation WMDeviceRenameVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureBase];
}

#pragma mark - WMDeviceRenameCellDelegate

- (void)deviceRenameCell:(WMDeviceRenameCell *)cell didEndTextField:(UITextField *)textField {
    NSString *text = textField.text;
    
    if (text.length > 0) {
        if (text.length > 10) {
            text = [text substringToIndex:10];
        }
        
        // Save
        if (_mPeripheral) {
            _mPeripheral.name = text;
            [WMSavedPeripheral alterPeripheral:_mPeripheral];
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
//
- (void)deviceRenameCell:(WMDeviceRenameCell *)cell changedTextField:(UITextField *)textField {
//    NSString *text = textField.text;
//    
//    if (text.length == 1) {
//        text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    }
//    
//    textField.text = text;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56.f;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return @"1 ~ 10";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WMDeviceRenameCell *cell = [WMDeviceRenameCell deviceRenameCellWithPeripheral:_mPeripheral];
    
    cell.delegate = self;
    
    return cell;
}


#pragma mark - Private

- (void)configureBase {
    // Nav
    self.navigationItem.title = NSLocalizedString(@"nav_rename", @"");
    
    // TableView
    _mTableView.delegate = self;
    _mTableView.dataSource = self;
    _mTableView.backgroundColor = [UIColor beasunTableViewBackground];
    
    if (_indexPath) {
        _mPeripheral = [[WMSavedPeripheral savedPeripheral] objectAtIndex:_indexPath.row];
    }
    

}

@end
