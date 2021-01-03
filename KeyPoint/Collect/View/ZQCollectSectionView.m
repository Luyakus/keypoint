//
//  ZQCollectSectionView.m
//  KeyPoint
//
//  Created by Sam on 2020/8/16.
//  Copyright © 2020 Sam. All rights reserved.
//
#import "ZQSectionWebsiteModel.h"
#import "ZQCollectSectionView.h"

@interface ZQCollectSectionView()
@property (nonatomic, weak) UILabel *title;
@property (nonatomic, weak) UIButton *editBtn;
@property (nonatomic, strong) ZQSectionWebsiteModel *model;
@end
@implementation ZQCollectSectionView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self ui];
    }
    return self;
}

- (void)bind:(ZQSectionWebsiteModel *)model {
    self.model = model;
    self.title.text = model.sectionTitle;
    self.editBtn.hidden = model.sectionId.length == 0;
    [self.title sizeToFit];
}


- (void)ui {
    [self.contentView addSubview:self.editBtn];
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.right.equalTo(self.contentView).offset(-15);
    }];
    [self.contentView addSubview:self.title];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(15);
        make.bottom.equalTo(self.contentView).offset(-15);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.editBtn.mas_left).offset(-15);
    }];
    @weakify(self)
    [[self.editBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        if (self.editBlock) {
            self.editBlock(self.model);
        }
    }];
    
    
}

- (UIButton *)editBtn {
    return _editBtn ?: ({
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        [b setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
        _editBtn = b;
        b;
    });
}

- (UILabel *)title {
    return _title ?: ({
        UILabel *l = [UILabel new];
        l.font = [UIFont systemFontOfSize:15];
        l.numberOfLines = 0;
        l.textColor = [UIColor systemBlueColor];
        _title = l;
        l;
    });
}


@end
