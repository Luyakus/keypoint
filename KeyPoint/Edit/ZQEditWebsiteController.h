//
//  ZQEditWebsiteController.h
//  KeyPoint
//
//  Created by Sam on 2020/8/16.
//  Copyright © 2020 Sam. All rights reserved.
//

#import "ZQBaseController.h"
#import "ZQSectionWebsiteModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZQEditWebsiteController : ZQBaseController
- (instancetype)initWithSections:(NSArray <ZQSectionWebsiteModel *> *)sections webSite:(ZQWebsiteModel *)website editCompletionBlock:(void(^)(void))block;
@end

NS_ASSUME_NONNULL_END
