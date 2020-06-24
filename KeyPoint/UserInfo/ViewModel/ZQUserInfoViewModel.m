//
//  ZQUserInfoViewModel.m
//  KeyPoint
//
//  Created by Sam on 2020/6/16.
//  Copyright © 2020 Sam. All rights reserved.
//

#import "ZQUserInfoViewModel.h"

@implementation ZQUserInfoViewModel
- (instancetype) init {
    if (self = [super init]) {
        ZQSimpleGetRequest *r = [ZQSimpleGetRequest new];
        r.arguments = @{
            @"sign":ZQStatusDB.signCode?:@""
        };
        [r startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            if (r.resultCode == 1) {
                NSString *phoneNum = r.responseJSONObject[@"info"][@"user"];
                NSString *sign = r.responseJSONObject[@"info"][@"sign"];
                self.phoneNum = phoneNum;
                self.sign = sign;
            } else {
                
            }
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
        }];
    }
    return self;
}


@end
