//
//  NewViewCell.m
//  Recreation
//
//  Created by 李洋 on 16/4/19.
//  Copyright © 2016年 李洋. All rights reserved.
//

#import "ZXLatestLiveCell.h"

@interface ZXLatestLiveCell()

//背景图片
@property (weak, nonatomic) IBOutlet UIImageView *portraitImageView;

//热门标签
@property (weak, nonatomic) IBOutlet UIImageView *rightHotView;

//娃娃昵称
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

//机器状态
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

//娃娃所需金额
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

//娃娃等级图标
@property (weak, nonatomic) IBOutlet UIImageView *levelImg;

@property (weak, nonatomic) IBOutlet UIView *bottomSep;

@property (weak, nonatomic) IBOutlet UIView *rightSep;

@property (weak, nonatomic) IBOutlet UIImageView *priceTipImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameRight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLeft;

@end

@implementation ZXLatestLiveCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
}

- (void)loadWithData:(WwRoom *)data itemIndex:(NSInteger)rowIndex{
    self.nameLabel.text = data.wawa.name;
    [self.portraitImageView sd_setImageWithURL:[NSURL URLWithString:data.wawa.pic]];
    self.countLabel.text = [NSString stringWithFormat:@"%zd/次",data.wawa.coin];
    
    NSString * des = nil;
    NSString *imageName = @"room_idle";
    UIColor *color = DYGColorFromHex(0x000000);
    if (data.state == 2) {
        //空闲
        imageName = @"room_idle";
        color = DYGColorFromHex(0x1dd8e4);
        des = @"空闲中";
    }
    else if (data.state > 2) {
        imageName = @"room_use";
        color = DYGColorFromHex(0xff688f);
        des = @"游戏中";
    }
    else if (data.state == 1) {
        color = DYGColorFromHex(0xffbf24);
        imageName = @"room_buhuo";
        des = @"补货中";
    }
    self.statusLabel.textColor = color;
    self.statusLabel.text = des;
}

#pragma mark - Helper

- (CAShapeLayer *)maskCorner:(UIRectCorner)corner andRadii:(CGSize)size
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corner  cornerRadii:size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    return maskLayer;
}




@end
