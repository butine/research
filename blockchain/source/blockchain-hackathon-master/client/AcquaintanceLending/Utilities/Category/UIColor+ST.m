//
//  UIColor+ST.m
//  ST
//
//  Created by YangNan on 15/4/1.
//  Copyright (c) 2015年 Teng Niu. All rights reserved.
//

#import "UIColor+ST.h"

@implementation UIColor (ST)

- (instancetype)initWithHexValue:(NSString *)hexValue
{
    CGFloat red = 1.0;
    CGFloat green = 1.0;
    CGFloat blue = 1.0;
    CGFloat alpha = 1.0;
    if (hexValue.length > 0) {
        hexValue = hexValue.uppercaseString;
        if ([hexValue hasPrefix:@"#"]) {
            hexValue = [hexValue substringFromIndex:1];
        }
        unsigned int hex;
        BOOL t = [[NSScanner scannerWithString:hexValue] scanHexInt:&hex];
        if (t) {
            unsigned char r, g, b, a = 0xff;
            if (hexValue.length > 6) {
                a = (unsigned char)(hex >> 24);
            }
            r = (unsigned char)(hex >> 16);
            g = (unsigned char)(hex >> 8);
            b = (unsigned char)(hex);
            red = (float)r / 0xff;
            green = (float)g / 0xff;
            blue = (float)b / 0xff;
            alpha = (float)a / 0xff;
        }
    }
    return [self initWithRed:red green:green blue:blue alpha:alpha];
}

+ (UIColor *)colorWithHexValue:(NSString *)hexValue {
    return [[UIColor alloc] initWithHexValue:hexValue];
}

@end
