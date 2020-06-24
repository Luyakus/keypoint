//
//  ZQSimpleRequest.m
//  KeyPoint
//
//  Created by Sam on 2020/6/19.
//  Copyright © 2020 Sam. All rights reserved.
//

#import "ZQSimpleRequest.h"

@implementation ZQSimpleRequest
- (NSString *)requestUrl {
    NSAssert(self.url, @"url 不能为空");
    return self.url;
}

- (id)requestArgument {
    return self.arguments;
}
@end

@implementation ZQSimpleGetRequest
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}
@end

@implementation ZQSimplePostRequest

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}
@end
