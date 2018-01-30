//
//  LSJTopView.m
//  zzl
//
//  Created by Mr_Du on 2017/12/29.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "LSJTopView.h"
#import "FXOnlineIconCell.h"
#import "LSJOperationNormalView.h"
#import "BulletView.h"
#import "BulletManager.h"
#import "BulletBackgroudView.h"
#import "UIButton+Position.h"
#import "ZYCountDownView.h"

@interface LSJTopView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UIButton *backBtn;

@property (nonatomic,strong) UIView *iconBgView;
@property (nonatomic,strong) UILabel *iconL;
@property (nonatomic,strong) UIImageView *iconImgV;

@property (nonatomic,strong) UICollectionView *audienceCollectV;

@property (nonatomic,strong) UIButton *personNumBtn;

@property (nonatomic,strong) UIImageView *musicImgV;
@property (nonatomic,strong) UIImageView *barrageImgV;
@property (nonatomic,strong) UIButton *musicBtn;
@property (nonatomic,strong) UIButton *barrageBtn;

@property (nonatomic,strong) UIButton *crameBtn;

@end

@implementation LSJTopView
static NSString * reuserId= @"roomCell";

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUpChildView];
    }
    return self;
}

- (void)setUpChildView{
    CGFloat playHeight = self.height * 0.75;
    //视频页面
    [self addSubview:self.playView];
    [self.playView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(@(playHeight));
    }];
    //头像背景
    [self addSubview:self.iconBgView];
    [self.iconBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(Px(15));
        make.top.equalTo(self.mas_top).offset(Py(25));
        make.width.equalTo(@(Px(81)));
        make.height.equalTo(@(Py(100)));
    }];
    self.iconBgView.layer.cornerRadius = Px(5);
    self.iconBgView.layer.masksToBounds = YES;
    //名字
    [self.iconBgView addSubview:self.iconL];
    [self.iconL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconBgView.mas_left);
        make.right.equalTo(self.iconBgView.mas_right);
        make.top.equalTo(self.iconBgView.mas_top).offset(Py(5));
        make.height.equalTo(@(Py(20)));
    }];
    //头像
    [self.iconBgView addSubview:self.iconImgV];
    [self.iconImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconBgView.mas_left).offset(2);
        make.right.equalTo(self.iconBgView.mas_right).offset(-2);
        make.bottom.equalTo(self.iconBgView.mas_bottom).offset(-2);
        make.top.equalTo(self.iconL.mas_bottom).offset(5);
    }];
    self.iconImgV.layer.cornerRadius = Px(5);
    self.iconImgV.layer.masksToBounds = YES;
    //返回按钮
    [self addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-14);
        make.top.equalTo(@(Py(38)));
        make.width.equalTo(@(Px(25)));
        make.height.equalTo(@(Px(25)));
    }];
    //围观控件
    [self addSubview:self.audienceCollectV];
    [self.audienceCollectV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backBtn);
        make.right.equalTo(self.backBtn.mas_left).offset(-10);
        make.width.equalTo(@(Py(103)));
        make.height.equalTo(@(Py(40)));
    }];
    //围观人数背景
    [self addSubview:self.personNumBtn];
    [self.personNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backBtn.mas_bottom).offset(10);
        make.right.equalTo(self.backBtn.mas_right);
        make.width.equalTo(@(Px(100)));
        make.height.equalTo(@(Py(20)));
    }];
    self.personNumBtn.layer.cornerRadius = Py(10);
    
    //音乐图
    [self addSubview:self.musicImgV];
    [self.musicImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.playView.mas_bottom).offset(-Py(10));
        make.right.equalTo(self.playView.mas_right).offset(-20);
        make.width.height.equalTo(@(Px(25)));
    }];
    //音乐按钮
    [self addSubview:self.musicBtn];
    [self.musicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.musicImgV);
        make.centerY.equalTo(self.musicImgV);
        make.width.equalTo(self.musicImgV);
        make.height.equalTo(self.musicImgV);
    }];
    //弹幕图
    [self addSubview:self.barrageImgV];
    [self.barrageImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.musicImgV.mas_left).offset(-Py(10));
        make.centerY.equalTo(self.musicImgV);
        make.width.height.equalTo(@(Px(25)));
    }];
    //弹幕按钮
    [self addSubview:self.barrageBtn];
    [self.barrageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.barrageImgV);
        make.centerY.equalTo(self.barrageImgV);
        make.width.equalTo(self.barrageImgV);
        make.height.equalTo(self.barrageImgV);
    }];
    //游戏操作
    [self addSubview:self.normalView];
    [self.normalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.top.equalTo(self.playView.mas_bottom);
    }];
    //弹幕
    [self addSubview:self.bulletBgView];
    [self.bulletBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconBgView.mas_bottom).offset(5);
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.bottom.equalTo(self.musicImgV.mas_top);
    }];
    [self addSubview:self.crameBtn];
    [self.crameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.playView);
        make.right.equalTo(self.mas_right);
    }];
    
    [self creaetBarrage];
    [self.bulletManager start];
}

