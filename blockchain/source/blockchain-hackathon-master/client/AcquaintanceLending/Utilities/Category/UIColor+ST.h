//
//  UIColor+ST.h
//  ST
//
//  Created by YangNan on 15/4/1.
//  Copyright (c) 2015年 Teng Niu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ST)

/**
 *  Initializes and returns a color object using the specified hexadecimal value.
 *
 *  @param hexValue A hexadecimal value from #00000000 to #FFFFFFFF.
 *
 *  @return An initialized color object. The color information represented by this object is in the device RGB colorspace.
 */
- (instancetype)initWithHexValue:(NSString *)hexValue;
/**
 *  Initializes and returns a color object using the specified hexadecimal value.
 *
 *  @param hexValue A hexadecimal value from #00000000 to #FFFFFFFF.
 *
 *  @return An initialized color object. The color information represented by this object is in the device RGB colorspace.
 */
+ (UIColor *)colorWithHexValue:(NSString *)hexValue;

@end
