//
//  ZQCollectController.m
//  KeyPoint
//
//  Created by Sam on 2020/6/19.
//  Copyright © 2020 Sam. All rights reserved.
//
// M
#import "ZQSectionWebsiteModel.h"
#import "ZQWebsiteModel.h"

// V
#import "ZQCollectSectionView.h"
#import "ZQWebsiteCell.h"

// C
#import "ZQCollectController.h"
#import "ZQEditSectionController.h"
#import "ZQEditWebsiteController.h"

// VM
#import "ZQCollecViewModel.h"

// R
#import "ZQCollectRequest.h"

@interface ZQCollectController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tb;
@property (nonatomic, strong) NSArray <ZQSectionWebsiteModel *> *sections;
@property (nonatomic, strong) ZQCollecViewModel *viewModel;
@end

@implementation ZQCollectController

- (instancetype)init {
    if (self = [super init]) {
        self.viewModel = [[ZQCollecViewModel alloc] init];
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
    @weakify(self)
    [[NSNotificationCenter.defaultCenter rac_addObserverForName:ZQStatusDBLoginStatusChanged object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        [self refresh];
    }];
      
    [RACObserve(self.viewModel, sections) subscribeNext:^(NSArray <ZQSectionWebsiteModel *> *x) {
        self.sections = x;
        [self.tb reloadData];
    }];
    [self update];
}

- (void)update {
    [self refresh];
}


#pragma mark - 协议

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ZQSectionWebsiteModel *websiteSection = self.sections[section];
    NSArray <ZQWebsiteModel *> *websites = websiteSection.websites;
    return websites.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ZQCollectSectionView *v = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ZQCollectSectionView.className];
    ZQSectionWebsiteModel *websiteSection = self.sections[section];
    [v bind:websiteSection];
    @weakify(self);
    v.editBlock = ^(ZQSectionWebsiteModel *model) {
        ZQEditSectionController *vc = [[ZQEditSectionController alloc] initWithSection:websiteSection editCompletionBlock:^{
            @strongify(self);
            [self refresh];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    };
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
    [self.viewModel deleteCollect:model];
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZQSectionWebsiteModel *websiteSection = self.sections[indexPath.section];
    NSArray <ZQWebsiteModel *> *websites = websiteSection.websites;
    ZQWebsiteModel *model = websites[indexPath.row];
    @weakify(self)
    UITableViewRowAction *edit = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"修改" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        @strongify(self)
        model.sectionTitle = websiteSection.sectionTitle;
        ZQEditWebsiteController *vc = [[ZQEditWebsiteController alloc] initWithSections:self.sections webSite:model editCompletionBlock:^{
            [self update];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    edit.backgroundColor = [UIColor systemBlueColor];
    
    UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [self.viewModel deleteCollect:model];
    }];
    
    return @[delete, edit];
}

#pragma mark - overwrite
- (void)refresh {
    [self.viewModel update];
}

- (MJRefreshHeader *)innerRefreshHeader {
    return self.tb.mj_header;
}

- (ZQBaseViewModel *)innerViewModel {
    return (ZQBaseViewModel *)self.viewModel;
}

- (NSArray<ZQSectionWebsiteModel *> *)sections {
    return self.viewModel.sections;
}

#pragma mark - 准备工作
- (void)ui {
    self.view.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.tb];
    [self.tb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
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
        [t registerClass:[ZQCollectSectionView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([ZQCollectSectionView class])];
        _tb = t;
        t;
    });
}

@end
