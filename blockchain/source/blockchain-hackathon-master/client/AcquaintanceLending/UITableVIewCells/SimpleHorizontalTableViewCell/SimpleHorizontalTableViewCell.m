//
//  SimpleHorizontalTableViewCell.m
//  TengNiu
//
//  Created by 李晓春 on 15/4/8.
//  Copyright (c) 2015年 Teng Niu. All rights reserved.
//

#import "SimpleHorizontalTableViewCell.h"
#import "STUtilities.h"

@interface SimpleHorizontalTableViewCell ()
{
    CGFloat m_fHeight;
}

@end

@implementation SimpleHorizontalTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    if (!_bSetTail) {
        if (self.accessoryType == UITableViewCellAccessoryNone) {
            _lcTail.constant = 15;
        } else {
            _lcTail.constant = 0;
        }
    }
    
    [super layoutSubviews];
}

- (CGFloat)height
{
    if (m_fHeight) {
        return m_fHeight;
    }
    return 44;
}

- (void)setHeight:(CGFloat)fHeight
{
    m_fHeight = fHeight;
}

@end
