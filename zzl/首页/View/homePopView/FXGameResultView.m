//
//  FXGameResultView.m
//  zzl
//
//  Created by Mr_Du on 2017/11/24.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXGameResultView.h"

@interface FXGameResultView()

@property(nonatomic,strong) UIView * bgView;
@property(nonatomic,strong) UIImageView * bgImgV;
@property(nonatomic,strong) UIButton * backBtn;
@property (nonatomic,strong) UIButton *game;
@property (nonatomic,strong) UIButton *cancel;
@property(nonatomic,strong) UIView * countV;
@property(nonatomic,strong) UIImageView *countImgV;
@end

@implementation FXGameResultView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.equalTo(@(Px(259)));
        make.height.equalTo(@(Py(262)));
    }];
    [self.bgView addSubview:self.bgImgV];
    [self.bgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.bgView);
    }];
    
    [self.bgView addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_top).offset(Py(9));
        make.right.equalTo(self.bgView.mas_right).offset(Px(11));
    }];
    [self.bgView addSubview:self.game];
    [self.game mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-Py(30));
        make.right.equalTo(self.bgView.mas_right).offset(-Px(20));
    }];
    [self.bgView addSubview:self.cancel];
    [self.cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-Py(30));
        make.left.equalTo(self.bgView.mas_left).offset(Px(22));
    }];
    [self.bgView addSubview:self.countV];
    [self.countV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.game.mas_top).offset(Py(5));
        make.right.equalTo(self.game.mas_right).offset(Px(2));
        make.width.height.equalTo(@(Px(22)));
    }];
    [self.countV addSubview:self.countImgV];
    [self.countImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.countV);
    }];
    [self.countV addSubview:self.desL];
    [self.desL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.countV);
    }];
}

- (void)showStatusView:(BOOL)isSuccess{
    if (isSuccess) {
        self.type = FXGameResultViewTypeBring;
        [self.cancel setBackgroundImage:[UIImage imageNamed:@"game_result_bring"] forState:UIControlStateNormal];
    }else{
        self.type = FXGameResultViewTypeCancel;
        [self.cancel setBackgroundImage:[UIImage imageNamed:@"game_result_cancel"] forState:UIControlStateNormal];
    }
}

#pragma mark lazyload
- (UIView *)countV{
    if (!_countV) {
        _countV = [[UIView alloc] init];
        _countV.backgroundColor = [UIColor clearColor];
    }
    return _countV;
}
- (UIImageView *)countImgV{
    if (!_countImgV) {
        _countImgV = [UIImageView new];
        _countImgV.image = [UIImage imageNamed:@"game_result_yuan"];
    }
    return _countImgV;
}
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
    }
    return _bgView;
}

- (UIImageView *)bgImgV{
    if (!_bgImgV) {
        _bgImgV = [UIImageView new];
        _bgImgV.image = [UIImage imageNamed:@"game_result_bg"];
    }
    return _bgImgV;
}

- (UIButton *)cancel{
    if (!_cancel) {
        _cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancel setBackgroundImage:[UIImage imageNamed:@"game_result_cancel"] forState:UIControlStateNormal];
        [_cancel addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        _cancel.adjustsImageWhenHighlighted = NO;
    }
    return _cancel;
}
- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancel setBackgroundImage:[UIImage imageNamed:@"game_result_delete"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        _backBtn.adjustsImageWhenHighlighted = NO;
    }
    return _backBtn;
}
- (UIButton *)game{
    if (!_game) {
        _game = [UIButton buttonWithType:UIButtonTypeCustom];
        [_game setBackgroundImage:[UIImage imageNamed:@"game_result_again"] forState:UIControlStateNormal];
        [_game addTarget:self action:@selector(game:) forControlEvents:UIControlEventTouchUpInside];
        _game.adjustsImageWhenHighlighted = NO;
    }
    return _game;
}
- (UILabel *)desL{
    if (!_desL) {
        _desL = [[UILabel alloc] init];
        _desL.textColor = DYGColorFromHex(0xffffff);
        _desL.textAlignment = NSTextAlignmentCenter;
        _desL.font = [UIFont boldSystemFontOfSize:16];
        _desL.text = @"5";
    }
    return _desL;
}
- (void)cancel:(UIButton *)sender{
    [self removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(cancelAction:)]) {
        [self.delegate cancelAction:self.type];
    }
}
- (void)game:(UIButton *)sender{
    [self removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(gameAgainAction)]) {
        [self.delegate gameAgainAction];
    }
}

- (void)back:(UIButton *)sender{
    [self removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(cancelAction:)]) {
        [self.delegate cancelAction:FXGameResultViewTypeCancel];
    }
}
@end

