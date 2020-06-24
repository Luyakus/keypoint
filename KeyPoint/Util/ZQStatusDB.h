//
//  ZQStatusDB.h
//  KeyPoint
//
//  Created by Sam on 2020/6/17.
//  Copyright © 2020 Sam. All rights reserved.
//

#import "ZQBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZQStatusDB : ZQBaseModel
@property (nonatomic, class) BOOL isLogin;
@property (nonatomic, class, nullable) NSString *signCode;
@end

NS_ASSUME_NONNULL_END
