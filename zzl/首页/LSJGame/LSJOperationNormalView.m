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

@property (nonatomic,strong) UIImageView *iconImgV;
@property (nonatomic,strong) UILabel *currentPriceL;
@property (nonatomic,strong) UILabel *originPriceL;
@property (nonatomic,strong) UILabel *ZKtitleL;
@property (nonatomic,strong) UILabel *countL;
@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,assign) int countDownTime;
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
    
    [self addSubview:self.countBgView];
    [self.countBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(@(Py(30)));
    }];
    
    [self.countBgView addSubview:self.iconImgV];
    [self.iconImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.countBgView.mas_left).offset(Px(13));
        make.centerY.equalTo(self.countBgView.mas_centerY);
        make.width.height.equalTo(@(Py(25)));
    }];
    [self.countBgView addSubview:self.currentPriceL];
    [self.currentPriceL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgV.mas_right).offset(4);
        make.centerY.equalTo(self.iconImgV.mas_centerY);
    }];
    [self.countBgView addSubview:self.originPriceL];
    [self.originPriceL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.currentPriceL.mas_right).offset(5);
        make.centerY.equalTo(self.iconImgV.mas_centerY);
    }];
    [self.countBgView addSubview:self.ZKtitleL];
    [self.ZKtitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.countBgView.mas_right).offset(-Px(10));
        make.top.equalTo(self.countBgView.mas_top).offset(Py(2.5));
        make.height.equalTo(@(Py(10.5)));
    }];
    [self.countBgView addSubview:self.countL];
    [self.countL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.countBgView.mas_right).offset(-Px(10));
        make.top.equalTo(self.ZKtitleL.mas_bottom).offset(Py(2.5));
        make.height.equalTo(@(Py(11.5)));
        make.width.equalTo(self.ZKtitleL.mas_width);
    }];
    self.countL.layer.cornerRadius = 2;
    self.countL.layer.masksToBounds = YES;
    self.countL.hidden = YES;
    self.ZKtitleL.hidden = YES;
    
}

- (void)refreshViewWithOrigin:(NSInteger )price Credits:(NSString *)credits time:(NSString *)time{
    NSString *origin = [NSString stringWithFormat:@"原价:%ld/次",price];
    //中划线
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:origin attributes:attribtDic];
    self.originPriceL.attributedText = attribtStr;

    if ([credits integerValue] == price && [time integerValue] != 0) {
        self.currentPriceL.text = [NSString stringWithFormat:@"原价:%@/次",credits];
        self.originPriceL.hidden = YES;
        self.countL.hidden = NO;
        self.ZKtitleL.hidden = NO;
        self.countDownTime = [time intValue];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdown:) userInfo:nil repeats:YES];
    }else{
        self.currentPriceL.text = [NSString stringWithFormat:@"现价:%@/次",credits];
        self.originPriceL.hidden = NO;
        self.countL.hidden = YES;
        self.ZKtitleL.hidden = YES;
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
    }
}

- (void)countdown:(NSTimer *)timer{
    self.countDownTime --;
    
    if (self.countDownTime <= 0) {
        [self.timer invalidate];
        self.timer = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:KrefreshActiveCountDown object:nil];
        return;
    }
    
    int seconds = self.countDownTime % 60;
    int minutes = (self.countDownTime / 60) % 60;
    int hours = self.countDownTime / 3600;
    
    self.countL.text = [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}

- (void)stopCountDownAction{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
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
- (UIView *)countBgView{
    if (!_countBgView) {
        _countBgView = [UIView new];
        _countBgView.backgroundColor = [UIColor whiteColor];
    }
    return _countBgView;
}
- (UIImageView *)iconImgV{
    if (!_iconImgV) {
        _iconImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"recharge_small"]];
    }
    return _iconImgV;
}
- (UILabel *)currentPriceL{
    if (!_currentPriceL) {
        _currentPriceL = [[UILabel alloc] init];
        _currentPriceL.textAlignment = NSTextAlignmentLeft;
        _currentPriceL.font = [UIFont boldSystemFontOfSize:14];
        _currentPriceL.textColor = DYGColor(206, 64, 49);
    }
    return _currentPriceL;
}
- (UILabel *)originPriceL{
    if (!_originPriceL) {
        _originPriceL = [[UILabel alloc] init];
        _originPriceL.textAlignment = NSTextAlignmentLeft;
        _originPriceL.font = [UIFont systemFontOfSize:11];
        _originPriceL.textColor = DYGAColor(206, 64, 49, 0.5);
    }
    return _originPriceL;
}
- (UILabel *)ZKtitleL{
    if (!_ZKtitleL) {
        _ZKtitleL = [[UILabel alloc] init];
        _ZKtitleL.textAlignment = NSTextAlignmentCenter;
        _ZKtitleL.font = [UIFont boldSystemFontOfSize:11];
        _ZKtitleL.textColor = DYGColor(51, 51, 51);
        _ZKtitleL.text = @"折扣开启时间";
    }
    return _ZKtitleL;
}
- (UILabel *)countL{
    if (!_countL) {
        _countL = [[UILabel alloc] init];
        _countL.textAlignment = NSTextAlignmentCenter;
        _countL.font = [UIFont systemFontOfSize:11];
        _countL.textColor = DYGColor(255, 255, 255);
        _countL.backgroundColor = DYGColor(51, 51, 51);
        _countL.text = @"00:13:34";
    }
    return _countL;
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
