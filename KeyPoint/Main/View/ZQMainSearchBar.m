//
//  ZQMainSearchBar.m
//  KeyPoint
//
//  Created by Sam on 2020/6/10.
//  Copyright © 2020 Sam. All rights reserved.
//

#import "ZQMainSearchBar.h"
@interface ZQMainSearchBar()
@property (nonatomic, strong) MASConstraint *addBtnLeftOffsetConstraint;
@end
@implementation ZQMainSearchBar

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}


- (void)setup {
    self.layer.shadowRadius = 0.2;
    self.layer.shadowOffset = CGSizeMake(0, 1);
       
    UIView *searchBarHolderView = [UIView new];
    searchBarHolderView.backgroundColor = [UIColor whiteColor];
    searchBarHolderView.layer.borderWidth = 1;
    searchBarHolderView.layer.borderColor = [UIColor colorWithRGB:0xdddddd].CGColor;
    [self addSubview:searchBarHolderView];
    [searchBarHolderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];
   
    [searchBarHolderView addSubview:self.addBtn];
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(searchBarHolderView);
       self.addBtnLeftOffsetConstraint = make.left.equalTo(searchBarHolderView).offset(15);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    
    [searchBarHolderView addSubview:self.avatarBtn];
    [self.avatarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(searchBarHolderView);
        make.right.equalTo(searchBarHolderView).offset(-15);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    
    UIView *searchtfHolderView = [UIView new];
    searchtfHolderView.layer.borderColor = [UIColor colorWithRGB:0xdddddd].CGColor;
    searchtfHolderView.layer.borderWidth = 0.5f;
    searchtfHolderView.layer.cornerRadius = 4;
    [searchBarHolderView addSubview:searchtfHolderView];
    [searchtfHolderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addBtn.mas_right).offset(10);
        make.right.equalTo(self.avatarBtn.mas_left).offset(-10);
        make.top.equalTo(searchBarHolderView).offset(10);
        make.bottom.equalTo(searchBarHolderView).offset(-10);
    }];
    
    [searchtfHolderView addSubview:self.searchBtn];
    [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(searchtfHolderView);
        make.width.equalTo(self.searchBtn.mas_height);
    }];
    
    UIView *divideView = [UIView new];
    divideView.backgroundColor = [UIColor colorWithRGB:0xdddddd];
    [searchtfHolderView addSubview:divideView];
    [divideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(searchtfHolderView);
        make.right.equalTo(self.searchBtn.mas_left);
        make.width.mas_equalTo(0.5);
    }];
    
    [searchtfHolderView addSubview:self.searchTf];
    [self.searchTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(searchtfHolderView);
        make.left.equalTo(searchtfHolderView).offset(10);
        make.right.equalTo(divideView.mas_left).offset(-10);
        make.top.equalTo(searchtfHolderView).offset(5);
        make.bottom.equalTo(searchtfHolderView).offset(-5);
    }];
    
//    UIView *bottomDivideView = [UIView new];
//    bottomDivideView.backgroundColor = [UIColor colorWithRGB:0xdddddd];
//    [searchBarHolderView addSubview:bottomDivideView];
//    [bottomDivideView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.left.right.equalTo(searchBarHolderView);
//        make.height.mas_equalTo(1);
//    }];
}

- (UIButton *)addBtn {
    return _addBtn ?: ({
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        [b setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        _addBtn = b;
        b;
    });
}

- (UIButton *)searchBtn {
    return _searchBtn ?: ({
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        [b setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
        _searchBtn = b;
        b;
    });
}

- (UIButton *)avatarBtn {
    return _avatarBtn ?: ({
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        [b setImage:[UIImage imageNamed:@"avatar"] forState:UIControlStateNormal];
        _avatarBtn = b;
        b;
    });
}

- (UITextField *)searchTf {
    return _searchTf ?: ({
        UITextField *t = [[UITextField alloc] initWithFrame:CGRectZero];
        _searchTf = t;
        t;
    });
}
@end
