//
//  NSObject+ST.h
//  TengNiu
//
//  Created by YangNan on 15/3/20.
//  Copyright (c) 2015年 Teng Niu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (TengNiu)

+ (void)swizzleMethod:(SEL)originMethod newMethod:(SEL)newMethod;

@end
