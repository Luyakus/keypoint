//
//  ZQUserInfoRequest.m
//  KeyPoint
//
//  Created by Sam on 2020/8/2.
//  Copyright © 2020 Sam. All rights reserved.
//

#import "ZQUserInfoRequest.h"

@implementation ZQUserInfoRequest
- (NSString *)requestUrl {
    return @"User/UserInfo";
}


- (id)requestArgument {
    return @{
        @"sign":ZQStatusDB.signCode?:@""
    };
}
@end
