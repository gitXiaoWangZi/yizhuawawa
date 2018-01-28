//
//  QMXingXiuHeaderReusableView.h
//  zzl
//
//  Created by Mr_Du on 2018/1/28.
//  Copyright © 2018年 Mr.Du. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RMBMeButton;
@protocol QMXingXiuHeaderReusableViewDelegate <NSObject>

@optional
-(void)loadWebViewWithImgIndex:(NSInteger)index;

@end

@interface QMXingXiuHeaderReusableView : UICollectionReusableView

@property(nonatomic,weak)NSTimer * timer;
@property (nonatomic,strong) NSArray * adArray;
@property (nonatomic,strong) UIImageView * scrollImage;
@property (nonatomic,weak) id<QMXingXiuHeaderReusableViewDelegate> delegate;
@property (nonatomic,strong) NSArray *scrollAdArr;
-(void)starTimer;
-(void)beginScroll;
-(void)stopScroll;
@end
