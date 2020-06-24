//
//  ZQAuthcodeRequest.m
//  KeyPoint
//
//  Created by Sam on 2020/6/17.
//  Copyright © 2020 Sam. All rights reserved.
//

#import "ZQAuthcodeRequest.h"

@implementation ZQAuthcodeRequest
- (NSString *)requestUrl {
    return @"User/Yzm";
}

- (id)requestArgument {
    return @{
        @"phone":self.phoneNum?:@""
    };
}


@end
