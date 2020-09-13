//
//  ZQCollectRequest.m
//  KeyPoint
//
//  Created by Sam on 2020/6/20.
//  Copyright © 2020 Sam. All rights reserved.
//

#import "ZQAddCommendRequest.h"

@implementation ZQAddCommendRequest
+ (instancetype)requestWithWebsiteId:(NSString *)websiteId {
    ZQSimplePostRequest *r = [ZQSimplePostRequest new];
    r.url = @"Collectphone/recCollect";
    r.arguments = @{
        @"sign":ZQStatusDB.signCode?:@"",
        @"id":websiteId?:@""
    };
    return (ZQAddCommendRequest *)r;
}
@end
