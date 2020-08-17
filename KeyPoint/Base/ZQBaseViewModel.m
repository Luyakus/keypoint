//
//  ZQBaseViewModel.m
//  KeyPoint
//
//  Created by Sam on 2020/8/9.
//  Copyright © 2020 Sam. All rights reserved.
//

#import "ZQBaseViewModel.h"
#import "ZQBaseController.h"
@interface ZQBaseViewModel()
@property (nonatomic, strong) RACSubject *loading;
@property (nonatomic, strong) RACSubject *empty;
@property (nonatomic, strong) RACSubject *toast;
@property (nonatomic, strong) RACSubject *endRefresh;
@property (nonatomic, strong) RACSubject *endLoadMore;
@end
@implementation ZQBaseViewModel
- (instancetype)init {
    if (self = [super init]) {
        self.toast = [RACSubject subject];
        self.empty = [RACSubject subject];
        self.toast = [RACSubject subject];
        self.endLoadMore = [RACSubject subject];
        self.endRefresh = [RACSubject subject];
    }
    return self;
}

@end
