//
//  ZQLoginRequest.m
//  KeyPoint
//
//  Created by Sam on 2020/6/18.
//  Copyright © 2020 Sam. All rights reserved.
//

#import "ZQLoginRequest.h"

@implementation ZQLoginRequest
- (NSString *)requestUrl {
    return @"User/login";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
        @"phone":self.phoneNum,
        @"yzm":self.authcode
    };
}
@end
