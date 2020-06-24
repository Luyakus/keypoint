//
//  ZQBaseController.h
//  KeyPoint
//
//  Created by Sam on 2020/6/14.
//  Copyright © 2020 Sam. All rights reserved.
//

#import <QMUIKit/QMUIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZQBaseController : QMUICommonViewController
- (void)toast:(NSString *)text;
- (void)showLoading;
- (void)hideLoading;
- (void)showLoadingAndHideAfterDelay:(NSTimeInterval)seconds;

@end

NS_ASSUME_NONNULL_END
