//
//  ZQStatusDB.m
//  KeyPoint
//
//  Created by Sam on 2020/6/17.
//  Copyright © 2020 Sam. All rights reserved.
//

#import "ZQStatusDB.h"

@implementation ZQStatusDB
+ (BOOL)isLogin {
    return [NSUserDefaults.standardUserDefaults boolForKey:@"isLogin"];
}

+ (void)setIsLogin:(BOOL)isLogin {
    if (!isLogin) {
        [self setSignCode:nil];
    }
    [NSUserDefaults.standardUserDefaults setBool:isLogin forKey:@"isLogin"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [NSNotificationCenter.defaultCenter postNotificationName:ZQStatusDBLoginStatusChanged object:nil];
    });
}


+ (NSString *)signCode {
    return [NSUserDefaults.standardUserDefaults stringForKey:@"signCode"];
}

+ (void)setSignCode:(NSString *)signCode {
    [NSUserDefaults.standardUserDefaults setValue:signCode forKey:@"signCode"];
}
@end
