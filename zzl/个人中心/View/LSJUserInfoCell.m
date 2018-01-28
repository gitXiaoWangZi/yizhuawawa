//
//  LSJUserInfoCell.m
//  yizhuawawa
//
//  Created by Mr_Du on 2018/1/25.
//  Copyright © 2018年 Mr.Liu. All rights reserved.
//

#import "LSJUserInfoCell.h"

@interface LSJUserInfoCell()
@end

@implementation LSJUserInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.icon];
        [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(Px(18));
            make.centerY.equalTo(self);
        }];
        [self addSubview:self.titleL];
        [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.icon.mas_right).offset(Px(18));
            make.centerY.equalTo(self);
        }];
        [self addSubview:self.desImgV];
        [self.desImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-Px(18));
            make.centerY.equalTo(self);
        }];
    }
    return self;
}


#pragma mark lazyload
-  (UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
    }
    return _icon;
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc] init];
        _titleL.textColor = DYGColorFromHex(0x4c4c4c);
        _titleL.font = kPingFangSC_Regular(15);
    }
    return _titleL;
}
-  (UIImageView *)desImgV{
    if (!_desImgV) {
        _desImgV = [[UIImageView alloc] init];
    }
    return _desImgV;
}
@end
