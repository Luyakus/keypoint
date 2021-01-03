//
//  ZQMainController.m
//  KeyPoint
//
//  Created by Sam on 2020/6/10.
//  Copyright © 2020 Sam. All rights reserved.
//

// M
#import "ZQAddCommendRequest.h"
// V
#import "ZQMainSearchBar.h"
#import "ZQMainBottomToolBar.h"
// C
#import "ZQUserInfoController.h"
#import "ZQLoginController.h"
#import "ZQMainController.h"
#import "ZQCommendController.h"
#import "ZQCollectController.h"
#import "ZQSearchResultController.h"
#import "ZQEditSectionController.h"
#import "ZQEditWebsiteController.h"

@interface ZQMainController () <UITextFieldDelegate>
@property (nonatomic, weak) ZQMainSearchBar *searchBar;
@property (nonatomic, weak) ZQMainBottomToolBar *toolBar;
@property (nonatomic, strong) UIView *contentHolder;
@property (nonatomic, strong) MASConstraint *contentLeft;
@property (nonatomic, assign) CGFloat contentOffset;
@property (nonatomic, weak) ZQCollectController *collectVC;
@end

@implementation ZQMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self ui];
    [self bind];
    [self checkNewVersion];
}

#pragma mark - 业务逻辑
- (void)bind {
    @weakify(self)
    
    [[NSNotificationCenter.defaultCenter rac_addObserverForName:ZQStatusDBLoginStatusChanged object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        [self.searchBar.avatarBtn setImage:[UIImage imageNamed:ZQStatusDB.isLogin ? @"avatar_blue" : @"avatar"] forState:UIControlStateNormal];
    }];
    
    [[self.searchBar.avatarBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        if (ZQStatusDB.isLogin) {
            ZQUserInfoController *userInfo = [ZQUserInfoController new];
            [self.navigationController pushViewController:userInfo animated:YES];
        } else {
            ZQLoginController *login = [ZQLoginController new];
            [self.navigationController pushViewController:login animated:YES];
        }
    }];
    
    [[self.searchBar.searchBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self search];
    }];
    
    [[self.searchBar.addBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        if (!ZQStatusDB.isLogin) {
            [self toast:@"请先登录"];
            return;
        }
        
        UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"提示" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *a = [UIAlertAction actionWithTitle:@"添加网站" style:UIAlertActionStyleDefault handler:^(__kindof UIAlertAction * _Nonnull action) {
            ZQWebsiteModel *website = [ZQWebsiteModel new];
            ZQEditWebsiteController *vc = [[ZQEditWebsiteController alloc] initWithSections:self.collectVC.allSections webSite:website editCompletionBlock:^{
                @strongify(self)
                [self.collectVC update];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        
        UIAlertAction *b = [UIAlertAction actionWithTitle:@"添加分类" style:UIAlertActionStyleDefault handler:^(__kindof UIAlertAction * _Nonnull action) {
            ZQSectionWebsiteModel *newSection = [ZQSectionWebsiteModel new];
            ZQEditSectionController *vc = [[ZQEditSectionController alloc] initWithSection:newSection editCompletionBlock:^{
                [self.collectVC update];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        
        UIAlertAction *c = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(__kindof UIAlertAction * _Nonnull action) {
        }];
        
        [vc addAction:a];
        [vc addAction:b];
        [vc addAction:c];
        [self presentViewController:vc animated:YES completion:nil];
    }];
    
    [[[self.toolBar.leftBtn rac_signalForControlEvents:UIControlEventTouchUpInside] merge:[self.toolBar.rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside]] subscribeNext:^(id  _Nullable x) {
        
        @strongify(self)
        if (!ZQStatusDB.isLogin && x == self.toolBar.rightBtn) {
            ZQLoginController *login = [ZQLoginController new];
            [self.navigationController pushViewController:login animated:YES];
        }
        
        if (x == self.toolBar.rightBtn) [self.collectVC update];
        [UIView animateWithDuration:0.3 animations:^{
            self.contentLeft.offset = self.contentOffset = x == self.toolBar.leftBtn ? 0 : -self.view.width;
            [self.searchBar.addBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.searchBar).offset(x == self.toolBar.rightBtn ? 15 : -30);
            }];
            [self.view layoutIfNeeded];
        }];
    }];
}

- (void)checkNewVersion {
    ZQSimpleGetRequest *r = [ZQSimpleGetRequest new];
    r.url = @"User/versions";
    [r startWithCompletionBlockWithSuccess:^(__kindof ZQSimpleGetRequest * _Nonnull request) {
        if (request.resultCode != 1) {
            return;
        }
        NSString *latestVersion = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"version"]];
        NSString *currentVerison = NSBundle.mainBundle.infoDictionary[@"CFBundleShortVersionString"];
        
        BOOL isVersionEqual = [currentVerison isEqualToString:latestVersion];
        if (isVersionEqual) {
            return;
        }
        UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"提示" message:@"有新的版本可以更新" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL *url = [NSURL URLWithString:@"https://apps.apple.com/cn/app/tvtvc/id1523479858"];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
        
        [vc addAction:confirm];
        [vc addAction:cancel];
        
        [self presentViewController:vc animated:YES completion:nil];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}

- (void)search {
    
    if (self.searchBar.searchTf.text.length == 0) {
        [self toast:@"搜索内容不能为空"];
        return;
    }
    
    if (!ZQStatusDB.isLogin) {
        ZQLoginController *login = [ZQLoginController new];
        [self.navigationController pushViewController:login animated:YES];
        return;
    }
    
    if (self.contentOffset == 0) {
        ZQSearchResultController *vc = [[ZQSearchResultController alloc] initWithKeyword:self.searchBar.searchTf.text];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        ZQSearchResultController *vc = [[ZQSearchResultController alloc] initWithKeyword:self.searchBar.searchTf.text DataSource:self.collectVC.allWebsites];
        [self.navigationController pushViewController:vc animated:YES];
    }
    [self.searchBar.searchTf resignFirstResponder];
    self.searchBar.searchTf.text = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.searchBar.searchTf) {
        [self search];
    }
    return YES;
}

#pragma mark - 准备工作

- (BOOL)preferredNavigationBarHidden {
    return YES;
}

- (void)ui {
    self.navigationController.navigationBar.hidden = YES;
    [self.view addSubview:self.searchBar];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset([UIApplication sharedApplication].statusBarFrame.size.height);
        make.height.mas_equalTo(55);
    }];
    self.searchBar.addBtnLeftOffsetConstraint.offset(-30);
    [self.searchBar.avatarBtn setImage:[UIImage imageNamed:ZQStatusDB.isLogin ? @"avatar_blue" : @"avatar"] forState:UIControlStateNormal];
    [self.view addSubview:self.toolBar];
    [self.toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
        make.height.mas_equalTo(50);
    }];
    
    self.contentHolder = [UIView new];
    [self.view addSubview:self.contentHolder];
    [self.contentHolder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBar.mas_bottom);
        make.bottom.equalTo(self.toolBar.mas_top);
        make.width.equalTo(self.view.mas_width).multipliedBy(2);
        self.contentLeft = make.left.equalTo(self.view).offset(0);
    }];
    
    ZQCollectController *collect = [ZQCollectController new];
    self.collectVC = collect;
    ZQCommendController *commmend = [ZQCommendController new];
    
    [self addChildViewController:commmend];
    [self addChildViewController:collect];
    
    [self.contentHolder addSubview:commmend.view];
    [commmend.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.contentHolder);
        make.right.equalTo(self.contentHolder.mas_centerX);
    }];
    
    [self.contentHolder addSubview:collect.view];
    [collect.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self.contentHolder);
        make.left.equalTo(self.contentHolder.mas_centerX);
    }];
}



- (ZQMainSearchBar *)searchBar {
    return _searchBar ?: ({
        ZQMainSearchBar *s = [ZQMainSearchBar new];
        s.searchTf.placeholder = @"搜索";
        s.searchTf.returnKeyType = UIReturnKeySearch;
        s.searchTf.delegate = self;
        _searchBar = s;
        s;
    });
}


- (ZQMainBottomToolBar *)toolBar {
    return _toolBar ?: ({
        ZQMainBottomToolBar *t = [ZQMainBottomToolBar new];
        [t.leftBtn setTitle:@"推荐" forState:UIControlStateNormal];
        [t.rightBtn setTitle:@"收藏" forState:UIControlStateNormal];
        _toolBar = t;
        t;
    });
}

@end
