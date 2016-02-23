//
//  NSMutableAttributedString+ST.h
//  TengNiu
//
//  Created by YangNan on 15/4/14.
//  Copyright (c) 2015年 Teng Niu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSMutableAttributedString (TengNiu)

- (void)st_setFont:(UIFont *)font;
- (void)st_setFont:(UIFont *)font range:(NSRange)range;

- (void)st_setSystemFont:(CGFloat)fontSize;
- (void)st_setSystemFont:(CGFloat)fontSize range:(NSRange)range;

- (void)st_setTextColor:(UIColor *)color;
- (void)st_setTextColor:(UIColor *)color range:(NSRange)range;

- (void)st_setTextLineSpacing:(CGFloat)spacing;
- (void)st_setTextLineSpacing:(CGFloat)spacing range:(NSRange)range;
@end
