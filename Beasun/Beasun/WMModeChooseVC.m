//
//  WMModeChooseVC.m
//  Beasun
//
//  Created by maginawin on 15/9/18.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import "WMModeChooseVC.h"
#import "UIColor+Beasun.h"

NSString *const kModeChooseVCCell = @"kModeChooseVCCell";

@interface WMModeChooseVC () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (strong, nonatomic) NSArray *modesName;

@end

@implementation WMModeChooseVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureBase];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self updateSelectedAtIndex:indexPath.row fromModeValue:_modeValue];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _modesName.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kModeChooseVCCell];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kModeChooseVCCell];
    }
    
    BOOL isSelected = [self isRowSelectedAtIndex:indexPath.row fromModeValue:_modeValue];
    
    cell.textLabel.text = _modesName[indexPath.row];
    cell.accessoryType = isSelected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    
    return cell;
}

#pragma mark - Selector

- (void)rightItemClick {
    if (_modeValue == 0x00) {
        // Alert
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"at_least_one_mode", @"") message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"confirm", @"") otherButtonTitles:nil, nil];
        alert.alertViewStyle = UIAlertViewStyleDefault;
        [alert show];
        
        return;
    }
    
    if ([_delegate respondsToSelector:@selector(modeChooseVCSavedModeValue:)]) {
        [_delegate modeChooseVCSavedModeValue:_modeValue];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

// Mode choose value changed, if index is 0 show Basic Actions otherwise show Scene Actions
//- (void)segmentedControlValueChanged:(UISegmentedControl *)sender {
//    switch (sender.selectedSegmentIndex) {
//            // Basic Actions
//        case 0: {
//        
//            break;
//        }
//            // Secne Actions
//        case 1: {
//        
//        
//            break;
//        }
//    }
//}


#pragma mark - Private

// Judged row index is selected at move value
- (BOOL)isRowSelectedAtIndex:(NSInteger)index fromModeValue:(NSUInteger)modeValue {
    if (index > 2) { index += 6; }
    
    int tag = 0x0001 << (uint)index;
    BOOL result = (modeValue & tag) == tag ? YES : NO;
    return result;
}

// Update selected at index, if YES will update to NO and NO to YES
- (void)updateSelectedAtIndex:(NSInteger)index fromModeValue:(NSUInteger)modeValue {
    if (index > 2) { index += 6; }
    
    uint tag = 0x0001 << (uint)index;
    _modeValue = tag ^ modeValue;
    
    [_mTableView reloadData];
}

- (void)configureBase {
    // Add SegmentedControl for Basic Actions and Scene Actions
//    if (self.navigationItem) {
//        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0, 7, 160, 30)];
//        [segmentedControl insertSegmentWithTitle:NSLocalizedString(@"basic_actions", @"") atIndex:0 animated:NO];
//        [segmentedControl insertSegmentWithTitle:NSLocalizedString(@"scene_actions", @"") atIndex:1 animated:NO];
//        [segmentedControl setTintColor:[UIColor whiteColor]];
//        [segmentedControl setSelectedSegmentIndex:0];
//        [segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
//        self.navigationItem.titleView = segmentedControl;
//    }
    
    // Localizable
    self.navigationItem.title = NSLocalizedString(@"choose_actions", @"");
    
    // Modes Name Init
//    "qinfu_anmo" = "轻抚按摩";
//    "rounie_anmo" = "揉捏按摩";
//    "zhenjiu_anmo" = "针灸按摩";
//    "tuina_anmo" = "推拿按摩";
//    "chuiji_anmo" = "锤击按摩";
//    "guasha_anmo" = "刮痧按摩";
//    "zhiya_anmo" = "指压按摩";
//    "jinzhui_anmo" = "颈椎按摩";
//    "shoushen_anmo" = "瘦身按摩";
//    "huoguan_anmo" = "火罐按摩";
    _modesName = @[NSLocalizedString(@"shoushen_anmo", @""), NSLocalizedString(@"qinfu_anmo", @""), NSLocalizedString(@"jinzhui_anmo", @""), NSLocalizedString(@"rounie_anmo", @""), NSLocalizedString(@"tuina_anmo", @""), NSLocalizedString(@"chuiji_anmo", @""), NSLocalizedString(@"guasha_anmo", @""), NSLocalizedString(@"zhenjiu_anmo", @""), NSLocalizedString(@"zhiya_anmo", @""), NSLocalizedString(@"huoguan_anmo", @"")];
    
//    _modeValue = 0x0000;
    
    // Navigation
    // Right BarButtonItem
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(rightItemClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    // Table View
    _mTableView.delegate = self;
    _mTableView.dataSource = self;
    _mTableView.tableFooterView = [[UIView alloc] init];
    _mTableView.tintColor = [UIColor beasunNavSwitchSelectedColor];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
