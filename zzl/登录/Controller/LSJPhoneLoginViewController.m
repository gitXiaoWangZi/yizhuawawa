//
//  LSJPhoneLoginViewController.m
//  zzl
//
//  Created by Mr_Du on 2018/1/28.
//  Copyright © 2018年 Mr.Du. All rights reserved.
//

#import "LSJPhoneLoginViewController.h"
#import "LSJHomeViewController.h"
#import "FXNavigationController.h"

@interface LSJPhoneLoginViewController ()
{
    NSInteger _timerNo;
    NSTimer *_timer;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *codeSendBtn;

@property (nonatomic,strong) MBProgressHUD *hud;

@end

@implementation LSJPhoneLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (IBAction)textFieldDidChanged:(UITextField *)sender {
    
}

- (IBAction)onSendCode:(id)sender {
    if ([self checkTextFieldIsNoNil]) {
        [self startSendAuthcode:sender];
        NSString *path = @"getLoginVercode";
        NSDictionary *params = @{@"phone":[DYGEnCode EncodeWithString:self.phoneTF.text]};
        [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
            NSDictionary *dic = (NSDictionary *)json;
            if ([[dic objectForKey:@"code"] integerValue] == 200) {
            }else if ([[dic objectForKey:@"code"] isEqualToString:@"201"]){
                [MBProgressHUD showMessage:@"您已注册" toView:self.view];
            }else if ([[dic objectForKey:@"code"] isEqualToString:@"503"]){
                [MBProgressHUD showMessage:@"手机号错误" toView:self.view];
            }else{
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }
}

- (IBAction)onPhoneAction:(id)sender {
    if ([self.phoneTF.text isEqualToString:@""]) {
        [MBProgressHUD showMessage:@"请输入手机号" toView:self.view];
        return;
    }
    if ([self.codeTF.text isEqualToString:@""]) {
        [MBProgressHUD showMessage:@"请输入验证码" toView:self.view];
        return;
    }
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.label.text = @"登录中";
    NSString *path = @"vLoginUser";
    NSDictionary *params = @{@"phone":[DYGEnCode EncodeWithString:self.phoneTF.text],@"vercode":self.codeTF.text,@"appsour":@"appStore",@"distinguish":@"1"};
    [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
        [_hud hideAnimated:YES];
        NSDictionary *dic = (NSDictionary *)json;
        if ([dic[@"code"] integerValue] == 200) {
            
            NSDictionary *userDic = dic[@"data"][@"userInfo"];
            NSMutableDictionary *userIngoDic = [@{@"ID":userDic[@"uid"],@"name":userDic[@"nickname"],@"img":userDic[@"portrait"]} mutableCopy];
            [[NSUserDefaults standardUserDefaults] setObject:userIngoDic forKey:@"KWAWAUSER"];
            [[NSUserDefaults standardUserDefaults] setObject:userDic[@"uid"] forKey:KUser_ID];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:KLoginStatus];
            UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
            FXNavigationController *nav = [[FXNavigationController alloc] initWithRootViewController:[[LSJHomeViewController alloc] init]];
            window.rootViewController = nav;
            
        }else{
            [MBProgressHUD showError:dic[@"msg"] toView:self.view];
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)startSendAuthcode:(UIButton *)btn{//计时器
    _timerNo = 60;
    btn.enabled = NO;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}
//定时器
- (void)timerAction:(NSTimer *)timer{
    _timerNo--;
    self.codeSendBtn.titleLabel.text = [NSString stringWithFormat:@"(%zd)重新验证",_timerNo];
    [self.codeSendBtn setTitle:[NSString stringWithFormat:@"(%zd)重新验证",_timerNo] forState:UIControlStateDisabled];
    if (_timerNo == 0) {
        [timer invalidate];
        self.codeSendBtn.enabled = YES;
        self.codeSendBtn.titleLabel.text = @"(60)重新验证";
        [self.codeSendBtn setTitle:@"(60)重新验证" forState:UIControlStateDisabled];
    }
}

- (BOOL)checkTextFieldIsNoNil{
    if (self.phoneTF.text.length != 11) {
        [MBProgressHUD showMessage:@"请输入正确的手机号" toView:self.view];
        return NO;
    }
    return YES;
}
@end
