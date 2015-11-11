//
//  WMBeasunZhinengVC.m
//  Beasun
//
//  Created by maginawin on 15/8/31.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import "WMBeasunZhinengVC.h"
#import "WMBeasunZhinengCVCell.h"
#import "WMJingDianVC.h"
#import "WMBeasunOtherVC.h"
#import "WMCustomModeVC.h"
#import "WMMassagerModeManager.h"
#import "WMStandarMusic.h"

static NSString *kBeasunZhinengVCCVCellId = @"idBeasunZhinengVCCVCell";

@interface WMBeasunZhinengVC () <UICollectionViewDataSource, UICollectionViewDelegate, WMCustomModeVCDelegate, WMBeasunZhinengVCCellDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *mCollectionView;

@property (strong, nonatomic) NSMutableArray *modes;
@property (strong, nonatomic) NSIndexPath *indexPath;

@end

@implementation WMBeasunZhinengVC

+ (WMBeasunZhinengVC *)beasunZhineng {
    WMBeasunZhinengVC *zhinengVC = [[WMBeasunZhinengVC alloc] initWithNibName:@"WMBeasunZhinengVC" bundle:nil];
    
    return zhinengVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureBase];
}

#pragma mark - WMBeasunZhinengVCCellDelegate

- (void)beasunZhinengVCCell:(WMBeasunZhinengCVCell *)cell didLongPressAtIndex:(NSIndexPath *)indexPath {
    if (_modes.count > 10) {
        _indexPath = indexPath;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"sure_delete_mode", @"") message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"") otherButtonTitles:NSLocalizedString(@"confirm", @""), nil];
        alert.alertViewStyle = UIAlertViewStyleDefault;
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 1: {
            if (_indexPath) {
                // This cell is custom mode cell
                if (_indexPath.row > 10 && _indexPath.row != _modes.count + 1) {
                    [_modes removeObjectAtIndex:_indexPath.row - 1];
                    [WMMassagerModeManager delegateMassagerModeAtIndex:_indexPath.row];
                    [_mCollectionView reloadData];
                }
            }
            break;
        }
    }
}

#pragma mark - WMCustomModeVCDelegate

- (void)customModeVCDidModeChanged {
//    dispatch_async(dispatch_get_main_queue(), ^ {
        [self updateDatabase];
        
        [_mCollectionView reloadData];
//    });
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _modes.count + 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WMBeasunZhinengCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBeasunZhinengVCCVCellId forIndexPath:indexPath];
    [cell configureLongPressGesture];
    cell.backgroundColor = [UIColor clearColor];
    cell.indexPath = indexPath;
    cell.delegate = self;
    
    const NSInteger maxRow = _modes.count + 1;
    
    NSString *imageString = @"beasun_cell11";
    NSString *textString = @"";
    
    if (maxRow > 11) {
        if (indexPath.row < 11) {
            imageString = [NSString stringWithFormat:@"beasun_cell%d", (int)indexPath.row];
            NSString *cellString = [NSString stringWithFormat:@"cell_%d", (int)indexPath.row];
            textString = NSLocalizedString(cellString, @"");
            cell.textLabel.hidden = NO;
            //        cell.mode = [_modes[indexPath.row - 1] integerValue];
            
            cell.imageView.image = [UIImage imageNamed:imageString];
            cell.textLabel.text = textString;
        } else if (indexPath.row >= 11 && indexPath.row != maxRow) {
            WMMassagerMode *mode = [_modes objectAtIndex:indexPath.row - 1];
            
            if (mode) {
                cell.textLabel.text = mode.modeName;
                cell.imageView.image = mode.modeImage;
            }            
            
        } else if (indexPath.row == maxRow) {
            textString = @"添加";
            cell.textLabel.hidden = YES;
            
            cell.imageView.image = [UIImage imageNamed:imageString];
            cell.textLabel.text = textString;
        }
    } else if (maxRow == 11) {
        if (indexPath.row < 11) {
            imageString = [NSString stringWithFormat:@"beasun_cell%d", (int)indexPath.row];
            NSString *cellString = [NSString stringWithFormat:@"cell_%d", (int)indexPath.row];
            textString = NSLocalizedString(cellString, @"");
            cell.textLabel.hidden = NO;
            //        cell.mode = [_modes[indexPath.row - 1] integerValue];
        } else if (indexPath.row == maxRow) {
            
            textString = @"添加";
            cell.textLabel.hidden = YES;
        }
        
        cell.imageView.image = [UIImage imageNamed:imageString];
        cell.textLabel.text = textString;
    }

    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(96.f, 96.f);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(4, 4, 4, 4);
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"did selecte item at index %d", (int)indexPath.row);
    
    NSInteger maxRow = _modes.count + 1;
    
    // Jindian mode
    if (indexPath.row == 0) {
        WMJingDianVC *jingdianVC = [[WMJingDianVC alloc] initWithNibName:@"WMJingDianVC" bundle:nil];
        jingdianVC.hidesBottomBarWhenPushed = YES;
        jingdianVC.index = 0;
        jingdianVC.musicName = [WMStandarMusic standarMusicNameForIndex:0];
        [self.navigationController pushViewController:jingdianVC animated:YES];
    }
    // Add new mode
    else if (indexPath.row == maxRow) {
        WMCustomModeVC *customModeVC = [[WMCustomModeVC alloc] initWithNibName:@"WMCustomModeVC" bundle:nil];
        customModeVC.hidesBottomBarWhenPushed = YES;
        WMMassagerMode *mode = [[WMMassagerMode alloc] init];
        mode.modeIndex = indexPath.row;
        customModeVC.mode = mode;
        customModeVC.delegate = self;
        [self.navigationController pushViewController:customModeVC animated:YES];
    }
    // Standar mode
    else if (indexPath.row > 0 && indexPath.row < 11) {
        WMBeasunOtherVC *otherVC = [[WMBeasunOtherVC alloc] initWithNibName:@"WMBeasunOtherVC" bundle:nil];
        otherVC.index = indexPath.row;
        otherVC.hidesBottomBarWhenPushed = YES;
        otherVC.musicName = [WMStandarMusic standarMusicNameForIndex:otherVC.index];
        
        [self.navigationController pushViewController:otherVC animated:YES];
    }
    // Custom mode
    else {
        WMBeasunOtherVC *otherVC = [[WMBeasunOtherVC alloc] initWithNibName:@"WMBeasunOtherVC" bundle:nil];
        otherVC.index = indexPath.row;
        otherVC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:otherVC animated:YES];
    }
    
