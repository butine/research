//
//  SplashFailedView.m
//  TengNiu
//
//  Created by 李晓春 on 15/4/16.
//  Copyright (c) 2015年 Teng Niu. All rights reserved.
//

#import "SplashFailedView.h"
#import "STUtilities.h"
#import "SplashViewErrorFactory.h"

@interface SplashFailedView ()

@property (weak, nonatomic) IBOutlet UIView *viewNetError;
@property (weak, nonatomic) IBOutlet UIButton *btnReconnect;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonTopConstraint;

@end

@implementation SplashFailedView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    _btnReconnect.layer.cornerRadius = 5;
    _btnReconnect.layer.borderWidth = 1;
    _btnReconnect.layer.borderColor = [UIColor colorWithHexValue:@"999999"].CGColor;
}

- (void)setFailedState:(NSError*)dicInfo
{
    if ([dicInfo.domain isEqualToString:TNSplashErrorDomain]) {
        NSDictionary* dict = dicInfo.userInfo;
        self.titleLabel.text = dict[TNSplashErrorTitleKey];
        self.subtitleLabel.text = dict[TNSplashErrorSubtitleKey];
        if (self.subtitleLabel.text.length > 0) {
            self.buttonTopConstraint.constant = 62;
        } else {
            self.buttonTopConstraint.constant = 20;
        }
        [self.btnReconnect setTitle:dict[TNSplashErrorButtonNormalTitleKey] forState:UIControlStateNormal];
        [self.btnReconnect setTitle:dict[TNSplashErrorButtonHighlightedTitleKey] forState:UIControlStateNormal];
        [self.btnReconnect setTitle:dict[TNSplashErrorButtonDisabledTitleKey] forState:UIControlStateNormal];
    }
}

- (IBAction)onButtonReconnectClicked:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(st_reloadData)]) {
        [_delegate st_reloadData];
    }
}

@end
