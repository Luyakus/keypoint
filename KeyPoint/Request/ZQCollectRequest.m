//
//  ZQCollectRequest.m
//  KeyPoint
//
//  Created by Sam on 2020/6/20.
//  Copyright © 2020 Sam. All rights reserved.
//

#import "ZQCollectRequest.h"

@implementation ZQCollectRequest
+ (instancetype)requestWithWebsiteTitle:(NSString *)title url:(NSString *)url {
    ZQSimplePostRequest *r = [ZQSimplePostRequest new];
    r.url = @"Collectphone/addCollect";
    r.arguments = @{
        @"sign":ZQStatusDB.signCode?:@"",
        @"webName":title?:@"",
        @"webUrl":url?:@"",
        @"is_type":@"1"
    };
    return (ZQCollectRequest *)r;
}
@end
