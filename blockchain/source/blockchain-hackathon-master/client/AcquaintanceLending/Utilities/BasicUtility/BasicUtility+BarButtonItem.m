//
//  BasicUtility+BarButtonItem.m
//  TengNiu
//
//  Created by 李晓春 on 15/4/21.
//  Copyright (c) 2015年 Teng Niu. All rights reserved.
//

#import "BasicUtility+BarButtonItem.h"

@implementation BasicUtility (BarButtonItem)

- (BOOL)isIOS7
{
    return ([[[UIDevice currentDevice] systemVersion] compare:@"7" options:NSNumericSearch] != NSOrderedAscending);
}

- (UIBarButtonItem *)spacer
{
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = -11;
    return space;
}

- (void)setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem navItem:(UINavigationItem*)navItem
{
    if ([self isIOS7] && leftBarButtonItem) {
        [navItem setLeftBarButtonItem:nil];
        [navItem setLeftBarButtonItems:@[[self spacer], leftBarButtonItem]];
    } else {
        if ([self isIOS7]) {
            [navItem setLeftBarButtonItems:nil];
        }
        [navItem setLeftBarButtonItem:leftBarButtonItem];
    }
}

- (void)setLeftBarButtonItems:(NSArray *)leftBarButtonItems navItem:(UINavigationItem*)navItem
{
    if ([self isIOS7] && leftBarButtonItems && leftBarButtonItems.count > 0) {
        
        NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:leftBarButtonItems.count + 1];
        [items addObject:[self spacer]];
        [items addObjectsFromArray:leftBarButtonItems];
        
        [navItem setLeftBarButtonItems:items];
    } else {
        [navItem setLeftBarButtonItems:leftBarButtonItems];
    }
}

- (void)setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem navItem:(UINavigationItem*)navItem
{
    if ([self isIOS7] && rightBarButtonItem) {
        [navItem setRightBarButtonItem:nil];
        
        if (rightBarButtonItem.customView) {
            [navItem setRightBarButtonItems:@[[self spacer], rightBarButtonItem]];
        } else {
            [navItem setRightBarButtonItem:rightBarButtonItem];
        }
    } else {
        if ([self isIOS7]) {
            [navItem setRightBarButtonItems:nil];
        }
        [navItem setRightBarButtonItem:rightBarButtonItem];
    }
}

- (void)setRightBarButtonItems:(NSArray *)rightBarButtonItems navItem:(UINavigationItem*)navItem
{
    if ([self isIOS7] && rightBarButtonItems && rightBarButtonItems.count > 0) {
        
        NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:rightBarButtonItems.count + 1];
        [items addObject:[self spacer]];
        [items addObjectsFromArray:rightBarButtonItems];
        
        [navItem setRightBarButtonItems:items];
    } else {
        [navItem setRightBarButtonItems:rightBarButtonItems];
    }
}


@end
