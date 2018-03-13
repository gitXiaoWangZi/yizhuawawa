//
//  LSJLoginController.m
//  zzl
//
//  Created by Mr_Du on 2018/1/28.
//  Copyright © 2018年 Mr.Du. All rights reserved.
//

#import "LSJLoginController.h"
#import "FXLoginPopView.h"
#import "LSJHomeViewController.h"
#import "AppDelegate.h"
#import <SDWebImage/UIImage+GIF.h>
#import "LSJPhoneLoginViewController.h"
#import "FXGameWebController.h"
#import "FXHomeBannerItem.h"
#import "FXNavigationController.h"

@interface LSJLoginController ()<wxDelegate>

@property(nonatomic,weak)AppDelegate * appdelegate;
@property (nonatomic,strong) MBProgressHUD *hud;
@end

@implementation LSJLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor =[UIColor whiteColor];
    
}

- (IBAction)phoneAction:(id)sender {
    LSJPhoneLoginViewController *loginV = [[LSJPhoneLoginViewController alloc] init];
    [self.navigationController pushViewController:loginV animated:YES];
}

- (IBAction)wechatAction:(id)sender {
    if ([WXApi isWXAppInstalled]) {//用户已经安装微信客户端
        //构造SendAuthReq结构体
        SendAuthReq* req =[[SendAuthReq alloc ] init ];
        req.scope = @"snsapi_userinfo" ;
        req.state = @"123" ;
        self.appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        self.appdelegate.delegate = self;
        //第三方向微信终端发送一个SendAuthReq消息结构
        [WXApi sendReq:req];
    }else{//用户未安装微信客户端
        //
    }
}

- (IBAction)agrementAction:(id)sender {
    
    FXHomeBannerItem *item = [FXHomeBannerItem new];
    item.title = @"用户协议";
    item.openUrl = @"http://openapi.wawa.zhuazhuale.xin/agreement";
    FXGameWebController *web = [[FXGameWebController alloc] init];
    web.item = item;
    [self.navigationController pushViewController:web animated:YES];
}

- (void)loginSuccessByCode:(NSString *)code{
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.label.text = @"登录中";
    NSLog(@"code %@",code);
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:WXAppID forKey:@"appid"];
    [params setObject:WXAppSecret forKey:@"secret"];
    [params setObject:code forKey:@"code"];
    [params setObject:@"authorization_code" forKey:@"grant_type"];
    [DYGHttpTool getWXWithPath:@"https://api.weixin.qq.com/sns/oauth2/access_token" params:params success:^(id responseObj) {
        NSDictionary *dic = responseObj;
        NSString *accessToken = [dic valueForKey:@"access_token"];
        NSString *openID = [dic valueForKey:@"openid"];
        [weakSelf requestUserInfoByToken:accessToken andOpenid:openID];
    } failure:^(NSError *error) {
        [_hud hideAnimated:YES];
        NSLog(@"error %@",error);
    }];
}

-(void)requestUserInfoByToken:(NSString*)token andOpenid:(NSString*)openID{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:token forKey:@"access_token"];
    [params setObject:openID forKey:@"openid"];
    [DYGHttpTool getWXWithPath:@"https://api.weixin.qq.com/sns/userinfo" params:params success:^(id responseObj) {
        NSDictionary *dic = responseObj;
        NSLog(@"%@",dic);
        [self wxLoginDataWithOpenid:dic[@"unionid"] name:dic[@"nickname"] img:dic[@"headimgurl"] sex:dic[@"sex"]];
        
    } failure:^(NSError *error) {
        [_hud hideAnimated:YES];
        NSLog(@"error %@",error);
    }];
}

- (void)wxLoginDataWithOpenid:(NSString *)openID name:(NSString *)name img:(NSString *)img sex:(NSString *)sex{
    NSString *path = @"wxLoginUser";
    NSString *sexStr = [sex integerValue] == 0 ? @"女" : @"男";
    NSDictionary *params = @{@"openid":openID,@"username":name,@"img":img,@"distinguish":@"1",@"sex":sexStr};
    [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
        [_hud hideAnimated:YES];
        NSDictionary *dic = (NSDictionary *)json;
        if ([dic[@"code"] integerValue] == 200) {
            //微信登录成功后
            NSDictionary *userDic = dic[@"data"][@"userInfo"];
            NSMutableDictionary *userIngoDic = [@{@"ID":userDic[@"uid"],@"name":userDic[@"nickname"],@"img":userDic[@"portrait"]} mutableCopy];
            [[NSUserDefaults standardUserDefaults] setObject:userIngoDic forKey:@"KWAWAUSER"];
            [[NSUserDefaults standardUserDefaults] setObject:userDic[@"uid"] forKey:KUser_ID];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:KLoginStatus];
            UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
            FXNavigationController *nav = [[FXNavigationController alloc] initWithRootViewController:[[LSJHomeViewController alloc] init]];
            window.rootViewController = nav;
        }
    } failure:^(NSError *error) {
        [_hud hideAnimated:YES];
    }];
}
@end
