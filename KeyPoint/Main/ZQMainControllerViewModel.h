//
//  ZQMainControllerViewModel.h
//  KeyPoint
//
//  Created by Sam on 2020/6/19.
//  Copyright © 2020 Sam. All rights reserved.
//

#import "ZQBaseRequest.h"
#import "ZQWebsiteModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZQMainControllerViewModel : ZQBaseModel
@property (nonatomic, strong) NSArray <ZQWebsiteModel *> *websites;
@end

NS_ASSUME_NONNULL_END
