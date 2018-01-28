//
//  FXSelfViewController.m
//  zzl
//
//  Created by Mr_Du on 2017/10/30.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXSelfViewController.h"
#import "FXUserInfoController.h"
#import "SJUserInfoView.h"
#import "FXRechargeViewController.h"
#import "FXRecordViewController.h"
#import "FXRechargeRecordContoller.h"
#import "LSJSpoilsController.h"
#import "FXSettingViewController.h"
#import "FXAddressManageController.h"
#import "FXNotificationController.h"
#import "FXHelpController.h"
#import "FXTaskViewController.h"
#import "AccountItem.h"
#import "FXGameWebController.h"
#import "FXMineHeaderView.h"
#import "FXHomeBannerItem.h"
#import "LSJUserInfoCell.h"

static NSString *cellId = @"LSJUserInfoCell";
@interface FXSelfViewController ()<UITableViewDelegate,UITableViewDataSource,SJUserInfoViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *userInfoArray;
@property (nonatomic,strong) AccountItem *item;

@property (nonatomic,strong) SJUserInfoView *header1;
@property (nonatomic,copy) NSString *firstpunch;
@end

@implementation FXSelfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUserData:) name:@"refreshUserData" object:nil];
    self.view.backgroundColor = randomColor;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.header1;
    [self.tableView registerClass:[LSJUserInfoCell class] forCellReuseIdentifier:cellId];
    self.tableView.showsVerticalScrollIndicator = NO;
    
    //请求用户信息
    [self loadUserInfoData];
    
}

//个人资料中修改信息通知本页进行刷新数据
- (void)refreshUserData:(NSNotification *)noti{
    [self loadUserInfoData];
}

// 160 106
#pragma mark tableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.userInfoArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *tempArr = self.userInfoArray[section];
    return tempArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *tempArr = self.userInfoArray[indexPath.section];
    LSJUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    cell.titleL.text = tempArr[indexPath.row][@"title"];
    cell.icon.image = [UIImage imageNamed:tempArr[indexPath.row][@"icon"]];
    cell.desImgV.image = [UIImage imageNamed:tempArr[indexPath.row][@"desImg"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.titleL.text = self.item.rich.coin;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Py(44);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            FXRechargeViewController *rechargeVC = [[FXRechargeViewController alloc] init];
            rechargeVC.firstpunch = self.firstpunch;
            rechargeVC.item = self.item;
            [self.navigationController pushViewController:rechargeVC animated:YES];
        }else if (indexPath.row == 1){
            LSJSpoilsController *spoilsVC = [[LSJSpoilsController alloc] init];
            [self.navigationController pushViewController:spoilsVC animated:YES];
        }else{
            FXRecordViewController *recordVC = [[FXRecordViewController alloc] init];
            [self.navigationController pushViewController:recordVC animated:YES];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            
        }else{
            FXHomeBannerItem *item = [FXHomeBannerItem new];
            item.openUrl = @"http://api.wawa.lkmai.com/share";
            item.title = @"邀请好友";
            FXGameWebController *vc = [[FXGameWebController alloc] init];
            vc.item = item;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        if (indexPath.row == 0) {
            FXHelpController *helpVC = [[FXHelpController alloc] init];
            [self.navigationController pushViewController:helpVC animated:YES];
        }else{
            
            FXSettingViewController *settingVC = [[FXSettingViewController alloc] init];
            [self.navigationController pushViewController:settingVC animated:YES];
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return Py(10);
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @" ";
}

#pragma mark SJUserInfoViewDelegate Delegate
- (void)userInfoViewDelegateEditUserCenter:(SJUserInfoView *) userInfoView selectBtn:(UIButton *)btn{
    if (btn.tag == 1) {
        FXUserInfoController *userVC = [[FXUserInfoController alloc] init];
        [self.navigationController pushViewController:userVC animated:YES];
    }else if (btn.tag == 4){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        
    }
}

#pragma mark lazy load
-(NSArray *)userInfoArray{
    if (!_userInfoArray) {
        _userInfoArray = @[@[@{@"icon":@"mine_coin",@"title":@"6789",@"desImg":@"mine_top_recharge"},@{@"icon":@"mine_wawa",@"title":@"我的娃娃",@"desImg":@"mine_right"},@{@"icon":@"mine_record",@"title":@"游戏记录",@"desImg":@"mine_right"}],
  @[@{@"icon":@"mine_task",@"title":@"任务中心",@"desImg":@"mine_right"},@{@"icon":@"mine_invite",@"title":@"邀请有礼",@"desImg":@"mine_right"}],
  @[@{@"icon":@"mine_help",@"title":@"帮助与反馈",@"desImg":@"mine_right"},@{@"icon":@"mine_setting",@"title":@"设置",@"desImg":@"mine_right"}]];
    }
    return _userInfoArray;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -20, kScreenWidth, kScreenHeight+20) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = BGColor;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (SJUserInfoView *)header1{
    if (!_header1) {
        _header1 = [SJUserInfoView userInfoView];
        _header1.frame = CGRectMake(0, 0, kScreenWidth, Py(197));
        _header1.delegate = self;
    }
    return _header1;
}
#pragma mark ---请求用户信息数据
- (void)loadUserInfoData{
    
    NSString *path = @"getUserInfo";
    NSDictionary *params = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KUser_ID]};
    [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
        NSDictionary *dic = (NSDictionary *)json;
        if ([dic[@"code"] intValue] == 200) {
            _item = [AccountItem mj_objectWithKeyValues:dic[@"data"][@"userInfo"]];
            [_header1 updateCenterUser:_item];
            _firstpunch = dic[@"firstpunch"];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}
@end
