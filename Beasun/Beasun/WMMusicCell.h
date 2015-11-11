//
//  WMMusicCell.h
//  Beasun
//
//  Created by maginawin on 15/9/16.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMMusicCell : UITableViewCell

+ (WMMusicCell *)musicCell;

@property (weak, nonatomic) IBOutlet UIImageView *mImageView;
@property (weak, nonatomic) IBOutlet UILabel *mTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *mDetailLabel;

@end
