//
//  FXHomeSignPopView.m
//  zzl
//
//  Created by Mr_Du on 2017/11/23.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXHomeSignPopView.h"
#import "UIButton+Position.h"

@interface FXHomeSignPopView()
@property (weak, nonatomic) IBOutlet UILabel *dayNumL;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imgBgArray;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *diamoLArray;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *signediconArr;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *dayNumArr;


@end

@implementation FXHomeSignPopView

- (void)awakeFromNib{
    [super awakeFromNib];
}

- (IBAction)dismissClick:(UIButton *)sender {
    [self removeFromSuperview];
}

- (IBAction)loginClick:(UIButton *)sender {
    if (self.signActionBlock) {
        self.signActionBlock(_dataDic[@"continuity"]);
    }
}

- (void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    NSArray *dataArr = dataDic[@"data"];
    self.dayNumL.text = [NSString stringWithFormat:@"连续签到%@天",dataDic[@"continuity"]];
    for (NSInteger i = 0; i < dataArr.count; i ++) {
        NSDictionary *dic = dataArr[i];
        UILabel *label = self.diamoLArray[i];
        label.text = [NSString stringWithFormat:@"%@娃娃币",dic[@"money"]];
    }
    
    NSInteger continuity = [dataDic[@"continuity"] integerValue];
    for (NSInteger i = 0; i < continuity; i ++) {
        UILabel *label = self.diamoLArray[i];
        label.hidden = YES;
        UILabel *labels = self.dayNumArr[i];
        labels.hidden = YES;
        UIImageView *signedImgV = self.signediconArr[i];
        signedImgV.hidden = NO;
    }
    for (NSInteger i = continuity; i < dataArr.count; i ++) {
        UILabel *label = self.diamoLArray[i];
        label.hidden = NO;
        UILabel *labels = self.dayNumArr[i];
        labels.hidden = NO;
        UIImageView *signedImgV = self.signediconArr[i];
        signedImgV.hidden = YES;
    }
    
    
    
}
@end
