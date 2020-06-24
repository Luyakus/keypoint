//
//  ZQUserInfoViewModel.h
//  KeyPoint
//
//  Created by Sam on 2020/6/16.
//  Copyright © 2020 Sam. All rights reserved.
//

#import "ZQBaseModel.h"
#import "ZQUserInfoLayoutModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZQUserInfoViewModel : ZQBaseModel
@property (nonatomic, copy) NSString *phoneNum;
@property (nonatomic, copy) NSString *sign;
@end

NS_ASSUME_NONNULL_END
