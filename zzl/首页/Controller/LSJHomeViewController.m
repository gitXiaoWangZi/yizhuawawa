//
//  LSJHomeViewController.m
//  zzl
//
//  Created by Mr_Du on 2018/1/28.
//  Copyright © 2018年 Mr.Du. All rights reserved.
//

#import "LSJHomeViewController.h"
#import "ZXLatestLiveCell.h"
#import "QMXingXiuHeaderReusableView.h"
#import "FXHomeBannerItem.h"
#import "FXGameWebController.h"
#import "FXHomeHouseItem.h"
#import "FXSelfViewController.h"
#import "LSJGameViewController.h"
#import "LSJSpoilsController.h"
#import "FXHomeSignPopView.h"//连续登录签到页面
#import "FXHomeLoginSuccessPopView.h" //登录成功页面

@interface LSJHomeViewController ()<QMXingXiuHeaderReusableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,FXHomeLoginSuccessPopViewDelegate>

@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) UIButton *personalBtn;
@property (nonatomic,strong) UIButton *wawaBtn;
@property (nonatomic,strong) UICollectionView *collectV;
@property (nonatomic,strong) QMXingXiuHeaderReusableView *headerView;

@property (nonatomic, assign) BOOL passValidity;
@property (nonatomic,strong) MBProgressHUD *hud;

@property (nonatomic,assign) NSInteger currentPage;

@property (nonatomic,strong) FXHomeSignPopView *signPopView;//7天连续登录页面
@property (nonatomic,strong) FXHomeLoginSuccessPopView *loginPopView;//登录成功页面
/**
 * 房间模型数组
 */
@property (nonatomic,strong) NSMutableArray *roomsArray;
@property (nonatomic,strong) NSArray *bannerArray;
@property (nonatomic,strong) NSMutableArray *roomPicArray;
@end

@implementation LSJHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdkPassValidity) name:kSDKNotifyKey object:nil];
    [self addChildView];
    [self initData];
}

- (void)initData{
    
    [LSJHasNetwork lsj_hasNetwork:^(bool has) {
        if (has) {//有网
            //请求签到天数数据
            [self loadSignDayNumData];
        }else{//没网
            [MBProgressHUD showMessage:@"请检查网络" toView:self.view];
            return ;
        }
    }];
    
    
    NSDictionary *wawaUserDic = (NSDictionary *)[[NSUserDefaults standardUserDefaults] objectForKey:@"KWAWAUSER"];
    [WwUserInfoManager UserInfoMgrInstance].userInfo = ^UserInfo *{
        UserInfo * user = [UserInfo new];
        user.uid = wawaUserDic[@"ID"];// 接入方用户ID
        user.name = wawaUserDic[@"name"];// 接入方用户昵称
        user.avatar = wawaUserDic[@"img"]; // 接入方
        return user;
    };
    
    [self sdkPassValidity];
}

#pragma mark - Public
- (void)sdkPassValidity
{
    self.passValidity = YES;
    //may be you can login
    [self loginUser];
}

- (void)loginUser
{
    if (self.passValidity == NO) {
        [_hud hideAnimated:YES];
        return;
    }
    
    
    //必须等到鉴权成功之后调用
    [[WawaSDK WawaSDKInstance].userInfoMgr loginWithComplete:^(int code, NSString *message) {
        NSLog(@"%@,%zd",message,code);
        if (code != 0) {
            [_hud hideAnimated:YES];
        }else{
        }
    }];
    [self loadNewData];
}

#pragma mark 加载数据
#pragma mark --- 请求房间列表数据
- (void)loadNewData{
    _currentPage = 1;
    [self loadDataWithPage:_currentPage];
    [self loadBannerData];
}

- (void)loadMoreData{
    _currentPage ++;
    [self loadDataWithPage:_currentPage];
}

- (void)loadDataWithPage:(NSInteger)page{
    [[WwRoomManager RoomMgrInstance] requestRoomList:page size:100 withComplete:^(NSInteger code, NSString *message, NSArray<WwRoom *> *list) {
        [self.collectV.mj_header endRefreshing];
        [self.collectV.mj_footer endRefreshing];
        if (!code) {
            // 成功
            if (page == 1) {
                [self.roomsArray removeAllObjects];
            }
            self.roomsArray = [list mutableCopy];
            for (WwRoom *room in list) {
                if (room.ID == 492) {
                    [self.roomsArray removeObject:room];
                }
            }
            if (list.count < 100) {
                [self.collectV.mj_footer endRefreshingWithNoMoreData];
            }
            [self.collectV reloadData];
            DYGLog(@"查找房间成功");
        }
        else {
            // 失败
            DYGLog(@"查找房间失败---%@",message);
        }
    }];
}

