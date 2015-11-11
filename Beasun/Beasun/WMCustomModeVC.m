//
//  WMCustomModeVC.m
//  Beasun
//
//  Created by maginawin on 15/9/17.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import "WMCustomModeVC.h"
#import "WMMusicChooseVC.h"
#import "NJImageCropperViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "NSString+Beasun.h"
#import "WMModeChooseVC.h"
#import "WMMassagerModeManager.h"

const float kCustomModeImageCornerRadius = 4.f;
NSString *const kCustomModeCellId = @"kCustomModeCellId";

@interface WMCustomModeVC () <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NJImageCropperDelegate, WMMusicChooseVCDelegate, WMModeChooseVCDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *mImageView;
@property (weak, nonatomic) IBOutlet UITextField *mTextField;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@property (strong, nonatomic) NSArray *modesName2;


@end

@implementation WMCustomModeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureBase];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (IBAction)textFieldDidEndOnExit:(id)sender {
    NSString *text = _mTextField.text;
    _mTextField.text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSUInteger length = [NSString calculateTextNumber:text];
    
    if (length > 6) {
        // Over 12 letter, show a alert
        [self showAlertMessage:NSLocalizedString(@"more_than_12_letter", @"")];
        return;
    }
    
    // More than 1 letter, save mode name
    if (length > 0) {
        _mode.modeName = _mTextField.text;
    }
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
            // Mode choose
        case 0: {
            WMModeChooseVC *modeChooseVC = [[WMModeChooseVC alloc] initWithNibName:@"WMModeChooseVC" bundle:nil];
            modeChooseVC.modeValue = _mode.modeValue;
            modeChooseVC.delegate = self;
            [self.navigationController pushViewController:modeChooseVC animated:YES];
            
            break;
        }
            // Music choose
        case 1: {
            WMMusicChooseVC *musicChooseVC = [[WMMusicChooseVC alloc] initWithNibName:@"WMMusicChooseVC" bundle:nil];
            musicChooseVC.delegate = self;
            [self.navigationController pushViewController:musicChooseVC animated:YES];
            break;
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return NSLocalizedString(@"mode", @"");
        default:
            return NSLocalizedString(@"music", @"");
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCustomModeCellId];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCustomModeCellId];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    switch (indexPath.section) {
            // Mode
        case 0: {
//            cell.textLabel.minimumScaleFactor = 9.f;
//            cell.textLabel.font = [UIFont systemFontOfSize:16.f];
            cell.textLabel.adjustsFontSizeToFitWidth = YES;
            cell.textLabel.text = [self modeStringFromMutableMode];
            break;
        }
            // Music
        case 1: {
            cell.textLabel.text = _mode.modeMusicName;
            break;
        }
    }
    
    return cell;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // 裁剪
        NJImageCropperViewController *imgEditorVC = [[NJImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^ {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }];
}

#pragma mark - WMModeChooseVCDelegate

- (void)modeChooseVCSavedModeValue:(NSUInteger)modeValue {
    _mode.modeValue = modeValue;
    
    [_mTableView reloadData];
}

#pragma mark- WMMusicChooseVCDelegate

- (void)musicChooseVCChooseMusicName:(NSString *)musicName {
    _mode.modeMusicName = musicName;
    
    [_mTableView reloadData];
}

#pragma mark - NJImageCropperDelegate

- (void)imageCropper:(NJImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    _mode.modeImage = editedImage;
    _mImageView.image = editedImage;
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
}

- (void)imageCropperDidCancel:(NJImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}


#pragma mark - Selecotr

// Save this custom mode
- (void)rightBarButtonItemClick:(UIBarButtonItem *)sender {
    
    // Judge Name available
    NSString *text = _mTextField.text;
    _mTextField.text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSUInteger length = [NSString calculateTextNumber:text];
    
    if (length == 0) {
        [self showAlertMessage:NSLocalizedString(@"name_not_empty", @"")];
        return;
    }
    
    if (length > 6) {
        [self showAlertMessage:NSLocalizedString(@"more_than_12_letter", @"")];
        return;
    }
    
    // Judge Mode available
    if (_mode.modeValue == 0x00) {
        [self showAlertMessage:NSLocalizedString(@"at_least_one_mode", @"")];
        return;
    }
    
    _mode.modeName = _mTextField.text;
    
    // If mode has Name and Mode, can save it
    [WMMassagerModeManager saveOrUpdateMassagerMode:_mode];
    
    if ([_delegate respondsToSelector:@selector(customModeVCDidModeChanged)]) {
        [_delegate customModeVCDidModeChanged];
    }
    
    NSLog(@"save mode success %@", _mode);
    
    [self.navigationController popViewControllerAnimated:YES];
}

// Choose Image Click
- (void)tapImageView:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^ {
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
            pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [NSMutableArray array];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            pickerController.mediaTypes = mediaTypes;
            pickerController.delegate = self;
            
            [self presentViewController:pickerController animated:YES completion:^ {}];
        }
    });
}

#pragma mark - Private



- (NSString *)modeStringFromMutableMode {
    NSMutableString *modeString = [NSMutableString string];
    for (int i = 0; i < 10; i++) {
        int j = i;
        if (i > 2) {
            j += 6;
        }
        int tag = 0x01 << j;
        BOOL isSelected = (_mode.modeValue & tag) == tag ? YES : NO;
        if (isSelected) {
            [modeString appendFormat:@"%@ ", _modesName2[i]];
        }
    }
    
    if (modeString.length == 0) {
        return NSLocalizedString(@"choose_actions", @"");
    }
    
    return modeString;
}


- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}

- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < 640) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = 640;
        btWidth = sourceImage.size.width * (640 / sourceImage.size.height);
    } else {
        btWidth = 640;
        btHeight = sourceImage.size.height * (640 / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)configureBase {
    // Localizable
    _mTextField.placeholder = NSLocalizedString(@"enter_a_name", @"");
    self.navigationItem.title = NSLocalizedString(@"add_mode", @"");
    
    _modesName2 = @[NSLocalizedString(@"shoushen", @""), NSLocalizedString(@"qinfu", @""), NSLocalizedString(@"jinzhui", @""), NSLocalizedString(@"rounie", @""), NSLocalizedString(@"tuina", @""), NSLocalizedString(@"chuiji", @""), NSLocalizedString(@"guasha", @""), NSLocalizedString(@"zhenjiu", @""), NSLocalizedString(@"zhiya", @""), NSLocalizedString(@"huoguan", @"")];
    
    // Mode Info Set
    [self configureMode];
    
    // Right Button Item In Navigation Bar
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(rightBarButtonItemClick:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    // Image View
    _mImageView.layer.cornerRadius = 4.f;
    _mImageView.layer.masksToBounds = YES;
    _mImageView.userInteractionEnabled = YES;
    _mImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _mImageView.layer.borderWidth = 2.f;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
    [tap setNumberOfTapsRequired:1];
    [_mImageView addGestureRecognizer:tap];
    
    // Table View
    _mTableView.dataSource = self;
    _mTableView.delegate = self;

}

- (void)configureMode {
    if (!_mode) {
        _mode = [[WMMassagerMode alloc] init];
    }
    
    _mImageView.image = _mode.modeImage;
    _mTextField.text = _mode.modeName;
    
}

- (void)showAlertMessage:(NSString *)msg {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:msg message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"confirm", @"") otherButtonTitles:nil, nil];
    alert.alertViewStyle = UIAlertViewStyleDefault;
    [alert show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
