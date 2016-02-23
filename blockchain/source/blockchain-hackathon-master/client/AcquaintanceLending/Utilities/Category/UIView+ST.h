//
//  UIView+ST.h
//  ST
//
//  Created by YangNan on 15/3/25.
//  Copyright (c) 2015年 Teng Niu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ST)

//Create
+ (NSString *)identifier;
+ (UINib *)nibFromIdentifier;
+ (instancetype)viewFromNib;

- (CGFloat)height;

- (UIImage *)takeSnapshot;

@end
