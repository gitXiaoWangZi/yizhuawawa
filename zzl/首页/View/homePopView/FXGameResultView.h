//
//  FXGameResultView.h
//  zzl
//
//  Created by Mr_Du on 2017/11/24.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,FXGameResultViewType) {
    FXGameResultViewTypeCancel,
    FXGameResultViewTypeBring,
};

@protocol FXGameResultViewDelegate<NSObject>

- (void)gameAgainAction;
- (void)cancelAction:(FXGameResultViewType)type;


@end

@interface FXGameResultView : UIView

@property (nonatomic,weak) id<FXGameResultViewDelegate> delegate;
@property (nonatomic,strong) UILabel *desL;
@property (nonatomic,assign) FXGameResultViewType type;

- (void)showStatusView:(BOOL)isSuccess;
@end

