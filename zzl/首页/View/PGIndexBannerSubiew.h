//
//  PGIndexBannerSubiew.h
//  NewPagedFlowViewDemo
//
//  Created by Mars on 16/6/18.
//  Copyright © 2016年 Mars. All rights reserved.
//  Designed By PageGuo,
//  QQ:799573715
//  github:https://github.com/PageGuo/NewPagedFlowView

/******************************
 
 可以根据自己的需要再次重写view
 
 ******************************/

#import <UIKit/UIKit.h>
@class PGIndexBannerSubiew;

@protocol DYGMoreBtnClickDelegate<NSObject>

@optional
-(void)moreBtnDidClick;

@end

@interface PGIndexBannerSubiew : UIView

/**
 *  主图
 */
@property (nonatomic, strong) UIImageView *mainImageView;

/**
 *  用来变色的view
 */
@property (nonatomic, strong) UIView *coverView;
@property(nonatomic,weak)id<DYGMoreBtnClickDelegate>delegate;

/**
 *  房间模型
 */
@property (nonatomic,strong) WwRoom *model;
@property (nonatomic,assign) CGFloat currentScore;
@end
