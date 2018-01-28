//
//  SJUserInfoView.h
//  prizeClaw
//
//  Created by Mr_Du on 2017/12/14.
//  Copyright © 2017年 QuanMin.ShouYin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SJUserInfoView;
@class AccountItem;

@protocol SJUserInfoViewDelegate <NSObject>

- (void)userInfoViewDelegateEditUserCenter:(SJUserInfoView *) userInfoView selectBtn:(UIButton *)btn;

@end

@interface SJUserInfoView : UIView

@property (nonatomic, weak) id <SJUserInfoViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *portraitImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *IDLabel;


/**
 用户信息
 */
+ (instancetype)userInfoView;
- (void)updateCenterUser:(AccountItem *)user;
@end
