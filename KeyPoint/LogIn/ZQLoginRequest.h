//
//  ZQLoginRequest.h
//  KeyPoint
//
//  Created by Sam on 2020/6/18.
//  Copyright © 2020 Sam. All rights reserved.
//

#import "ZQBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZQLoginRequest : ZQBaseRequest
@property (nonatomic, copy) NSString *phoneNum;
@property (nonatomic, copy) NSString *authcode;
@end

NS_ASSUME_NONNULL_END
