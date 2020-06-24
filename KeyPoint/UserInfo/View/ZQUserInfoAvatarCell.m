//
//  ZQUserInfoAvatarCell.m
//  KeyPoint
//
//  Created by Sam on 2020/6/10.
//  Copyright © 2020 Sam. All rights reserved.
//

#import "ZQUserInfoAvatarCell.h"
@interface ZQUserInfoAvatarCell()
@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UILabel *title;
@end
@implementation ZQUserInfoAvatarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.avatar = [UIImageView new];
        [self.contentView addSubview:self.avatar];
        self.avatar.image = [UIImage imageNamed:@"user_avatar"];
        self.avatar.layer.cornerRadius = 20;
        self.avatar.layer.masksToBounds = YES;
        [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(15);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
        self.title = [UILabel new];
        [self.contentView addSubview:self.title];
        self.title.font = [UIFont systemFontOfSize:14];
        self.title.textColor = [UIColor colorWithRGB:0xcccccc];
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
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

- (void)bind:(NSString *)phone {
    self.title.text = phone;
    [self.title sizeToFit];
}

@end
