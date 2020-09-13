//
//  ZQCollectRequest.h
//  KeyPoint
//
//  Created by Sam on 2020/6/20.
//  Copyright © 2020 Sam. All rights reserved.
//

#import "ZQBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZQAddCommendRequest : ZQBaseRequest
+ (instancetype)requestWithWebsiteId:(NSString *)websiteId;
@end

NS_ASSUME_NONNULL_END
