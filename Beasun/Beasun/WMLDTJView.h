//
//  WMLDTJView.h
//  Beasun
//
//  Created by maginawin on 15/9/9.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WMLDTJViewDelegate <NSObject>

@optional

- (void)ldtjViewUpdateSelectedIndex:(NSInteger)selectedIndex;

@end

@interface WMLDTJView : UIView

@property (assign, nonatomic, setter=updateSelectedIndex:) NSInteger selectedIndex;

@property (weak, nonatomic) id<WMLDTJViewDelegate> delegate;

@end
