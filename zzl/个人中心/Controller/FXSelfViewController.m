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
#import "FXSpoilsController.h"
#import "FXSettingViewController.h"
#import "FXAddressManageController.h"
#import "FXNotificationController.h"
#import "FXHelpController.h"
#import "FXTaskViewController.h"
#import "AccountItem.h"
#import "FXGameWebController.h"
#import "FXMineHeaderView.h"
#import "FXMinePageCell.h"
#import "FXHomeBannerItem.h"

static NSString *cellId = @"FXMinePageCell";
@interface FXSelfViewController ()<UITableViewDelegate,UITableViewDataSource,SJUserInfoViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *titleArr;
@property (nonatomic,strong) NSArray *pushArr;
@property (nonatomic,strong) AccountItem *item;
@property (nonatomic,copy) NSString *receive;

@property (nonatomic,strong) SJUserInfoView *header1;
@property (nonatomic,copy) NSString *firstpunch;
@end

@implementation FXSelfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUserData:) name:@"refreshUserData" object:nil];
    self.view.backgroundColor = randomColor;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.pushArr =@[@"FXRechargeViewController",@"FXGameWebController",@"FXTaskViewController",@"FXAddressManageController",@"FXNotificationController",@"FXHelpController",@"FXSettingViewController"];
    [self.view addSubview:self.tableView];
    
    self.tableView.tableHeaderView = self.header1;
    [self.tableView registerNib:[UINib nibWithNibName:@"FXMinePageCell" bundle:nil] forCellReuseIdentifier:cellId];
    
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
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 2;
            break;
        default:
            return 2;
            break;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FXMinePageCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    switch (indexPath.section) {
        case 0:
            cell.icon.image = [UIImage imageNamed:self.titleArr[indexPath.row][@"img"]];
            cell.title.text = self.titleArr[indexPath.row][@"title"];
            break;
        case 1:
            cell.icon.image = [UIImage imageNamed:self.titleArr[indexPath.row+1][@"img"]];
            cell.title.text = self.titleArr[indexPath.row+1][@"title"];
            if (indexPath.row == 1 && [_receive integerValue] == 1) {
                cell.warn.hidden = NO;
            }else{
                cell.warn.hidden = YES;
            }
            break;
        case 2:
            cell.icon.image = [UIImage imageNamed:self.titleArr[indexPath.row+3][@"img"]];
            cell.title.text = self.titleArr[indexPath.row+3][@"title"];
            break;
        case 3:
            cell.icon.image = [UIImage imageNamed:self.titleArr[indexPath.row+5][@"img"]];
            cell.title.text = self.titleArr[indexPath.row+5][@"title"];
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Py(44);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
        {
            [MobClick event:@"click_pay"];
            FXRechargeViewController *rechargeVC = [[FXRechargeViewController alloc] init];
            rechargeVC.firstpunch = self.firstpunch;
            rechargeVC.item = self.item;
            [self.navigationController pushViewController:rechargeVC animated:YES];
            
        }
            break;
        case 1:
        {
            if (indexPath.row == 0) {
                FXHomeBannerItem *item = [FXHomeBannerItem new];
                item.openUrl = @"http://wawa.api.fanx.xin/share";
                item.title = @"邀请好友";
                FXGameWebController *vc = [[FXGameWebController alloc] init];
                vc.item = item;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [self pushVcWithIndexpath:indexPath.row+1];
            }
        }
            break;
        case 2:
            [self pushVcWithIndexpath:indexPath.row+3];
            break;
        case 3:
            [self pushVcWithIndexpath:indexPath.row+5];
            break;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return Py(10);
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @" ";
}

-(void)pushVcWithIndexpath:(NSInteger)row{
        NSString * classStr = self.pushArr[row];
    DYGLog(@"%@",classStr);
        if (classStr.length>0) {
            Class pushVc = NSClassFromString(classStr);
            UIViewController *vc = [pushVc new];
            [self.navigationController pushViewController:vc animated:YES];
        }
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
-(NSArray *)titleArr{
    if (!_titleArr) {
        _titleArr = @[@{@"title":@"充值",@"img":@"recharge_self"},
                      @{@"title":@"邀请好友",@"img":@"invite"},
                      @{@"title":@"任务中心",@"img":@"gift"},
                      @{@"title":@"收货地址",@"img":@"location"},
                      @{@"title":@"通知中心",@"img":@"notice"},
                      @{@"title":@"帮助与反馈",@"img":@"help"},
                      @{@"title":@"设置",@"img":@"set"}];
    }
    return _titleArr;
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
        _header1.frame = CGRectMake(0, 0, kScreenWidth, Py(232));
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
            _receive = dic[@"receive"];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}
@end
