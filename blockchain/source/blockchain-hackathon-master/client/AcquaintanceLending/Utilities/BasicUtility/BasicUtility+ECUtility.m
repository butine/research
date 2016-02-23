//
//  BasicUtility+ECUtility.m
//  ECarDriver
//
//  Created by 李晓春 on 15/10/5.
//  Copyright © 2015年 upluscar. All rights reserved.
//

#import "BasicUtility+ECUtility.h"

@implementation BasicUtility (ECUtility)

- (NSString*)getTimeStringForMinute:(int)nMinute
{
    NSString *strDay = nil;
    NSString *strHour = nil;
    if (nMinute / 60) {
        int nHour = nMinute / 60;
        if (nHour >= 24) {
            strDay = [NSString stringWithFormat:@"%d天", nHour / 24];
            strHour = [NSString stringWithFormat:@"%d小时", nHour % 24];
        }
        else {
            strHour = [NSString stringWithFormat:@"%d小时", nHour];
        }
    }
    
    NSString *strMinute = [NSString stringWithFormat:@"%d分钟", nMinute % 60];
    NSString *strRet = nil;
    if (strDay) {
        strRet = [NSString stringWithFormat:@"%@%@%@", strDay, strHour, strMinute];
    }
    else if (strHour) {
        strRet = [NSString stringWithFormat:@"%@%@", strHour, strMinute];
    }
    else {
        strRet = strMinute;
    }
    
    return strRet;
}

@end
