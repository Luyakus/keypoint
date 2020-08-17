//
//  ZQEditSectionController.h
//  KeyPoint
//
//  Created by Sam on 2020/8/16.
//  Copyright © 2020 Sam. All rights reserved.
//

#import "ZQBaseController.h"
#import "ZQSectionWebsiteModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZQEditSectionController : ZQBaseController
- (instancetype)initWithSection:(ZQSectionWebsiteModel *)section editCompletionBlock:(void(^)(void))block;
@end

NS_ASSUME_NONNULL_END
