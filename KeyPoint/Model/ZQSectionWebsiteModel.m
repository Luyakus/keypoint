//
//  ZQSectionWebsiteModel.m
//  KeyPoint
//
//  Created by Sam on 2020/8/9.
//  Copyright © 2020 Sam. All rights reserved.
//

#import "ZQSectionWebsiteModel.h"

@implementation ZQSectionWebsiteModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{
        @"sectionId":@"id",
        @"sectionTitle": @[@"webName", @"typeName"],
        @"websites":@"son"
    };
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
        @"websites":@"ZQWebsiteModel"
    };
}
@end
