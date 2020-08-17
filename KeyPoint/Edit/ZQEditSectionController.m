//
//  ZQEditSectionController.m
//  KeyPoint
//
//  Created by Sam on 2020/8/16.
//  Copyright © 2020 Sam. All rights reserved.
//

#import "ZQEditSectionController.h"

@interface ZQEditSectionController ()
@property (nonatomic, weak) UIButton *confirmBtn;
@property (nonatomic, weak) UITextField *sectionTitleTf;
@property (nonatomic, strong) ZQSectionWebsiteModel *section;
@property (nonatomic, copy) void(^editCompletionBlock)(void);
@end

@implementation ZQEditSectionController
- (instancetype)initWithSection:(ZQSectionWebsiteModel *)section editCompletionBlock:(nonnull void (^)(void))block {
    if (self = [super init]) {
        self.section = section;
        self.editCompletionBlock = block;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self ui];
}

- (void)ui {
    self.title = @"编辑分类";
    
    UIView *sectionTitleHolder = [UIView new];
    sectionTitleHolder.qmui_borderPosition = QMUIViewBorderPositionBottom;
    sectionTitleHolder.qmui_borderLocation = QMUIViewBorderLocationOutside;
    sectionTitleHolder.qmui_borderWidth = 2;
    sectionTitleHolder.qmui_borderColor = [UIColor colorWithRGB:0x1296db];
    [self.view addSubview:sectionTitleHolder];
    [sectionTitleHolder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.mas_equalTo(60);
    }];
    
    
    [sectionTitleHolder addSubview:self.sectionTitleTf];
    self.sectionTitleTf.text = self.section.sectionTitle;
    [self.sectionTitleTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.bottom.equalTo(sectionTitleHolder);
        make.left.equalTo(sectionTitleHolder).offset(15);
        make.right.equalTo(sectionTitleHolder).offset(-15);
    }];
    
    [self.view addSubview:self.confirmBtn];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.bottom.equalTo(self.view.mas_bottom).offset(-50);
        make.height.mas_equalTo(40);
    }];
      
}


- (UIButton *)confirmBtn {
    return _confirmBtn ?: ({
        UIButton *b = [UIButton buttonWithType:UIButtonTypeSystem];
        b.titleLabel.font = [UIFont systemFontOfSize:15];
        b.backgroundColor = [UIColor colorWithRGB:0x1296db];
        [b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [b setTitle:@"确定" forState:UIControlStateNormal];
        _confirmBtn = b;
        b;
    });
}

- (UITextField *)sectionTitleTf {
    return _sectionTitleTf ?: ({
        UITextField *t = [[UITextField alloc] initWithFrame:CGRectZero];
        _sectionTitleTf = t;
        t;
    });
}

@end
