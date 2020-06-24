//
//  ZQAuthcodeRequest.h
//  KeyPoint
//
//  Created by Sam on 2020/6/17.
//  Copyright © 2020 Sam. All rights reserved.
//

#import "ZQBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZQAuthcodeRequest : ZQBaseRequest
@property (nonatomic, copy) NSString *phoneNum;
@end

NS_ASSUME_NONNULL_END