#pragma self Delegate
-(void)loadWebViewWithImgIndex:(NSInteger)index{
    if (![[VisiteTools shareInstance] isVisite]) {
        [MobClick event:@"main_banner_clieck"];
        FXHomeBannerItem *item = self.bannerArray[index];
        FXGameWebController *webVC = [[FXGameWebController alloc] init];
        webVC.item = item;
        [self.navigationController pushViewController:webVC animated:YES];
    }else{
        [[VisiteTools shareInstance] outLogin];
    }
    
}

#pragma mark 请求banner图数据
- (void)loadBannerData{
    NSString *path = @"getIndexBanner";
    NSDictionary *params = @{@"uid":KUID,@"index":@(1),@"num":@(20)};
    [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
        NSDictionary *dic = (NSDictionary *)json;
        if ([dic[@"code"] integerValue] == 200) {
            self.bannerArray = [FXHomeBannerItem mj_objectArrayWithKeyValuesArray:dic[@"data"]];
            
            NSMutableArray *temparr = [NSMutableArray array];
            //将banner图片url添加到数组中
            for (FXHomeBannerItem *item in self.bannerArray) {
                [temparr addObject:item.resource];
            }
            self.headerView.adArray = temparr;
        }
    } failure:^(NSError *error) {
        NSLog(@"请求banner图数据错误：%@",error);
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.headerView) {
        [self.headerView starTimer];
    }
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.headerView.timer invalidate];
    self.headerView.timer = nil;
}

- (void)addChildView{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.topView.frame = CGRectMake(0, 0, kScreenWidth, Py(64));
    [self.view addSubview:self.topView];
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_nav"]];
    imageV.frame = self.topView.bounds;
    [self.topView addSubview:imageV];
    
    _personalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_personalBtn setImage:[UIImage imageNamed:@"home_logo"] forState:UIControlStateNormal];
    [_personalBtn addTarget:self action:@selector(personalAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:_personalBtn];
    [_personalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.topView);
        make.width.height.equalTo(@(Px(48)));
    }];
    
    _wawaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_wawaBtn setImage:[UIImage imageNamed:@"home_message"] forState:UIControlStateNormal];
    [_wawaBtn addTarget:self action:@selector(wawaAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:_wawaBtn];
    [_wawaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.topView);
        make.width.height.equalTo(@(Px(48)));
    }];
    
    self.collectV.frame = CGRectMake(0, Py(64), kScreenWidth, kScreenHeight-Py(64));
    [self.view addSubview:self.collectV];
}

- (void)personalAction:(UIButton *)sender{
    if (![[VisiteTools shareInstance] isVisite]) {
        FXSelfViewController *mine = [[FXSelfViewController alloc] init];
        [self.navigationController pushViewController:mine animated:YES];
    }else{
        [[VisiteTools shareInstance] outLogin];
    }
}

- (void)wawaAction:(UIButton *)sender{
    if (![[VisiteTools shareInstance] isVisite]) {
        LSJSpoilsController *spoilVC = [[LSJSpoilsController alloc] init];
        [self.navigationController pushViewController:spoilVC animated:YES];
    }else{
        [[VisiteTools shareInstance] outLogin];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    UIPanGestureRecognizer *pan = scrollView.panGestureRecognizer;
    CGFloat velocity = [pan velocityInView:scrollView].y;
    NSLog(@"偏移量%lf-------触摸%lf",scrollView.contentOffset.y,velocity);
    if (velocity < 0 && scrollView.contentOffset.y > 0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.topView.frame = CGRectMake(0, -Py(64), kScreenWidth, Py(64));
            self.collectV.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        }];
    }else if (velocity > 0){
        [UIView animateWithDuration:0.3 animations:^{
            self.topView.frame = CGRectMake(0, 0, kScreenWidth, Py(64));
            self.collectV.frame = CGRectMake(0, Py(64), kScreenWidth, kScreenHeight-Py(64));
        }];
    }else{
    }
}

#pragma mark UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.roomsArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WwRoom *room = self.roomsArray[indexPath.row];
    ZXLatestLiveCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZXLatestLiveCell" forIndexPath:indexPath];
    cell.layer.shadowOffset = CGSizeMake(0, 3);
    cell.layer.shadowColor = DYGColor(0, 0, 0).CGColor;
    cell.layer.shadowOpacity = 0.2;
    cell.layer.shadowRadius = 4;
    cell.layer.masksToBounds = NO;
    [cell loadWithData:room itemIndex:indexPath.row];
    return cell;
}

/**
 * 改变Cell的尺寸
 */
