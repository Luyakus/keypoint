//
//  ZQBaseController.m
//  KeyPoint
//
//  Created by Sam on 2020/6/14.
//  Copyright © 2020 Sam. All rights reserved.
//

#import "ZQBaseController.h"



@interface ZQBaseController ()
@property (nonatomic, strong) QMUITips *tips;
@end

@implementation ZQBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self zqConfigUI];
    [self zqBind];
}

#pragma mark - bind viewModel
- (ZQBaseViewModel *)innerViewModel {
    return nil;
}

- (MJRefreshHeader *)innerRefreshHeader {
    return nil;
}

- (MJRefreshFooter *)innerRefreshFooter {
    return nil;
}

- (void)zqBind {
    
    @weakify(self);
    self.innerRefreshHeader.refreshingBlock = ^{
        @strongify(self);
        [self refresh];
    };
    
    self.innerRefreshFooter.refreshingBlock = ^{
        @strongify(self);
        [self loadMore];
    };
    
    ZQBaseViewModel *viewModel = self.innerViewModel;
    if (!viewModel) return;
    
    [viewModel.loading subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        MJRefreshDispatchAsyncOnMainQueue([self showLoading];);
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        MJRefreshDispatchAsyncOnMainQueue([self hideLoading];);
    } completed:^{
        @strongify(self)
        MJRefreshDispatchAsyncOnMainQueue([self hideLoading];);
    }];
    
    [viewModel.empty subscribeNext:^(NSString *x) {
        @strongify(self)
        MJRefreshDispatchAsyncOnMainQueue(
            if ([x isKindOfClass:[NSString class]]) {
                self.emptyView.textLabel.text = x;
            }
            [self showEmptyView];
        );
    } completed:^{
        MJRefreshDispatchAsyncOnMainQueue([self hideEmptyView];);
    }];
    
    [viewModel.toast subscribeNext:^(NSString *x) {
        if (![x isKindOfClass:[NSString class]]) return;
        @strongify(self)
        MJRefreshDispatchAsyncOnMainQueue([self toast:x];);
    }];
    
    [viewModel.endRefresh subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.innerRefreshHeader endRefreshing];
    }];
    
    [viewModel.endLoadMore subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.innerRefreshFooter endRefreshing];
    }];
    
    
}



#pragma mark - Helper

- (void)loadMore {
    
}

- (void)refresh {
}

- (void)toast:(NSString *)text {
    [QMUITips showWithText:text];
}

- (void)showLoading {
    self.tips = [QMUITips showLoading:nil inView:self.view];
}

- (void)hideLoading {
    [self.tips hideAnimated:YES];
}

- (void)showLoadingAndHideAfterDelay:(NSTimeInterval)seconds {
    [QMUITips showLoadingInView:self.view hideAfterDelay:seconds];
}

#pragma mark - UI


- (void)zqConfigUI {
    self.view.backgroundColor = [UIColor colorWithRGB:0xf5f5f5];
    self.emptyView = [QMUIEmptyView new];
    self.emptyView.backgroundColor = [UIColor colorWithRGB:0xf5f5f5];
    self.emptyView.loadingView.hidden = YES;
    self.emptyView.imageView.image = [UIImage imageNamed:@"empty"];
    self.emptyView.textLabel.text = @"不要着急, 冷静一下";
}

- (BOOL)shouldHideKeyboardWhenTouchInView:(UIView *)view {
    return YES;
}

- (BOOL)shouldCustomizeNavigationBarTransitionIfHideable {
    return YES;
}

- (nullable NSString *)backBarButtonItemTitleWithPreviousViewController:(nullable UIViewController *)viewController {
    return @"";
}

- (BOOL)preferredNavigationBarHidden {
    return NO;
}

- (nullable UIColor *)navigationBarTintColor {
    return [UIColor colorWithRGB:0x1296db];
}

@end
