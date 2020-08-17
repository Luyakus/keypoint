//
//  ZQWebsiteCell.m
//  KeyPoint
//
//  Created by Sam on 2020/6/19.
//  Copyright © 2020 Sam. All rights reserved.
//
#import "ZQWebsiteModel.h"
#import "ZQWebsiteCell.h"

@interface ZQWebsiteCell()
@property (nonatomic, weak) UILabel *title;
@property (nonatomic, weak) UILabel *url;
@end
@implementation ZQWebsiteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.title];
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.top.bottom.equalTo(self.contentView);
            make.height.greaterThanOrEqualTo(@50);
            make.width.equalTo(@80);
        }];
        
        [self.contentView addSubview:self.url];
        [self.url mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.title.mas_right).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
            make.top.equalTo(self.contentView).offset(15);
            make.bottom.equalTo(self.contentView).offset(-15);
        }];
        
    }
    return self;
}

- (void)bind:(ZQWebsiteModel *)model {
    self.title.text = model.title;
    self.url.text = model.url;
}

- (UILabel *)title {
    return _title ?: ({
        UILabel *l = [UILabel new];
        l.font = [UIFont systemFontOfSize:14];
        l.numberOfLines = 0;
        l.textColor = [UIColor colorWithRGB:0x666666];
        _title = l;
        l;
    });
}


- (UILabel *)url {
    return _url ?: ({
        UILabel *l = [UILabel new];
        l.font = [UIFont systemFontOfSize:14];
        l.numberOfLines = 0;
        l.textColor = [UIColor colorWithRGB:0x999999];
        _url = l;
        l;
    });
}
@end
