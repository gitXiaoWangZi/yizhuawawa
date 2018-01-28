//
//  QMXingXiuHeaderReusableView.m
//  zzl
//
//  Created by Mr_Du on 2018/1/28.
//  Copyright © 2018年 Mr.Du. All rights reserved.
//

#import "QMXingXiuHeaderReusableView.h"
#import "DYGTapGestureRecognizer.h"

@interface QMXingXiuHeaderReusableView()<UIScrollViewDelegate>

@property(nonatomic,strong)UIScrollView * MyScrollView;
@property(nonatomic,weak)UIPageControl *paegController;
@property(nonatomic,weak)UIButton * selectBtn;
@property (nonatomic,strong) UIImageView *defaultImgV;

@end

@implementation QMXingXiuHeaderReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = DYGColorFromHex(0xf3f6f9);
        [self creatSubViews];
    }
    return self;
}

-(void)creatSubViews{
    self.MyScrollView = [UIScrollView new];
    self.MyScrollView.pagingEnabled = YES;
    self.MyScrollView.delegate = self;
    self.MyScrollView.backgroundColor = [UIColor whiteColor];
    self.MyScrollView.frame = CGRectMake(0, 0, kScreenWidth, Py(165));
    [self addSubview:self.MyScrollView];
    
    if (self.adArray.count == 0) {
        self.defaultImgV = [UIImageView new];
        self.defaultImgV.frame = self.MyScrollView.bounds;
        self.defaultImgV.image = [UIImage imageNamed:@"home_banner_default"];
        [self addSubview:self.defaultImgV];
    }else{
        self.MyScrollView.contentSize = CGSizeMake(self.adArray.count*kScreenWidth, 0);
        self.MyScrollView.showsHorizontalScrollIndicator = NO;
        for (int i = 0; i<self.adArray.count; i++) {
            self.scrollImage = [[UIImageView alloc]initWithFrame:CGRectMake(i*kScreenWidth, 0, kScreenWidth, self.MyScrollView.height)];
            self.scrollImage.backgroundColor =randomColor;
            NSString * urlStr = self.adArray[i];
            [self.scrollImage sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"home_banner_default"]];
            self.scrollImage.tag = i;
            self.scrollImage.userInteractionEnabled = YES;
            DYGTapGestureRecognizer * tap = [[DYGTapGestureRecognizer alloc]initWithTarget:self action:@selector(imgDidClick:)];
            tap.tag = i;
            [self.scrollImage addGestureRecognizer:tap];
            [self.MyScrollView addSubview:self.scrollImage];
        }
    }
    
    UIPageControl * page = [[UIPageControl alloc]init];
    self.paegController = page;
    page.numberOfPages = self.adArray.count;
    page.pageIndicatorTintColor = [UIColor whiteColor];
    page.currentPageIndicatorTintColor = [UIColor orangeColor];
    [self addSubview:page];
    CGFloat h = (CGFloat )16/1334;
    [page mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.MyScrollView.mas_bottom).offset(kScreenHeight * h);
        make.centerX.equalTo(self.mas_centerX);
    }];
}
-(void)imgDidClick:(DYGTapGestureRecognizer *)tap{
    [self.timer invalidate];
    self.timer = nil;
    if ([self.delegate respondsToSelector:@selector(loadWebViewWithImgIndex:)]) {
        [self.delegate loadWebViewWithImgIndex:tap.tag];
    }
    
}
//滑动的方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    int page = (self.MyScrollView.contentOffset.x + self.MyScrollView.frame.size.width * 0.5 )/self.MyScrollView.frame.size.width;
    self.paegController.currentPage = page;
    
}

-(void)changeScrollView{
    
    if (self.MyScrollView.contentOffset.x >=self.MyScrollView.bounds.size.width * (self.adArray.count-1)) {
        [self.MyScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }else{
        CGPoint offset = self.MyScrollView.contentOffset;
        offset.x += self.MyScrollView.frame.size.width;
        [self.MyScrollView setContentOffset:offset animated:YES];
    }
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self starTimer];
}
//设置定时器;
-(void)starTimer{
    
    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(changeScrollView) userInfo:nil repeats:YES];
    self.timer = timer;
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

//当手指按上去的时候，移除定时器
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //    让定时器失效， 当定时器失效 再去调用fire无法重新开启。
    [self.timer invalidate];
    
    self.timer = nil;
}
-(void)setAdArray:(NSArray *)adArray{
    _adArray =adArray;
    for (UIView * v in self.subviews) {
        [v removeFromSuperview];
    }
    [self creatSubViews];
}
-(void)setScrollAdArr:(NSArray *)scrollAdArr{
    _scrollAdArr = scrollAdArr;
    for (UIView * v in self.subviews) {
        [v removeFromSuperview];
    }
    [self creatSubViews];
}
@end
