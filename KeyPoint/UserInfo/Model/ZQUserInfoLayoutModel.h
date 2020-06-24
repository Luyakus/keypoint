//
//  ZQUserInfoLayoutModel.h
//  KeyPoint
//
//  Created by Sam on 2020/6/16.
//  Copyright © 2020 Sam. All rights reserved.
//

#import "ZQBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZQUserInfoLayoutModel : ZQBaseModel
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *classString;
@property (nonatomic, copy) NSString *properName;
@property (nonatomic, copy) id value;
@end

NS_ASSUME_NONNULL_END
