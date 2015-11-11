//
//  NSString+Beasun.m
//  Beasun
//
//  Created by maginawin on 15/9/17.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import "NSString+Beasun.h"

@implementation NSString (Beasun)

+(int)calculateTextNumber:(NSString *)textA {
    float number = 0.0;
    int index;
    for (index=0; index < [textA length]; index++) {
        
        NSString *character = [textA substringWithRange:NSMakeRange(index, 1)];
        
        if ([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3) {
            number++;
        } else {
            number = number+0.5;
        }
    }
    return ceil(number);
}

@end
