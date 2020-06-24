//
//  ZQSimpleRequest.h
//  KeyPoint
//
//  Created by Sam on 2020/6/19.
//  Copyright © 2020 Sam. All rights reserved.
//

#import "ZQBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZQSimpleRequest : ZQBaseRequest
@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong) id arguments;
@end


@interface ZQSimpleGetRequest : ZQSimpleRequest
@end

@interface ZQSimplePostRequest : ZQSimpleRequest
@end
NS_ASSUME_NONNULL_END
