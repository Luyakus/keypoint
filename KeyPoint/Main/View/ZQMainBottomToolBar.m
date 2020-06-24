//
//  ZQMainBottomToolBar.m
//  KeyPoint
//
//  Created by Sam on 2020/6/19.
//  Copyright © 2020 Sam. All rights reserved.
//

#import "ZQMainBottomToolBar.h"
@interface ZQMainBottomToolBar()
@property (nonatomic, strong) UIView *left;
@property (nonatomic, strong) UIView *right;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@end
@implementation ZQMainBottomToolBar

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.left = [UIView new];
        self.right = [UIView new];
        self.leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        self.leftBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        self.rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:13];

        self.left.backgroundColor = [UIColor colorWithRGB:0x1296db];
        [self.leftBtn setTitleColor:[UIColor colorWithRGB:0x1296db] forState:UIControlStateNormal];
        
        self.right.backgroundColor = [UIColor whiteColor];
        [self.rightBtn setTitleColor:[UIColor colorWithRGB:0x333333] forState:UIControlStateNormal];

        [self setup];
        [self bind];
    }
    return self;
}

- (void)bind {
    @weakify(self)
    [[self.leftBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        self.left.backgroundColor = [UIColor colorWithRGB:0x1296db];
        [self.leftBtn setTitleColor:[UIColor colorWithRGB:0x1296db] forState:UIControlStateNormal];
        
        self.right.backgroundColor = [UIColor whiteColor];
        [self.rightBtn setTitleColor:[UIColor colorWithRGB:0x333333] forState:UIControlStateNormal];
    }];
    
    [[self.rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        self.right.backgroundColor = [UIColor colorWithRGB:0x1296db];
        [self.rightBtn setTitleColor:[UIColor colorWithRGB:0x1296db] forState:UIControlStateNormal];
        
        self.left.backgroundColor = [UIColor whiteColor];
        [self.leftBtn setTitleColor:[UIColor colorWithRGB:0x333333] forState:UIControlStateNormal];
    }];
}

- (void)setup {
    self.qmui_borderPosition = QMUIViewBorderPositionTop;
    self.qmui_borderWidth = 1;
    self.qmui_borderColor = [UIColor colorWithRGB:0xdddddd];
    
    [self addSubview:self.left];
    [self.left mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(2);
        make.bottom.equalTo(self).offset(-5);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self.mas_centerX).offset(-20);
    }];
    
    [self addSubview:self.leftBtn];
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.height.mas_equalTo(40);
        make.left.equalTo(self).offset(8);
        make.right.equalTo(self.mas_centerX).offset(-8);
    }];
    
    [self addSubview:self.right];
    [self.right mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(2);
        make.bottom.equalTo(self).offset(-5);
        make.left.equalTo(self.mas_centerX).offset(20);
        make.right.equalTo(self).offset(-20);
    }];
    
    [self addSubview:self.rightBtn];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.height.mas_equalTo(40);
        make.right.equalTo(self).offset(-8);
        make.left.equalTo(self.mas_centerX).offset(8);
    }];
}
@end
