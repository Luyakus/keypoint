//
//  ZQBaseRequest.m
//  KeyPoint
//
//  Created by Sam on 2020/6/16.
//  Copyright © 2020 Sam. All rights reserved.
//

#import "ZQBaseRequest.h"

@implementation ZQBaseRequest
- (instancetype)init {
    if (self = [super init]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            YTKNetworkAgent *agent = [YTKNetworkAgent sharedAgent];
            NSSet *acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html", @"text/css", nil];
            NSString *keypath = @"jsonResponseSerializer.acceptableContentTypes";
            [agent setValue:acceptableContentTypes forKeyPath:keypath];
        });
    }
    return self;
}

- (NSString *)baseUrl {
    return @"https://api.tvtvc.com/index.php/api/";
}

- (NSString *)failMessage {
    return @"";
}

- (NSString *)errorMessage {
    return [self.responseJSONObject objectForKey:@"msg"];
}

- (NSInteger)resultCode {
    return [[self.responseJSONObject objectForKey:@"code"] intValue];
}


@end
