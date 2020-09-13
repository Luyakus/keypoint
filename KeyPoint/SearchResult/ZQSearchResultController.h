//
//  ZQSearchResultController.h
//  KeyPoint
//
//  Created by Sam on 2020/6/20.
//  Copyright © 2020 Sam. All rights reserved.
//

#import "ZQBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZQSearchResultController : ZQBaseController
- (instancetype)initWithKeyword:(NSString *)keyword;
- (instancetype)initWithKeyword:(NSString *)keyword DataSource:(NSArray<ZQWebsiteModel *> *)websites;
@end

NS_ASSUME_NONNULL_END
