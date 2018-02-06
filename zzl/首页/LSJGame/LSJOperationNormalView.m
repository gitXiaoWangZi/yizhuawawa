//
//  LSJOperationNormalView.m
//  zzl
//
//  Created by Mr_Du on 2017/12/30.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "LSJOperationNormalView.h"

@interface LSJOperationNormalView()
@property (nonatomic,strong) UIImageView *bgImgV;
@property (nonatomic,strong) UIButton *msgBtn;

@property (nonatomic,strong) UIView *zuanshiView;
@property (nonatomic,strong) UIImageView *zuanshiBgImgV;
@property (nonatomic,strong) UIImageView *zuanshiImgV;
@property (nonatomic,strong) UIImageView *rechargeImgV;
@end

@implementation LSJOperationNormalView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addChildView];
    }
    return self;
}

- (void)addChildView{
    [self addSubview:self.bgImgV];
    [self.bgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self);
    }];
    [self addSubview:self.gameBtn];
    [self.gameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    [self addSubview:self.msgBtn];
    [self.msgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.gameBtn.mas_right).offset(30);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    //充值背景
    [self addSubview:self.zuanshiBgImgV];
    [self.zuanshiBgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(Px(15));
        make.height.equalTo(@(Py(40)));
    }];
    self.zuanshiBgImgV.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recharge:)];
    [self.zuanshiBgImgV addGestureRecognizer:tap];
    //充值钻石
    [self addSubview:self.zuanshiImgV];
    [self.zuanshiImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.zuanshiBgImgV);
        make.left.equalTo(self.zuanshiBgImgV.mas_left).offset(10);
        make.width.equalTo(@(Px(18)));
        make.height.equalTo(@(Px(15.5)));
    }];
    //加号
    [self addSubview:self.rechargeImgV];
    [self.rechargeImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.zuanshiBgImgV);
        make.right.equalTo(self.zuanshiBgImgV.mas_right).offset(-5);
        make.width.equalTo(@(Px(15)));
        make.height.equalTo(@(Px(15)));
    }];
    //钻石数量
    [self addSubview:self.zuanshiNumL];
    [self.zuanshiNumL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.zuanshiBgImgV);
        make.left.equalTo(self.zuanshiImgV.mas_right).offset(0);
        make.right.equalTo(self.rechargeImgV.mas_left).offset(0);
    }];
    [self.zuanshiNumL sizeToFit];
}

#pragma mark lazyload
- (UIImageView *)bgImgV{
    if (!_bgImgV) {
        _bgImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_nav"]];
    }
    return _bgImgV;
}
- (UIButton *)gameBtn{
    if (!_gameBtn) {
        _gameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_gameBtn setBackgroundImage:[UIImage imageNamed:@"start_game_normal"] forState:UIControlStateNormal];
        [_gameBtn setBackgroundImage:[UIImage imageNamed:@"start_game_press"] forState:UIControlStateHighlighted];
        [_gameBtn setBackgroundImage:[UIImage imageNamed:@"start_game_disable"] forState:UIControlStateDisabled];
        [_gameBtn addTarget:self action:@selector(gameAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _gameBtn;
}
- (UIButton *)msgBtn{
    if (!_msgBtn) {
        _msgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_msgBtn setBackgroundImage:[UIImage imageNamed:@"start_chat"] forState:UIControlStateNormal];
        [_msgBtn setBackgroundImage:[UIImage imageNamed:@"start_chat"] forState:UIControlStateHighlighted];
        [_msgBtn addTarget:self action:@selector(msgAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _msgBtn;
}
- (UIView *)zuanshiView{
    if (!_zuanshiView) {
        _zuanshiView = [UIView new];
        _zuanshiView.backgroundColor = [UIColor clearColor];
    }
    return _zuanshiView;
}
- (UIImageView *)zuanshiImgV{
    if (!_zuanshiImgV) {
        _zuanshiImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"recharge_small"]];
    }
    return _zuanshiImgV;
}
- (UIImageView *)zuanshiBgImgV{
    if (!_zuanshiBgImgV) {
        UIImage *image = [UIImage imageNamed:@"charge"];
        image = [image stretchableImageWithLeftCapWidth:20 topCapHeight:0];
        _zuanshiBgImgV = [[UIImageView alloc] initWithImage:image];
    }
    return _zuanshiBgImgV;
}
- (UIImageView *)rechargeImgV{
    if (!_rechargeImgV) {
        _rechargeImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_game_recharge"]];
    }
    return _rechargeImgV;
}
- (UILabel *)zuanshiNumL{
    if (!_zuanshiNumL) {
        _zuanshiNumL = [[UILabel alloc] init];
        _zuanshiNumL.textAlignment = NSTextAlignmentCenter;
        _zuanshiNumL.font = [UIFont systemFontOfSize:14];
        _zuanshiNumL.textColor = DYGColorFromHex(0x000000);
    }
    return _zuanshiNumL;
}
- (void)gameAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(dealWithbottomViewBy:button:)]) {
        [self.delegate dealWithbottomViewBy:OperationNormalViewGame button:sender];
    }
}
- (void)msgAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(dealWithbottomViewBy:button:)]) {
        [self.delegate dealWithbottomViewBy:OperationNormalViewMsg button:sender];
    }
}
- (void)recharge:(UITapGestureRecognizer *)tap{
    if ([self.delegate respondsToSelector:@selector(dealWithbottomViewBy:button:)]) {
        [self.delegate dealWithbottomViewBy:OperationNormalViewrecharge button:nil];
    }
}
@end
