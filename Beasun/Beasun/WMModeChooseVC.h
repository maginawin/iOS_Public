//
//  WMModeChooseVC.h
//  Beasun
//
//  Created by maginawin on 15/9/18.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WMModeChooseVCDelegate <NSObject>

@optional

- (void)modeChooseVCSavedModeValue:(NSUInteger)modeValue;

@end

@interface WMModeChooseVC : UIViewController

@property (weak, nonatomic) id<WMModeChooseVCDelegate> delegate;

@property (assign, nonatomic) NSUInteger modeValue;

@end
