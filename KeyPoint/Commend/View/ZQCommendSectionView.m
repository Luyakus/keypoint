//
//  ZQWebsiteSectionView.m
//  KeyPoint
//
//  Created by Sam on 2020/8/9.
//  Copyright © 2020 Sam. All rights reserved.
//

#import "ZQSectionWebsiteModel.h"
#import "ZQCommendSectionView.h"

@interface ZQCommendSectionView()
@property (nonatomic, weak) UILabel *title;
@end
@implementation ZQCommendSectionView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self ui];
    }
    return self;
}

- (void)bind:(ZQSectionWebsiteModel *)model {
    self.title.text = model.sectionTitle;
    [self.title sizeToFit];
}


- (void)ui {
    [self.contentView addSubview:self.title];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(15, 15, 15, 15));
    }];
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
