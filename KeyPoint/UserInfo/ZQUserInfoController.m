//
//  ZQUserInfoController.m
//  KeyPoint
//
//  Created by Sam on 2020/6/10.
//  Copyright © 2020 Sam. All rights reserved.
//
// M
#import "ZQUserInfoRequest.h"
// V
#import "ZQUserInfoAvatarCell.h"
#import "ZQUserInfoItemCell.h"
// C
#import "ZQUserInfoController.h"


@interface ZQUserInfoController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tb;
@property (nonatomic, weak) UIButton *logoutBtn;
@property (nonatomic, copy) NSString *phoneNum;
@property (nonatomic, copy) NSString *sign;
@end

@implementation ZQUserInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showEmptyView];
    [self ui];
    [self bind];
}
#pragma mark - 业务逻辑
- (void)bind {
    ZQUserInfoRequest *r = [ZQUserInfoRequest new];
    NSLog(@"%@", ZQStatusDB.signCode);
    [r startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (r.resultCode == 1) {
            NSString *phoneNum = r.responseJSONObject[@"info"][@"user"];
            NSString *sign = r.responseJSONObject[@"info"][@"sign"];
            self.phoneNum = phoneNum;
            self.sign = sign;
            [self.tb reloadData];
        } else {
            [self toast:r.errorMessage];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self toast:@"网络错误"];
    }];
    @weakify(self)
    [[self.logoutBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        ZQStatusDB.isLogin = NO;
        ZQStatusDB.signCode = nil;
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - 代理方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ZQUserInfoAvatarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"avatar"];
        [cell bind:self.phoneNum];
        return cell;
    } else {
        ZQUserInfoItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"item"];
        [cell bind:self.sign];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 60;
    } else {
        return 60;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1 && self.sign.length > 0) {
        NSString *url = [NSString  stringWithFormat:@"https://tvtvc.com?sign=%@", self.sign];
        UIPasteboard.generalPasteboard.string = url;
        [self toast:@"已复制"];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

#pragma mark - 准备工作


- (void)ui {
    self.navigationController.navigationBar.hidden = NO;
    self.title = @"账户信息";
    
    UIView *bottomView = [UIView new];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
        make.height.mas_equalTo(70);
    }];
    
    [bottomView addSubview:self.logoutBtn];
    [self.logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(10, 15, 10, 15));
    }];
    
    [self.view addSubview:self.tb];
    [self.tb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(bottomView.mas_top);
    }];
}

- (UITableView *)tb {
    return _tb ?: ({
        UITableView *t = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        t.delegate = self;
        t.dataSource = self;
        t.separatorStyle = UITableViewCellSeparatorStyleNone;
        [t registerClass:[ZQUserInfoAvatarCell class] forCellReuseIdentifier:@"avatar"];
        [t registerClass:[ZQUserInfoItemCell class] forCellReuseIdentifier:@"item"];
        _tb = t;
        t;
    });
}

- (UIButton *)logoutBtn {
    return _logoutBtn ?: ({
        UIButton *b = [UIButton buttonWithType:UIButtonTypeSystem];
        b.backgroundColor = [UIColor whiteColor];
//        b.qmui_borderPosition = QMUIViewBorderPositionTop | QMUIViewBorderPositionBottom;
//        b.qmui_borderLocation = QMUIViewBorderLocationOutside;
//        b.qmui_borderWidth = 10;
//        b.qmui_borderColor = [UIColor colorWithRGB:0xeeeeee];
        b.titleLabel.font = [UIFont systemFontOfSize:16];
        [b setTitle:@"退出" forState:UIControlStateNormal];
        [b setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _logoutBtn = b;
        b;
    });
}
@end
