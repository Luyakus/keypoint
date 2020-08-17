//
//  ZQBaseViewModel.h
//  KeyPoint
//
//  Created by Sam on 2020/8/9.
//  Copyright © 2020 Sam. All rights reserved.
//

#import "ZQBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZQBaseViewModel : ZQBaseModel
@property (nonatomic, readonly) RACSubject *loading;
@property (nonatomic, readonly) RACSubject *empty;
@property (nonatomic, readonly) RACSubject *toast;
@property (nonatomic, readonly) RACSubject *endRefresh;
@property (nonatomic, readonly) RACSubject *endLoadMore;
@end

NS_ASSUME_NONNULL_END