- (CGSize)collectionView: (UICollectionView *)collectionView
                  layout: (UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath: (NSIndexPath *)indexPath{
    CGFloat cellW = (kScreenWidth-8*2-8)/2.0;
    CGFloat cellH = 182;
    return CGSizeMake(cellW, cellH);
}

/**
 * 整个分区上下左右缩进
 */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(8, 8, 8, 8);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    //广告图
    QMXingXiuHeaderReusableView *header = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        if (self.headerView) {
            return self.headerView;
        }
        header= [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"QMXingXiuHeaderReusableView" forIndexPath:indexPath];
        self.headerView = header;
        header.delegate = self;
        if (!self.headerView.timer) {
            [self.headerView starTimer];
        }
    }
    return header;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGFloat height = Py(160);
    //    if (self.bannerManger.getImages.count == 0) {
    //        height = 0;
    //    }
    CGSize size = {kScreenWidth, height};
    return size;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (![[VisiteTools shareInstance] isVisite]) {
        LSJGameViewController *gameVC = [[LSJGameViewController alloc] init];
        gameVC.model = self.roomsArray[indexPath.row];
        [self.navigationController pushViewController:gameVC animated:YES];
    }else{
        [[VisiteTools shareInstance] outLogin];
    }
}

#pragma mark 签到天数
- (void)loadSignDayNumData{
    NSString *path = @"getSignDays";
    NSDictionary *params = @{@"uid":KUID};
    [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
        NSDictionary *dic = (NSDictionary *)json;
        if ([dic[@"code"] integerValue] == 200) {
            if ([dic[@"today"] integerValue] == 0) {//未签到
                
                if (![[VisiteTools shareInstance] isVisite]) {
                    [self showLoginSignViewWithDic:dic];
                }
            }else{//已签到
                NSLog(@"已签到");
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark 点击签到
- (void)loadGetSignDataWithDay:(NSString *)day{
    NSString *path = @"getSign";
    NSDictionary *params = @{@"uid":KUID};
    [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
        NSDictionary *dic = (NSDictionary *)json;
        if ([dic[@"code"] integerValue] == 200) {
            [self.signPopView removeFromSuperview];
            self.loginPopView = [[[NSBundle mainBundle] loadNibNamed:@"FXHomeLoginSuccessPopView" owner:nil options:nil] firstObject];
            self.loginPopView.frame = self.view.bounds;
            self.loginPopView.money = [dic[@"data"][@"money"] stringValue];
            self.loginPopView.delegate = self;
            [[UIApplication sharedApplication].keyWindow addSubview:self.loginPopView];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

//每天连续登录签到的页面
- (void)showLoginSignViewWithDic:(NSDictionary *)dic{
    self.signPopView = [[[NSBundle mainBundle] loadNibNamed:@"FXHomeSignPopView" owner:self options:nil] firstObject];
    self.signPopView.frame = self.view.bounds;
    self.signPopView.dataDic = dic;
    __weak typeof(self) weakSelf = self;
    self.signPopView.signActionBlock = ^(NSString *day){
        [weakSelf loadGetSignDataWithDay:day];
    };
    [[UIApplication sharedApplication].keyWindow addSubview:self.signPopView];
}

#pragma mark FXHomeLoginSuccessPopViewDelegate
- (void)dealThingAfterSuccess{
    
}


#pragma mark lazyload
- (UIView *)topView{
    if (!_topView) {
        _topView = [UIView new];
        _topView.backgroundColor = [UIColor orangeColor];
    }
    return _topView;
}

- (UICollectionView *)collectV {
    if (!_collectV) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        CGFloat margin = 8;
        CGFloat padding = 8;
        
        layout.minimumLineSpacing = margin;
        layout.minimumInteritemSpacing = padding;
        
        _collectV = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectV.dataSource = self;
        _collectV.delegate = self;
        
        _collectV.backgroundView = nil;
        _collectV.showsHorizontalScrollIndicator = NO;
        _collectV.backgroundColor = DYGColorFromHex(0xffeaf1);
        
        UINib *cellNib = [UINib nibWithNibName:@"ZXLatestLiveCell" bundle:nil];
        [_collectV registerNib:cellNib forCellWithReuseIdentifier:@"ZXLatestLiveCell"];
        
        [_collectV registerClass:[QMXingXiuHeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"QMXingXiuHeaderReusableView"];
        
        _collectV.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        footer.stateLabel.font = [UIFont systemFontOfSize:14];
        footer.stateLabel.textColor = DYGColorFromHex(0xB4B4B4);
        [footer setTitle:@"(/≧▽≦)/伦家可是有底线的娃娃机~" forState:MJRefreshStateNoMoreData];
        _collectV.mj_footer = footer;
        _collectV.showsVerticalScrollIndicator = NO;
    }
    return _collectV;
}

- (NSArray *)bannerArray{
    if (!_bannerArray) {
        _bannerArray = [NSArray array];
    }
    return _bannerArray;
}
- (NSMutableArray *)roomPicArray{
    if (!_roomPicArray) {
        _roomPicArray = [NSMutableArray array];
    }
    return _roomPicArray;
}
@end
