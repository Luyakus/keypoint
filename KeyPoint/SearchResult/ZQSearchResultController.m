//
//  ZQSearchResultController.m
//  KeyPoint
//
//  Created by Sam on 2020/6/20.
//  Copyright © 2020 Sam. All rights reserved.
//

// M
#import "ZQWebsiteModel.h"
#import "ZQAddCommendRequest.h"
// V
#import "ZQWebsiteCell.h"
// C
#import "ZQSearchResultController.h"

typedef NS_ENUM(NSUInteger, ZQSearchActionFromType) {
    ZQSearchActionFromTypeCommend,
    ZQSearchActionFromTypeCollect,
};

@interface ZQSearchResultController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, copy) NSString *keyword;
@property (nonatomic, strong) UITableView *tb;
@property (nonatomic, strong) NSArray <ZQWebsiteModel *> *websites;
@property (nonatomic, assign) ZQSearchActionFromType from;
@end

@implementation ZQSearchResultController

- (instancetype)initWithKeyword:(NSString *)keyword {
    if (self = [super init]) {
        self.keyword = keyword;
        self.from = ZQSearchActionFromTypeCommend;
    }
    return self;
}

- (instancetype)initWithKeyword:(NSString *)keyword DataSource:(NSArray<ZQWebsiteModel *> *)websites {
    if (self = [super init]) {
        self.websites = websites;
        self.keyword = keyword;
        self.from = ZQSearchActionFromTypeCollect;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self ui];
    [self data];
}

#pragma mark - 业务逻辑
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.websites.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZQWebsiteModel *model = self.websites[indexPath.row];
    ZQWebsiteCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(ZQWebsiteCell.class)];
    [cell bind:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZQWebsiteModel *model = self.websites[indexPath.row];
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:model.url]]) return;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.url]];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.from == ZQSearchActionFromTypeCommend;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.from == ZQSearchActionFromTypeCollect) {
        return;
    }
    ZQWebsiteModel *model = self.websites[indexPath.row];
    ZQAddCommendRequest *r = [ZQAddCommendRequest requestWithWebsiteId:model.identifier];
    [r startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (r.resultCode == 1) {
            [self toast:@"添加成功"];
        } else {
            [self toast:r.errorMessage];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self toast:@"网络错误"];
    }];
}


- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.from == ZQSearchActionFromTypeCollect) {
        return nil;
    } else {
        return @"收藏";
    }
}


#pragma mark - 准备工作
- (void)ui {
    self.title = self.keyword;
    [self.view addSubview:self.tb];
    [self.tb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
}

- (void)data {
    if (self.from == ZQSearchActionFromTypeCollect) {
        NSArray <ZQWebsiteModel *> *websites = self.websites;
        self.websites = [[websites.rac_sequence filter:^BOOL(ZQWebsiteModel *value) {
            return [value.title containsString:self.keyword];
        }] array];
        [self.tb reloadData];
    } else {
        ZQSimplePostRequest *r = [ZQSimplePostRequest new];
        r.url = @"Recommend/selWenList";
        r.arguments = @{
            @"sign":ZQStatusDB.signCode?:@"",
            @"selName":self.keyword?:@""
        };
        [self showLoading];
        [r startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            [self hideLoading];
            if (r.resultCode == 1) {
                NSArray *arr = [NSArray modelArrayWithClass:ZQWebsiteModel.class json:r.responseJSONObject[@"list"]];
                self.websites = arr;
                [self.tb reloadData];
            } else {
                [self toast:r.errorMessage];
            }
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            [self hideLoading];
            [self toast:@"网络错误"];
        }];
    }
}


- (UITableView *)tb {
    return _tb ?: ({
        UITableView *t = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        t.delegate = self;
        t.dataSource = self;
        t.estimatedRowHeight = 40;
        t.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(data)];
        [t registerClass:[ZQWebsiteCell class] forCellReuseIdentifier:NSStringFromClass(ZQWebsiteCell.class)];
        _tb = t;
        t;
    });
}


@end
