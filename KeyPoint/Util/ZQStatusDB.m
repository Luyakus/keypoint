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
    [NSNotificationCenter.defaultCenter postNotificationName:ZQStatusDBLoginStatusChanged object:nil];
}


+ (NSString *)signCode {
    return [NSUserDefaults.standardUserDefaults stringForKey:@"signCode"];
}

+ (void)setSignCode:(NSString *)signCode {
    [NSUserDefaults.standardUserDefaults setValue:signCode forKey:@"signCode"];
}
@end
