//
//  FXNavigationController.m
//  zzl
//
//  Created by Mr_Du on 2017/10/30.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXNavigationController.h"
#import "UIImage+DYGAdd.h"
#import "LSJHomeViewController.h"
#import "FXSelfViewController.h"
#import "LSJGameViewController.h"
#import "LSJLoginController.h"
#import "LSJPhoneLoginViewController.h"
@interface FXNavigationController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@end

@implementation FXNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:19],NSForegroundColorAttributeName : DYGColorFromHex(0xffffff)}];
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"home_nav"] forBarMetrics:UIBarMetricsDefault];
//    self.navigationBar.backgroundColor = [UIColor whiteColor];
    self.navigationBar.tintColor = DYGColorFromHex(0xffffff);
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    //开启右滑返回功能
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    [self.navigationBar setShadowImage:[self imageWithColor:DYGColorFromHex(0xe6e6e6) size:CGSizeMake([UIScreen mainScreen].bounds.size.width, 0.5)]];
}
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
-(BOOL)hidesBottomBarWhenPushed{
    return YES;
}
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage rendModeOriginalWithName:@"backArrow"] style:0 target:self action:@selector(back)];
    }
    [super pushViewController:viewController animated:animated];
    
}
- (void)back {
    [self popViewControllerAnimated:YES];
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([viewController isKindOfClass:[LSJHomeViewController class]] || [viewController isKindOfClass:[FXSelfViewController class]] || [viewController isKindOfClass:[LSJGameViewController class]] || [viewController isKindOfClass:[LSJLoginController class]] || [viewController isKindOfClass:[LSJPhoneLoginViewController class]]) {
        [self setNavigationBarHidden:YES animated:YES];
    }else{
        [self setNavigationBarHidden:NO animated:YES];
    }
}
@end
