//
//  ZQCommendViewModel.m
//  KeyPoint
//
//  Created by Sam on 2020/8/9.
//  Copyright © 2020 Sam. All rights reserved.
//
#import "ZQCollecViewModel.h"

@implementation ZQCollecViewModel
- (void) update{
    if (!ZQStatusDB.isLogin) {
        [self.empty sendNext:@"请先登录"];
        return;
    } else {
       [self.empty sendCompleted];
    }
    
    ZQSimplePostRequest *r = [ZQSimplePostRequest new];
    r.arguments = @{
        @"sign":ZQStatusDB.signCode?:@""
    };
    r.url = @"Collectphone/collectListApp";
    [r startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.endRefresh sendNext:nil];
        if (r.resultCode == 1) {
            NSArray *arr = [NSArray modelArrayWithClass:ZQSectionWebsiteModel.class json:r.responseJSONObject[@"classList"]];
            ZQSectionWebsiteModel *defaultSection = [ZQSectionWebsiteModel new];
            defaultSection.websites = [NSArray modelArrayWithClass:ZQWebsiteModel.class json:r.responseJSONObject[@"list"]];
            defaultSection.sectionTitle = @"默认";
            NSMutableArray *sections = arr.mutableCopy;
            [sections insertObject:defaultSection atIndex:0];
            self.sections = sections;
        } else {
            [self.toast sendNext:r.errorMessage];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.toast sendNext:@"网络错误"];
        [self.endRefresh sendNext:nil];
    }];
}

- (void)deleteCollect:(ZQWebsiteModel *)collect {
    ZQSimpleGetRequest *r = [ZQSimpleGetRequest new];
    r.url = @"Collectphone/delCollect";
    r.arguments = @{
        @"id":collect.identifier?:@"",
        @"sign":ZQStatusDB.signCode
    };
    [r startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (r.resultCode == 1) {
            [self.toast sendNext:@"已删除"];
            [self update];
        } else {
            [self.toast sendNext:r.errorMessage];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.toast sendNext:@"网络错误"];
    }];
}

- (void)editCollect:(ZQWebsiteModel *)collect {
    
}
@end
