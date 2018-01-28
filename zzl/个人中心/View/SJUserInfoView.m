//
//  SJUserInfoView.m
//  prizeClaw
//
//  Created by Mr_Du on 2017/12/14.
//  Copyright © 2017年 QuanMin.ShouYin. All rights reserved.
//

#import "SJUserInfoView.h"
#import "AccountItem.h"

@interface SJUserInfoView ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userInfoStatusBarMargin;

@end

@implementation SJUserInfoView

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.userInfoStatusBarMargin.constant = kMineStatusMargin;
}

+ (instancetype)userInfoView {
    return [[[NSBundle mainBundle] loadNibNamed:@"SJUserInfoView" owner:nil options:nil] lastObject];
}

- (IBAction)userCenterButtonClick:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(userInfoViewDelegateEditUserCenter:selectBtn:)]) {
        [self.delegate userInfoViewDelegateEditUserCenter:self selectBtn:btn];
    }
}

- (void)updateCenterUser:(AccountItem *)userInfo {
    //头像
    [self.portraitImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.portrait]];
    self.portraitImageView.contentMode = UIViewContentModeScaleAspectFill;
    //昵称
    [self.nickNameLabel setText:userInfo.nickname];
    //ID
    NSString *uid = [NSString stringWithFormat:@"ID:%@",userInfo.uid];
    [self.IDLabel setText:uid];
}

@end
