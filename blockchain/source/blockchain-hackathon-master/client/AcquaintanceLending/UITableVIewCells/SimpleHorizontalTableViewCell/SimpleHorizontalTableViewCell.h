//
//  SimpleHorizontalTableViewCell.h
//  TengNiu
//
//  Created by 李晓春 on 15/4/8.
//  Copyright (c) 2015年 Teng Niu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleHorizontalTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelInfo;
@property (weak, nonatomic) IBOutlet UILabel *labelValue;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lcTail;
@property (assign, nonatomic) BOOL bSetTail;
- (void)setHeight:(CGFloat)fHeight;

@end
