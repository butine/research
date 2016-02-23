//
//  UIView+ST.m
//  ST
//
//  Created by YangNan on 15/3/25.
//  Copyright (c) 2015年 Teng Niu. All rights reserved.
//

#import "UIView+ST.h"

const void* managesKeyboardItselfKey = &managesKeyboardItselfKey;

@implementation UIView (ST)

+ (NSString *)identifier {
    return NSStringFromClass(self);
}

+ (UINib *)nibFromIdentifier {
    return [UINib nibWithNibName:[self identifier] bundle:nil];
}

+ (instancetype)viewFromNib {
    UINib* nib = [self nibFromIdentifier];
    return [nib instantiateWithOwner:nil options:nil].firstObject;
}

- (CGFloat)height {
    return 0;
}

- (UIImage *)takeSnapshot {
    UIGraphicsBeginImageContext(self.bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:context];
    UIImage* tempImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tempImage;
}

@end
