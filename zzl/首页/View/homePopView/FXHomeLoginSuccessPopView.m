//
//  FXHomeLoginSuccessPopView.m
//  zzl
//
//  Created by Mr_Du on 2017/11/24.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import "FXHomeLoginSuccessPopView.h"

@interface FXHomeLoginSuccessPopView()

@property (weak, nonatomic) IBOutlet UILabel *detailL;
@property (weak, nonatomic) IBOutlet UILabel *tomorrowDetailL;

@end

@implementation FXHomeLoginSuccessPopView

- (void)awakeFromNib{
    [super awakeFromNib];

}

- (IBAction)sureClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(dealThingAfterSuccess)]) {
        [self.delegate dealThingAfterSuccess];
    }
    [self removeFromSuperview];
}

- (void)setMoney:(NSString *)money{
    _money = money;
    self.detailL.text = [NSString stringWithFormat:@"娃娃币+%@",money];
    self.tomorrowDetailL.text = [NSString stringWithFormat:@"明天签到可领取%@娃娃币哦！",money];
}
@end
