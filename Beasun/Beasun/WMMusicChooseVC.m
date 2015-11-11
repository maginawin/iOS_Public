//
//  WMMusicChooseVC.m
//  Beasun
//
//  Created by maginawin on 15/9/16.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import "WMMusicChooseVC.h"
#import "WMMusicCell.h"
#import "WMMusicManager.h"
#import "UIColor+Beasun.h"

NSString *const kMusicChooseCell = @"kMusicChooseCell";

@interface WMMusicChooseVC () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mTableView;


@end

@implementation WMMusicChooseVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureBase];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[WMMusicManager sharedInstance] stopMusic];
}

#pragma mark - Selector

- (void)rightBBIClicksd {
    
    if ([_delegate respondsToSelector:@selector(musicChooseVCChooseMusicName:)]) {
        [_delegate musicChooseVCChooseMusicName:_musicName];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WMMusicObject *music = [[WMMusicManager sharedInstance] musicArrayFromDict][indexPath.row];
    
    if (music.name) {
        [[WMMusicManager sharedInstance] playMusicNamed:music.name];
        _musicName = music.name;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 60.f;
    
    if ([[WMMusicManager sharedInstance] musicArrayFromDict].count > 0) {
        height = 0;
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[WMMusicManager sharedInstance] musicArrayFromDict].count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *title = NSLocalizedString(@"no_content", @"");
    CGFloat height = 60.f;
    
    if ([[WMMusicManager sharedInstance] musicArrayFromDict].count > 0) {
        title = @"";
        height = 0.f;
        return nil;
    }
    
    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), height)];
    header.backgroundColor = [UIColor clearColor];
    header.text = title;
    header.textColor = [UIColor darkGrayColor];
    header.font = [UIFont systemFontOfSize:15.f];
    header.textAlignment = NSTextAlignmentCenter;
    header.numberOfLines = 0;
    
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WMMusicCell *cell = [tableView dequeueReusableCellWithIdentifier:kMusicChooseCell];
    
    if (!cell) {
        cell = [WMMusicCell musicCell];
    }
    
    if (indexPath.row < [[WMMusicManager sharedInstance] musicArrayFromDict].count) {
        WMMusicObject *music = [[WMMusicManager sharedInstance] musicArrayFromDict][indexPath.row];
        cell.mImageView.image = music.image;
        cell.mTextLabel.text = music.name;
        cell.mDetailLabel.text = music.artist;
    }

    return cell;
}

#pragma mark - Private

- (void)configureBase {
    // Localization
    self.navigationItem.title = NSLocalizedString(@"choose_a_music", @"");   
    
    _musicName = NSLocalizedString(@"choose_a_music", @"");
    
    // Right Item in navigation
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(rightBBIClicksd)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;

    
    // Conf Table View
    _mTableView.delegate = self;
    _mTableView.dataSource = self;
    _mTableView.tableFooterView = [[UIView alloc] init];
    _mTableView.backgroundColor = [UIColor beasunTableViewBackground];
}

@end