//    switch (indexPath.row) {
//            // 经典模式
//        case 0: {
//            WMJingDianVC *jingdianVC = [[WMJingDianVC alloc] initWithNibName:@"WMJingDianVC" bundle:nil];
//            jingdianVC.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:jingdianVC animated:YES];
//            break;
//        }
//#warning Must changed to the last index
//            // 添加模式
//        case maxRow: {
//            WMCustomModeVC *customModeVC = [[WMCustomModeVC alloc] initWithNibName:@"WMCustomModeVC" bundle:nil];
//            customModeVC.hidesBottomBarWhenPushed = YES;
//            customModeVC.mode.modeIndex = indexPath.row;
//            [self.navigationController pushViewController:customModeVC animated:YES];
//            break;
//        }
//            
//        default: {
////            WMBeasunZhinengCVCell *cell = (WMBeasunZhinengCVCell *)[collectionView cellForItemAtIndexPath:indexPath];
////            NSString *title = cell.textLabel.text;
//            
//            WMBeasunOtherVC *otherVC = [[WMBeasunOtherVC alloc] initWithNibName:@"WMBeasunOtherVC" bundle:nil];
//            otherVC.index = indexPath.row;
//            otherVC.hidesBottomBarWhenPushed = YES;
//            
//            [self.navigationController pushViewController:otherVC animated:YES];
//            
//            break;
//        }
//    }
}

#pragma mark - Configure

- (void)updateDatabase {
    
    if (_modes) {
        [_modes removeAllObjects];
    } else {
        _modes = [NSMutableArray array];
    }
    
    NSArray* standarModes = [WMBLEHelper bleHelperModes];
    [_modes addObjectsFromArray:standarModes];
    
    NSArray *customModes = [WMMassagerModeManager massagerModesArray];
    if (customModes.count > 0) {
        [_modes addObjectsFromArray:customModes];
    }
}

- (void)configureBase {
    self.navigationItem.title = NSLocalizedString(@"zhineng_anmo", @"");
    
    [self updateDatabase];
    
    _mCollectionView.dataSource = self;
    _mCollectionView.delegate = self;
    
    //    [_mCollectionView registerClass:WMBeasunZhinengCVCell.class forCellWithReuseIdentifier:kBeasunZhinengVCCVCellId];
    [_mCollectionView registerNib:[UINib nibWithNibName:@"WMBeasunZhinengCVCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kBeasunZhinengVCCVCellId];
    //    _mCollectionView.backgroundColor = [UIColor whiteColor];    
    
}

@end
