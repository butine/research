//
//  NSMutableAttributedString+TengNiu.m
//  TengNiu
//
//  Created by YangNan on 15/4/14.
//  Copyright (c) 2015年 Teng Niu. All rights reserved.
//

#import "NSMutableAttributedString+ST.h"

@implementation NSMutableAttributedString (TengNiu)

- (void)st_setFont:(UIFont *)font {
    [self addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, self.length)];
}

- (void)st_setFont:(UIFont *)font range:(NSRange)range {
    [self addAttribute:NSFontAttributeName value:font range:range];
}

- (void)st_setSystemFont:(CGFloat)fontSize {
    [self addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize] range:NSMakeRange(0, self.length)];
}

- (void)st_setSystemFont:(CGFloat)fontSize range:(NSRange)range {
    [self addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize] range:range];
}

- (void)st_setTextColor:(UIColor *)color {
    [self addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, self.length)];
}

- (void)st_setTextColor:(UIColor *)color range:(NSRange)range {
    [self addAttribute:NSForegroundColorAttributeName value:color range:range];
}

- (void)st_setTextLineSpacing:(CGFloat)spacing
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = spacing;
    [self addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.length)];
}

- (void)st_setTextLineSpacing:(CGFloat)spacing range:(NSRange)range
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = spacing;
    [self addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
}

@end
