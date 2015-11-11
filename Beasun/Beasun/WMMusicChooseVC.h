//
//  WMMusicChooseVC.h
//  Beasun
//
//  Created by maginawin on 15/9/16.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WMMusicChooseVCDelegate <NSObject>

@required

- (void)musicChooseVCChooseMusicName:(NSString *)musicName;

@end

@interface WMMusicChooseVC : UIViewController

@property (strong, nonatomic) NSString *musicName;

@property (weak, nonatomic) id<WMMusicChooseVCDelegate> delegate;

@end
