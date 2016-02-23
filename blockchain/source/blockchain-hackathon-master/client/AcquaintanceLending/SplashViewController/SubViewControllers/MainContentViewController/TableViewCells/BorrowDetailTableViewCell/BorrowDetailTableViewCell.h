//
//  BorrowDetailTableViewCell.h
//  AcquaintanceLending
//
//  Created by 李晓春 on 16/1/9.
//  Copyright © 2016年 ctcf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BorrowDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelStatus;
@property (weak, nonatomic) IBOutlet UILabel *labelAmount;
@property (weak, nonatomic) IBOutlet UILabel *labelRate;
@property (weak, nonatomic) IBOutlet UILabel *labelProfit;
@property (weak, nonatomic) IBOutlet UILabel *labelRepayDate;
@property (strong, nonatomic) NSDictionary *dicInfo;

@end
