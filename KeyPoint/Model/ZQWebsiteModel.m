//
//  ZQWebsiteModel.m
//  KeyPoint
//
//  Created by Sam on 2020/6/10.
//  Copyright © 2020 Sam. All rights reserved.
//

#import "ZQWebsiteModel.h"

@implementation ZQWebsiteModel
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{
        @"url":@"webUrl",
        @"title":@"webName",
        @"identifier":@"id"
    };
}
@end
