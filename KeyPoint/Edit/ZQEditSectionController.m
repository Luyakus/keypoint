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
    [self bind];
}

#pragma mark - 业务逻辑

- (void)bind {
    [self.sectionTitleTf.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        if (x.length > 0) {
            self.confirmBtn.userInteractionEnabled = YES;
            self.confirmBtn.backgroundColor = [UIColor colorWithRGB:0x1296db];
        } else {
            self.confirmBtn.userInteractionEnabled = NO;
            self.confirmBtn.backgroundColor = [UIColor colorWithRGB:0xdddddd];
        }
    }];
}

- (void)confirm {
    if (self.sectionTitleTf.text.length == 0) {
        [self toast:@"请输入分类名称"];
        return;
    }
    
    @weakify(self)
    ZQSimplePostRequest *r = [ZQSimplePostRequest new];
    r.url = self.section.sectionId.length == 0 ? @"Type/addType" : @"Type/upType";
    r.arguments = ({
        NSDictionary *dic = nil;
        if (self.section.sectionId.length == 0) {
            dic = @{
                @"sign":ZQStatusDB.signCode?:@"",
                @"typeName":self.sectionTitleTf.text
            };
        } else {
            dic = @{
                @"id":self.section.sectionId,
                @"typeName":self.sectionTitleTf.text
            };
        }
        dic;
    });
    [self showLoading];
    [r startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        @strongify(self)
        [self hideLoading];
        if (r.resultCode != 1) {
            [self toast:r.errorMessage];
        }
        if (self.editCompletionBlock) {
            self.editCompletionBlock();
        }
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self hideLoading];
        [self toast:@"网络错误"];
        if (self.editCompletionBlock) {
            self.editCompletionBlock();
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
}


#pragma mark - 准备工作
- (void)ui {
    self.title = self.section.sectionId.length == 0 ? @"添加分类" : @"编辑分类";
    
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
        [b addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
        _confirmBtn = b;
        b;
    });
}

- (UITextField *)sectionTitleTf {
    return _sectionTitleTf ?: ({
        UITextField *t = [[UITextField alloc] initWithFrame:CGRectZero];
        t.placeholder = @"请输入网站分类";
        _sectionTitleTf = t;
        t;
    });
}

@end
