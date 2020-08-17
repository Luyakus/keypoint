//
//  ZQCommendController.m
//  KeyPoint
//
//  Created by Sam on 2020/6/19.
//  Copyright © 2020 Sam. All rights reserved.
//
// M
#import "ZQSectionWebsiteModel.h"
#import "ZQCommendAddRequest.h"

// V
#import "ZQCommendSectionView.h"
#import "ZQWebsiteCell.h"

// C
#import "ZQCommendController.h"

// VM





@interface ZQCommendController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tb;
@property (nonatomic, strong) NSArray <ZQSectionWebsiteModel *> *sections;
@end

@implementation ZQCommendController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self ui];
    [self refresh];
}

#pragma mark - 业务逻辑

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ZQSectionWebsiteModel *websiteSection = self.sections[section];
    NSArray <ZQWebsiteModel *> *websites = websiteSection.websites;
    return websites.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ZQCommendSectionView *v = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ZQCommendSectionView.className];
    ZQSectionWebsiteModel *websiteSection = self.sections[section];
    [v bind:websiteSection];
    return v;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZQSectionWebsiteModel *websiteSection = self.sections[indexPath.section];
    NSArray <ZQWebsiteModel *> *websites = websiteSection.websites;
    ZQWebsiteModel *model = websites[indexPath.row];
    ZQWebsiteCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(ZQWebsiteCell.class)];
    [cell bind:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZQSectionWebsiteModel *websiteSection = self.sections[indexPath.section];
    NSArray <ZQWebsiteModel *> *websites = websiteSection.websites;
    ZQWebsiteModel *model = websites[indexPath.row];
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:model.url]]) return;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.url]];

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    ZQSectionWebsiteModel *websiteSection = self.sections[indexPath.section];
    NSArray <ZQWebsiteModel *> *websites = websiteSection.websites;
    ZQWebsiteModel *model = websites[indexPath.row];
    ZQSimpleGetRequest *r = [ZQSimpleGetRequest new];
    r.url = @"Collectphone/recCollect";
    r.arguments = @{
        @"sign":ZQStatusDB.signCode?:@"",
        @"id":@((model.identifier?:@"").intValue)
    };
    [r startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (r.resultCode == 1) {
            [self toast:@"添加成功"];
        } else {
            [self toast:r.errorMessage];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self toast:@"网络错误"];
    }];
    tableView.editing = NO;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"收藏";
}


#pragma mark - 准备工作
- (MJRefreshHeader *)innerRefreshHeader {
    return self.tb.mj_header;
}

- (void)ui {
    self.view.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.tb];
    [self.tb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
}

- (void)refresh {
    ZQSimpleGetRequest *r = [ZQSimpleGetRequest new];
    r.url = @"Recommend/webList";
    [r startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.tb.mj_header endRefreshing];
        if (r.resultCode == 1) {
            NSArray *arr = [NSArray modelArrayWithClass:ZQSectionWebsiteModel.class json:r.responseJSONObject[@"class"]];
            self.sections = arr;
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
        t.rowHeight = UITableViewAutomaticDimension;
        t.estimatedSectionHeaderHeight =  40;
        t.sectionHeaderHeight = UITableViewAutomaticDimension;
        t.mj_header = [[MJRefreshNormalHeader alloc] init];
        [t registerClass:[ZQWebsiteCell class] forCellReuseIdentifier:NSStringFromClass(ZQWebsiteCell.class)];
        [t registerClass:[ZQCommendSectionView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([ZQCommendSectionView class])];
        _tb = t;
        t;
    });
}
@end
