//
//  TextFieldWithTipTableViewCell.h
//  TengNiu
//
//  Created by 李晓春 on 15/4/10.
//  Copyright (c) 2015年 Teng Niu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextFieldWithTipTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelInfo;
@property (weak, nonatomic) IBOutlet UITextField *textValue;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lcTextLeft;

@end
