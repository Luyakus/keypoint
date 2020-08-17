//
//  ZQCommendViewModel.h
//  KeyPoint
//
//  Created by Sam on 2020/8/9.
//  Copyright © 2020 Sam. All rights reserved.
//

#import "ZQBaseViewModel.h"
#import "ZQSectionWebsiteModel.h"
#import "ZQWebsiteModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZQCollecViewModel : ZQBaseViewModel
@property (nonatomic, strong) NSArray <ZQSectionWebsiteModel *> *sections;

- (void)update;
- (void)deleteCollect:(ZQWebsiteModel *)collect;
- (void)editCollect:(ZQWebsiteModel *)collect;
@end

NS_ASSUME_NONNULL_END