-(void)creaetBarrage{
    self.bulletManager = [[BulletManager alloc] init];
    self.bulletManager.allComments = @[@" "].mutableCopy;
    __weak LSJTopView *myself = self;
    self.bulletManager.generateBulletBlock = ^(BulletView *bulletView) {
        [myself addBulletView:bulletView];
    };
}

- (void)addBulletView:(BulletView *)bulletView {
    bulletView.frame = CGRectMake(CGRectGetWidth(self.frame)+50, 20 + 34 * bulletView.trajectory, CGRectGetWidth(bulletView.bounds), CGRectGetHeight(bulletView.bounds));
    [self.bulletBgView addSubview:bulletView];
    [bulletView startAnimation];
}

//返回
- (void)back{
    if ([self.delegate respondsToSelector:@selector(dealWithTopViewBy:button:)]) {
        [self.delegate dealWithTopViewBy:TopViewBack button:nil];
    }
}

- (void)changeView:(UIButton *)sender {
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(dealWithTopViewBy:button:)]) {
        [self.delegate dealWithTopViewBy:TopViewView button:sender];
    }
}

//音乐
- (void)musicSwitch:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.musicImgV.image = [UIImage imageNamed:@"sound_down"];
    }else{
        self.musicImgV.image = [UIImage imageNamed:@"sound_open"];
    }
    if ([self.delegate respondsToSelector:@selector(dealWithTopViewBy:button:)]) {
        [self.delegate dealWithTopViewBy:TopViewMusic button:sender];
    }
}

//弹幕
- (void)barrageSwitch:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.barrageImgV.image = [UIImage imageNamed:@"bar_down"];
    }else{
        self.barrageImgV.image = [UIImage imageNamed:@"bar_open"];
    }
    if ([self.delegate respondsToSelector:@selector(dealWithTopViewBy:button:)]) {
        [self.delegate dealWithTopViewBy:TopViewBarrage button:sender];
    }
}

-(void)start{
    [self creaetBarrage];
    [self.bulletManager start];
    self.bulletBgView.hidden = NO;
}
-(void)stopScroll{
    [self.bulletManager stop];
    self.bulletBgView.hidden = YES;
}

#pragma mark UICollectionViewDelegate,UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FXOnlineIconCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuserId forIndexPath:indexPath];
    cell.cornerRadius = Px(15);
    cell.layer.masksToBounds = YES;
    cell.backgroundColor = DYGRandomColor;
    WwUser *model = self.dataArray[indexPath.row];
    [cell.iconImgV sd_setImageWithURL:[NSURL URLWithString:model.portrait] placeholderImage:[UIImage imageNamed:@"avatar_default_medium"]];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(Px(30),Px(30));
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0,Px(2),0,Px(2));
}

