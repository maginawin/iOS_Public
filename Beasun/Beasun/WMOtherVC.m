//
//  WMOtherVC.m
//  Beasun
//
//  Created by maginawin on 15/8/31.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import "WMOtherVC.h"

NSString *const kOtherVCCellId = @"idOtherVCCell";

@interface WMOtherVC () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@end

@implementation WMOtherVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureBase];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: {
            return 1;
        }
        case 1: {
            return 2;
        }
        case 2: {
            return 1;
        }
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kOtherVCCellId];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kOtherVCCellId];
    }
    
    int actualRow = 0;
    
    if (indexPath.section == 1) {
        actualRow = 1 + (int)indexPath.row;
    } else if (indexPath.section == 2) {
        actualRow = 3;
    }
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
    NSString *imageName = [NSString stringWithFormat:@"%@%d", @"other_cell_img", actualRow];
    imageView.image = [UIImage imageNamed:imageName];    
    
    UILabel *textLabel = (UILabel *)[cell viewWithTag:2];
    NSString *textLocal = [NSString stringWithFormat:@"%@%d", @"other_cell_text", actualRow];
    textLabel.text = NSLocalizedString(textLocal, @"");
    
    return cell;
}

#pragma mark - Configure

- (void)configureBase {
    //
    self.navigationItem.title = NSLocalizedString(@"nav_other", @"");
    
    // TableView
    _mTableView.dataSource = self;
    _mTableView.delegate = self;
}

@end
