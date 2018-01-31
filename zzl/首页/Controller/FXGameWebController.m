//
//  FXGameWebController.m
//  zzl
//
//  Created by Mr_Du on 2017/11/18.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXGameWebController.h"
#import "FXLatesRecordModel.h"
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "FXRechargeViewController.h"
#import "FXHomeBannerItem.h"

@interface FXGameWebController ()<UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic, strong) UIView *progressView;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic,assign) BOOL isChristmasList;
@end

@implementation FXGameWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self addWebView];
}

-(void)addWebView
{
    _isChristmasList = NO;
    self.webView=[[UIWebView alloc]initWithFrame:(CGRectMake(0, 0, kScreenWidth, kScreenHeight-64))];
    self.webView.delegate=self;
    self.webView.scalesPageToFit = YES;
    self.webView.backgroundColor = [UIColor whiteColor];
    self.progressView.y = self.webView.y;
    self.title = self.item.title;
    if (self.item) {
        if ([self.item.banner_type isEqualToString:@"2"]) {//分享
            self.item.openUrl = [NSString stringWithFormat:@"%@?uid=%@",@"http://api.wawa.lkmai.com/share",KUID];
        }
        if ([self.item.banner_type isEqualToString:@"5"]) {//大转盘
            _isChristmasList = YES;
            self.item.openUrl = [NSString stringWithFormat:@"%@?uid=%@",@"http://api.wawa.lkmai.com/turntable",KUID];
        }
        if ([self.item.banner_type isEqualToString:@"6"]) {//冲榜
            self.item.openUrl = [NSString stringWithFormat:@"%@?uid=%@",@"http://api.wawa.lkmai.com/christmasList",KUID];
        }
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.item.openUrl]];
        [self.webView loadRequest:request];
        [self.view addSubview:self.webView];
    }else{
        self.title = @"视频";
        NSString *path = @"videoShare";
        NSString *orderID = @"";
        if (self.model.orderId) {
            orderID = self.model.orderId;
        }else{
            orderID = self.orderId;
        }
        NSDictionary *params = @{@"orderId":orderID};
        [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
            NSDictionary *dic = (NSDictionary *)json;
            if ([dic[@"code"] integerValue] == 200) {
                
                NSURL *url = [NSURL URLWithString:dic[@"data"][@"linkurl"]];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                [self.webView loadRequest:request];
                self.webView.allowsInlineMediaPlayback = YES;
                [self.view addSubview:self.webView];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *urlString = request.URL.absoluteString;
    if ([urlString containsString:@"sharefriend"]) {
        [self shareActionData];
        return NO;
    }
//    if ([urlString containsString:@"recharge"]) {
////        FXRechargeViewController *rechargeVC= [[FXRechargeViewController alloc] init];
////        [self.navigationController pushViewController:rechargeVC animated:YES];
//        return NO;
//    }
    return YES;
}

- (void)shareActionData{
        NSString *path = @"shares";
    NSDictionary *params = @{@"uid":KUID};
        [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
            NSDictionary *dic = (NSDictionary *)json;
            if ([dic[@"code"] integerValue] == 200) {
                [self shareActionWithHref:dic[@"data"][@"linkurl"] content:dic[@"data"][@"conten"] title:dic[@"data"][@"title"] icon:dic[@"data"][@"path"]];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
}

- (void)shareActionWithHref:(NSString *)href content:(NSString *)content title:(NSString *)title icon:(NSString *)icon{

    NSMutableDictionary *shareParams0 = [NSMutableDictionary dictionary];
    NSURL *url = [NSURL URLWithString:href];
    [shareParams0 SSDKSetupShareParamsByText:content images:@[icon] url:url title:title type:SSDKContentTypeAuto];
    
    [shareParams0 SSDKSetupSinaWeiboShareParamsByText:[NSString stringWithFormat:@"%@ %@",content,href] title:title images:@[icon] video:nil url:nil latitude:0.0 longitude:0.0 objectID:nil isShareToStory:NO type:SSDKContentTypeAuto];
    
    [shareParams0 SSDKSetupWeChatParamsByText:content title:title url:url thumbImage:nil image:@[icon] musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil sourceFileExtension:nil sourceFileData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatSession];
    
    [shareParams0 SSDKSetupWeChatParamsByText:content title:title url:url thumbImage:nil image:@[icon] musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil sourceFileExtension:nil sourceFileData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
    
//    [shareParams0 SSDKSetupQQParamsByText:content title:title url:url audioFlashURL:nil videoFlashURL:nil thumbImage:nil images:images0 type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformTypeQQ];
    
    [ShareSDK showShareActionSheet:self.view items:nil shareParams:shareParams0 onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                [self loadShareSuccessData];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                    message:nil
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                [alertView show];
                break;
            }
            case SSDKResponseStateFail:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                message:[NSString stringWithFormat:@"%@",error]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                [alert show];
                break;
            }
            default:
                break;
        }
    }];
}

#pragma mark 分享成功后的接口
- (void)loadShareSuccessData{
    if (_isChristmasList) {
        NSString *path = @"turntableSharing";
        NSDictionary *params = @{@"uid":KUID};
        [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
            NSDictionary *dic = (NSDictionary *)json;
            if ([dic[@"code"] integerValue] == 200) {
                self.item.openUrl = [NSString stringWithFormat:@"%@?uid=%@",@"http://api.wawa.lkmai.com/turntable",KUID];
                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.item.openUrl]];
                [self.webView loadRequest:request];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }
    NSString *path = @"raw_award";
    NSDictionary *params = @{@"uid":KUID,@"type":@"share_game"};
    [DYGHttpTool postWithURL:path params:params sucess:^(id json) {
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

- (UIView *)progressView
{
    if (!_progressView) {
        _progressView = [[UIView alloc]initWithFrame:CGRectZero];
        //进度条的y值根据导航条是否透明会有变化
        _progressView.y = 0;
        _progressView.height = 2.0;
        _progressView.backgroundColor = [UIColor greenColor];
    }
    return _progressView;
}

@end