#pragma mark 处理数据
- (void)refreshAudienceWithWwUserNum:(NSInteger)num withModel:(WwRoom *)model{
    [[WawaSDK WawaSDKInstance].roomMgr requestViewerWithRoomId:model.ID page:1 withComplete:^(NSInteger code, NSString *message, NSArray<WwUser *> *userList) {
        if (code == WwCodeSuccess) {
            NSArray *kvArr = [WwUser mj_keyValuesArrayWithObjectArray:userList];
            self.dataArray = [NSMutableArray array];
            if ([kvArr isKindOfClass:[NSArray class]]) {
                self.dataArray = [WwUser mj_objectArrayWithKeyValuesArray:kvArr];
                [self.personNumBtn setTitle:[NSString stringWithFormat:@"%zd人围观",userList.count] forState:UIControlStateNormal];
                [self.audienceCollectV reloadData];
            }
        }
    }];
}
- (void)refreGameUserByUser:(WwUser *)user{
    if (user == nil) {
        self.iconImgV.image = [UIImage imageNamed:@"default_icon"];
        self.iconL.text = @"等待入位";
        return;
    }
    self.iconL.text = user.nickname;
    [self.iconImgV sd_setImageWithURL:[NSURL URLWithString:user.portrait]];
}
- (void)refrshWaWaDetailsWithModel:(WwRoom *)model{
    NSString *coin = [NSString stringWithFormat:@"%zd/次",model.wawa.coin];
}

#pragma mark lazyload
- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"live_close"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}
- (UIView *)iconBgView{
    if (!_iconBgView) {
        _iconBgView = [UIView new];
        _iconBgView.backgroundColor = DYGColor(251, 88, 145);
    }
    return _iconBgView;
}
- (UIImageView *)iconImgV{
    if (!_iconImgV) {
        _iconImgV = [[UIImageView alloc] init];
    }
    return _iconImgV;
}
- (UICollectionView *)audienceCollectV{
    if (!_audienceCollectV) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumLineSpacing=Px(4);
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _audienceCollectV = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _audienceCollectV.delegate = self;
        _audienceCollectV.dataSource = self;
        _audienceCollectV.showsVerticalScrollIndicator = NO;
        _audienceCollectV.backgroundColor = [UIColor clearColor];
        [_audienceCollectV registerNib:[UINib nibWithNibName:@"FXOnlineIconCell" bundle:nil] forCellWithReuseIdentifier:reuserId];
        _audienceCollectV.showsHorizontalScrollIndicator = NO;
    }
    return _audienceCollectV;
}
- (UIButton *)personNumBtn{
    if (!_personNumBtn) {
        _personNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _personNumBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [_personNumBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _personNumBtn.backgroundColor = DYGAColor(0, 0, 0, 0.6);
    }
    return _personNumBtn;
}

- (UIView *)playView{
    if (!_playView) {
        _playView = [UIView new];
        _playView.backgroundColor = [UIColor orangeColor];
    }
    return _playView;
}
- (UIImageView *)musicImgV{
    if (!_musicImgV) {
        _musicImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sound_open"]];
    }
    return _musicImgV;
}
- (UILabel *)iconL{
    if (!_iconL) {
        _iconL = [[UILabel alloc] init];
        _iconL.text = @"等待入位";
        _iconL.font = [UIFont systemFontOfSize:11];
        _iconL.textColor = [UIColor whiteColor];
        _iconL.textAlignment = NSTextAlignmentCenter;
    }
    return _iconL;
}
- (UIImageView *)barrageImgV{
    if (!_barrageImgV) {
        _barrageImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bar_open"]];
    }
    return _barrageImgV;
}
-(UIButton *)musicBtn{
    if (!_musicBtn) {
        _musicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _musicBtn.backgroundColor = [UIColor clearColor];
        [_musicBtn addTarget:self action:@selector(musicSwitch:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _musicBtn;
}
-(UIButton *)barrageBtn{
    if (!_barrageBtn) {
        _barrageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _barrageBtn.backgroundColor = [UIColor clearColor];
        [_barrageBtn addTarget:self action:@selector(barrageSwitch:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _barrageBtn;
}

- (UIButton *)crameBtn{
    if (!_crameBtn) {
        _crameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_crameBtn setImage:[UIImage imageNamed:@"interactive_rtcExchange"] forState:UIControlStateNormal];
        [_crameBtn addTarget:self action:@selector(changeView:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _crameBtn;
}

- (LSJOperationNormalView *)normalView{
    if (!_normalView) {
        _normalView = [[LSJOperationNormalView alloc] init];
    }
    return _normalView;
}

- (BulletBackgroudView *)bulletBgView {
    if (!_bulletBgView) {
        _bulletBgView = [[BulletBackgroudView alloc] init];
        _bulletBgView.backgroundColor = [UIColor clearColor];
        _bulletBgView.clipsToBounds = YES;
        [self addSubview:_bulletBgView];
    }
    return _bulletBgView;
}
@end
