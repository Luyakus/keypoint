//
//  ZQCollectController.h
//  KeyPoint
//
//  Created by Sam on 2020/6/19.
//  Copyright © 2020 Sam. All rights reserved.
//
#import "ZQSectionWebsiteModel.h"
#import "ZQBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZQCollectController : ZQBaseController
@property (nonatomic, readonly) NSArray <ZQSectionWebsiteModel *> *allSections;
@property (nonatomic, readonly) NSArray <ZQWebsiteModel *> *allWebsites;
- (void)update;
@end

NS_ASSUME_NONNULL_END
