//
//  ZQCollectSectionView.h
//  KeyPoint
//
//  Created by Sam on 2020/8/16.
//  Copyright © 2020 Sam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZQCollectSectionView : UITableViewHeaderFooterView
@property (nonatomic, copy) void(^editBlock)(id model);
- (void)bind:(id)model;
@end

NS_ASSUME_NONNULL_END
