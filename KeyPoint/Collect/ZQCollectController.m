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
    ZQSectionWebsiteModel *websiteSection = self.sections[indexPath.section];
    NSArray <ZQWebsiteModel *> *websites = websiteSection.websites;
    ZQWebsiteModel *model = websites[indexPath.row];
    [self.viewModel deleteCollect:model];
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZQSectionWebsiteModel *websiteSection = self.sections[indexPath.section];
    NSArray <ZQWebsiteModel *> *websites = websiteSection.websites;
    ZQWebsiteModel *model = websites[indexPath.row];
        
    UITableViewRowAction *edit = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"修改" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入网站名称和网站地址" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.text = model.title;
            textField.placeholder = @"网站名称";
        }];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.text = model.url;
            textField.placeholder = @"网站地址";
        }];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.text = model.sectionTitle;
            textField.placeholder = @"网站分类";
        }];
        UIAlertAction *a = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (alert.textFields.firstObject.text.length == 0 ||
                alert.textFields[1].text.length == 0 ||
                alert.textFields.lastObject.text.length == 0) {
                [self toast:@"请输入完整的网站信息"];
                return;
            }
        
            ZQCollectRequest *r = [ZQCollectRequest requestWithWebsiteTitle:alert.textFields.firstObject.text url:alert.textFields.lastObject.text];
            [r startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                if (r.resultCode == 1) {
                    [self toast:@"添加成功"];
                    [self update];
                } else {
                    [self toast:r.errorMessage];
                }
            } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                [self toast:@"网络错误"];
            }];
        }];
        UIAlertAction *b = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        [alert addAction:a]; [alert addAction:b];
        [self presentViewController:alert animated:YES completion:nil];
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
