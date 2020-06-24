//
//  ZQBaseRequest.h
//  KeyPoint
//
//  Created by Sam on 2020/6/16.
//  Copyright © 2020 Sam. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZQBaseRequest : YTKBaseRequest
@property (nonatomic, readonly) NSInteger resultCode;
@property (nonatomic, readonly) NSString *errorMessage;
@property (nonatomic, readonly) NSString *failMessage;
@end

NS_ASSUME_NONNULL_END
