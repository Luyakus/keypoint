//
//  ZQEditWebsiteController.m
//  KeyPoint
//
//  Created by Sam on 2020/8/16.
//  Copyright © 2020 Sam. All rights reserved.
//

#import "ZQEditWebsiteController.h"

@interface ZQEditWebsiteController () <UIPickerViewDelegate, UITextFieldDelegate>
@property (nonatomic, weak) UITextField *websiteTitleTf;
@property (nonatomic, weak) UITextField *websiteUrlTf;
@property (nonatomic, weak) UITextField *websiteSectionTf;

@property (nonatomic, weak) UIButton *confirmBtn;

@property (nonatomic, copy) void(^editCompletionBlock)(void);
@property (nonatomic, strong) NSArray <ZQSectionWebsiteModel *> *sections;
@property (nonatomic, strong) ZQWebsiteModel *website;

@end

@implementation ZQEditWebsiteController

- (instancetype)initWithSections:(NSArray <ZQSectionWebsiteModel *> *)sections webSite:(ZQWebsiteModel *)website editCompletionBlock:(void(^)(void))block {
    if (self = [super init]) {
        self.sections = sections;
        self.website = website;
        self.editCompletionBlock = block;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self ui];
}

- (void)confirm {
    if (self.websiteTitleTf.text.length == 0) {
        [self toast:@"请输入网站名称"];
        return;
    }
    
    if (self.websiteUrlTf.text.length == 0) {
        [self toast:@"请输入网站地址"];
        return;
    }
    
    if (self.websiteSectionTf.text.length == 0) {
        [self toast:@"请选择网站分类"];
        return;
    }
}

- (void)selectSectionCancel {
    [self.websiteSectionTf resignFirstResponder];
}

- (void)selectSectionConfim {
    [self.websiteSectionTf resignFirstResponder];

}

#pragma mark - 协议
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.websiteSectionTf.text = @(row).stringValue;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 50;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 10;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return @"abc";
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return NO;
}

#pragma mark - 准备工作
- (void)ui {
    self.title = self.website.identifier.length == 0 ? @"添加网站" : @"编辑网站";
     UIView *websiteTitleHolder = [UIView new];
     websiteTitleHolder.qmui_borderPosition = QMUIViewBorderPositionBottom;
     websiteTitleHolder.qmui_borderLocation = QMUIViewBorderLocationOutside;
     websiteTitleHolder.qmui_borderWidth = 2;
     websiteTitleHolder.qmui_borderColor = [UIColor colorWithRGB:0x1296db];
     [self.view addSubview:websiteTitleHolder];
     [websiteTitleHolder mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo(self.view).offset(100);
         make.left.equalTo(self.view).offset(15);
         make.right.equalTo(self.view).offset(-15);
         make.height.mas_equalTo(60);
     }];
     
     
     [websiteTitleHolder addSubview:self.websiteTitleTf];
    self.websiteTitleTf.text = self.website.title;
     [self.websiteTitleTf mas_makeConstraints:^(MASConstraintMaker *make) {
         make.height.mas_equalTo(40);
         make.bottom.equalTo(websiteTitleHolder);
         make.left.equalTo(websiteTitleHolder).offset(15);
         make.right.equalTo(websiteTitleHolder).offset(-15);
     }];
    
    
    UIView *websiteUrlHolder = [UIView new];
    websiteUrlHolder.qmui_borderPosition = QMUIViewBorderPositionBottom;
    websiteUrlHolder.qmui_borderLocation = QMUIViewBorderLocationOutside;
    websiteUrlHolder.qmui_borderWidth = 2;
    websiteUrlHolder.qmui_borderColor = [UIColor colorWithRGB:0x1296db];
    [self.view addSubview:websiteUrlHolder];
    [websiteUrlHolder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(websiteTitleHolder.mas_bottom).offset(30);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.mas_equalTo(60);
    }];
    
    
    [websiteUrlHolder addSubview:self.websiteUrlTf];
    self.websiteUrlTf.text = self.website.url;
    [self.websiteUrlTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.bottom.equalTo(websiteUrlHolder);
        make.left.equalTo(websiteUrlHolder).offset(15);
        make.right.equalTo(websiteUrlHolder).offset(-15);
    }];
    
    UIView *websiteSectionHolder = [UIView new];
    websiteSectionHolder.qmui_borderPosition = QMUIViewBorderPositionBottom;
    websiteSectionHolder.qmui_borderLocation = QMUIViewBorderLocationOutside;
    websiteSectionHolder.qmui_borderWidth = 2;
    websiteSectionHolder.qmui_borderColor = [UIColor colorWithRGB:0x1296db];
    [self.view addSubview:websiteSectionHolder];
    [websiteSectionHolder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(websiteUrlHolder.mas_bottom).offset(30);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.mas_equalTo(60);
    }];
    
    
    [websiteSectionHolder addSubview:self.websiteSectionTf];
    self.websiteTitleTf.text = self.website.sectionTitle;
    [self.websiteSectionTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.bottom.equalTo(websiteSectionHolder);
        make.left.equalTo(websiteSectionHolder).offset(15);
        make.right.equalTo(websiteSectionHolder).offset(-15);
    }];
     
     [self.view addSubview:self.confirmBtn];
     [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.equalTo(self.view).offset(15);
         make.right.equalTo(self.view).offset(-15);
         make.bottom.equalTo(self.view.mas_bottom).offset(-50);
         make.height.mas_equalTo(40);
     }];
}


- (UITextField *)websiteTitleTf {
    return _websiteTitleTf ?: ({
        UITextField *t = [[UITextField alloc] initWithFrame:CGRectZero];
        t.placeholder = @"请输入网站名称";
        _websiteTitleTf = t;
        t;
    });
}


- (UITextField *)websiteUrlTf {
    return _websiteUrlTf ?: ({
        UITextField *t = [[UITextField alloc] initWithFrame:CGRectZero];
        t.placeholder = @"请输入网站地址";
        _websiteUrlTf = t;
        t;
    });
}


- (UITextField *)websiteSectionTf {
    return _websiteSectionTf ?: ({
        UITextField *t = [[UITextField alloc] initWithFrame:CGRectZero];
        t.placeholder = @"请输入网站地址";
        t.delegate = self;
        t.inputView = ({
            UIPickerView *p = [[UIPickerView alloc] init];
            p.delegate = self;
            p;
        });
        t.inputAccessoryView = ({
            UIToolbar *tool = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 50)];
            UIBarButtonItem *cancelItem =  [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(selectSectionCancel)];
            cancelItem.tintColor = [UIColor systemRedColor];
            UIBarButtonItem *space = [UIBarButtonItem qmui_flexibleSpaceItem];
            UIBarButtonItem *confirmItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(selectSectionConfim)];
            tool.items = @[cancelItem, space, confirmItem];
            tool;
        });
        _websiteSectionTf = t;
        t;
    });
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

@end
