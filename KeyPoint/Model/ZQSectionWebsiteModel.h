//
//  ZQSectionWebsiteModel.h
//  KeyPoint
//
//  Created by Sam on 2020/8/9.
//  Copyright © 2020 Sam. All rights reserved.
//

#import "ZQBaseModel.h"
#import "ZQWebsiteModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZQSectionWebsiteModel : ZQBaseModel
@property (nonatomic, copy) NSString *sectionTitle;
@property (nonatomic, copy) NSString *sectionId;
@property (nonatomic, strong) NSArray <ZQWebsiteModel *> *websites;
@end

NS_ASSUME_NONNULL_END
