//
//  ZQCollectController.m
//  KeyPoint
//
//  Created by Sam on 2020/6/19.
//  Copyright © 2020 Sam. All rights reserved.
//
// M
#import "ZQWebsiteModel.h"
// V
#import "ZQWebsiteCell.h"

// C
#import "ZQCollectController.h"

@interface ZQCollectController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tb;
@property (nonatomic, strong) NSArray <ZQWebsiteModel *> *websites;

@end

@implementation ZQCollectController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self ui];
    [self update];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

#pragma mark - 业务逻辑
- (void)update {
    if (!ZQStatusDB.isLogin) {
        self.emptyView.textLabel.text = @"请先登录";
        [self showEmptyView];
        return;
    } else {
        [self hideEmptyView];
    }
    [self.tb.mj_header beginRefreshing];
}

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

    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"" message:@"提示" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *a = [UIAlertAction actionWithTitle:@"复制网站名称" style:UIAlertActionStyleDefault handler:^(__kindof UIAlertAction * _Nonnull action) {
        UIPasteboard.generalPasteboard.string = model.title;
    }];
    
    UIAlertAction *b = [UIAlertAction actionWithTitle:@"复制网站地址" style:UIAlertActionStyleDefault handler:^(__kindof UIAlertAction * _Nonnull action) {
        UIPasteboard.generalPasteboard.string = model.url;
    }];
    
    UIAlertAction *c = [UIAlertAction actionWithTitle:@"打开网站" style:UIAlertActionStyleDefault handler:^(__kindof UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.url]];
    }];
    
    UIAlertAction *d = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(__kindof UIAlertAction * _Nonnull action) {
    }];
    
    [vc addAction:a];
    [vc addAction:b];
    [vc addAction:c];
    [vc addAction:d];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    ZQWebsiteModel *model = self.websites[indexPath.row];
    ZQSimpleGetRequest *r = [ZQSimpleGetRequest new];
    r.url = @"Collectphone/delCollect";
    r.arguments = @{
        @"id":model.identifier?:@"",
        @"sign":ZQStatusDB.signCode
    };
    [r startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (r.resultCode == 1) {
            [self toast:@"已删除"];
            [self update];
        } else {
            [self toast:r.errorMessage];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self toast:@"网络错误"];
    }];
}


- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}



#pragma mark - 准备工作
- (void)ui {
    self.view.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.tb];
    [self.tb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
}

- (void)data {
    ZQSimplePostRequest *r = [ZQSimplePostRequest new];
    r.arguments = @{
        @"sign":ZQStatusDB.signCode?:@""
    };
    r.url = @"Collectphone/collectList";
    [r startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.tb.mj_header endRefreshing];
        if (r.resultCode == 1) {
            NSArray *arr = [NSArray modelArrayWithClass:ZQWebsiteModel.class json:r.responseJSONObject[@"list"]];
            self.websites = arr;
            [self.tb reloadData];
        } else {
            [self toast:r.errorMessage];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self toast:@"网络错误"];
        [self.tb.mj_header endRefreshing];
    }];
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