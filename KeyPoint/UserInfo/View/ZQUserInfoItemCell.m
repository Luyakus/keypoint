//
//  ZQUserInfoItemCell.m
//  KeyPoint
//
//  Created by Sam on 2020/6/10.
//  Copyright © 2020 Sam. All rights reserved.
//

#import "ZQUserInfoItemCell.h"
@interface ZQUserInfoItemCell()
@property (nonatomic, strong) UILabel *title;
@end
@implementation ZQUserInfoItemCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.title = [UILabel new];
        self.title.numberOfLines = 0;
        [self.contentView addSubview:self.title];
        self.title.font = [UIFont systemFontOfSize:16];
        self.title.textColor = [UIColor colorWithRGB:0x999999];
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(15);
            make.height.equalTo(self.contentView);
            make.width.mas_equalTo(150);
        }];
        
        UILabel *l = [UILabel new];
        [self.contentView addSubview:l];
        l.font = [UIFont systemFontOfSize:14];
        l.textColor = [UIColor colorWithRGB:0xcccccc];
        l.text = @"复制";
        [l mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-45);
            make.height.mas_equalTo(40);
        }];
        
        UIImageView *arrow = [UIImageView new];
        [self.contentView addSubview:arrow];
        arrow.image = [UIImage imageNamed:@"arrow"];
        [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-15);
            make.size.mas_equalTo(CGSizeMake(18, 18));
        }];
        
        
        self.contentView.qmui_borderColor = [UIColor colorWithRGB:0xdddddd];
        self.contentView.qmui_borderPosition = QMUIViewBorderPositionBottom;
        self.contentView.qmui_borderWidth = 0.5;
    }
    return self;
}


- (void)bind:(NSString *)sign {
    self.title.text = sign;
    [self.title sizeToFit];
}

@end
