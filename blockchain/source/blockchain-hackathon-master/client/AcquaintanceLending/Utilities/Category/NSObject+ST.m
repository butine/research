//
//  NSObject+TengNiu.m
//  TengNiu
//
//  Created by YangNan on 15/3/20.
//  Copyright (c) 2015年 Teng Niu. All rights reserved.
//

#import "NSObject+ST.h"
#import <objc/runtime.h>

@implementation NSObject (TengNiu)

+ (void)swizzleMethod:(SEL)originMethod newMethod:(SEL)newMethod {
//#if DEBUG
    Method _origin = class_getInstanceMethod(self, originMethod);
    Method _new = class_getInstanceMethod(self, newMethod);
    if (_origin && _new) {
        IMP temp = method_getImplementation(_origin);
        method_setImplementation(_origin, method_getImplementation(_new));
        method_setImplementation(_new, temp);
    }
//#endif
}

@end
