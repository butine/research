//
//  BasicUtility+BarButtonItem.h
//  TengNiu
//
//  Created by 李晓春 on 15/4/21.
//  Copyright (c) 2015年 Teng Niu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasicUtility.h"

@interface BasicUtility (BarButtonItem)

- (void)setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem navItem:(UINavigationItem*)navItem;
- (void)setLeftBarButtonItems:(NSArray *)leftBarButtonItems navItem:(UINavigationItem*)navItem;

- (void)setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem navItem:(UINavigationItem*)navItem;
- (void)setRightBarButtonItems:(NSArray *)rightBarButtonItems navItem:(UINavigationItem*)navItem;

@end
